using MigrationToDRX.Data.Models.Dto;
using MigrationToDRX.Data.Services.DbServices;
using MigrationToDRX.Data.Helpers;
using MigrationToDRX.Data.Services.Settings;

namespace MigrationToDRX.Data.Services.Background;

public class BackgroundMigrationService : BackgroundService
{
    private readonly MigrationChannel _channel;
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<BackgroundMigrationService> _logger;

    public BackgroundMigrationService(
        MigrationChannel channel,
        IServiceScopeFactory scopeFactory,
        ILogger<BackgroundMigrationService> logger)
    {
        _channel = channel;
        _scopeFactory = scopeFactory;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("BackgroundMigrationService started and waiting for tasks...");

        await foreach (var task in _channel.Reader.ReadAllAsync(stoppingToken))
        {
            _logger.LogInformation("BackgroundMigrationService received task {TaskId} with {StageCount} stages",
                task.Id, task.Stages.Count);

            try
            {
                using var scope = _scopeFactory.CreateScope();
                var job = scope.ServiceProvider.GetRequiredService<MigrationJob>();

                await job.ExecuteAsync(task, stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "BackgroundMigrationService error processing task {TaskId}", task.Id);
            }
        }

        _logger.LogInformation("BackgroundMigrationService stopped");
    }
}

public enum JobStatus
{
    Ready,
    Process,
    Executed
}

public class MigrationJob
{
    private readonly ILogger<MigrationJob> _logger;
    private readonly OdataClientService _odataClientService;
    private readonly OperationService _operationService;

    public MigrationJob(ILogger<MigrationJob> logger, OdataClientService odataClientService, OperationService operationService)
    {
        _logger = logger;
        _operationService = operationService;
        _odataClientService = odataClientService;
    }

    public async Task ExecuteAsync(MigrationTask task, CancellationToken ct)
    {
        _logger.LogInformation("MigrationJob. Начало выполнения задачи {TaskId}", task.Id);

        // Получаем список EntitySets из OdataClientService
        var entitySets = _odataClientService.GetEntitySets();

        foreach (var stage in task.Stages)
        {
            if (ct.IsCancellationRequested)
            {
                _logger.LogWarning("MigrationJob. Задача {TaskId} отменена", task.Id);
                break;
            }

            try
            {
                stage.Status = StageStatus.Running;

                // Восстанавливаем IEdmEntitySet для этапа
                if (!string.IsNullOrEmpty(stage.SelectedEntitySetName))
                {
                    stage.SelectedEntitySet = entitySets.FirstOrDefault(e => e.Name == stage.SelectedEntitySetName);
                }

                await ProcessStageAsync(stage, ct);

                stage.Status = StageStatus.Processed;
                stage.LastExecutionTime = DateTime.Now;
                stage.LastExecutionResult = "Успешно";

                _logger.LogInformation("MigrationJob. Этап {StageName} успешно завершен", stage.Name);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MigrationJob. Обработка этапа {StageName} завершилась ошибкой", stage.Name);
                stage.Status = StageStatus.Error;
                stage.LastExecutionTime = DateTime.Now;
                stage.LastExecutionResult = ex.Message;

                // Прерываем выполнение при ошибке
                break;
            }
        }

        _logger.LogInformation("MigrationJob. Задача {TaskId} завершена", task.Id);
    }

    private async Task ProcessStageAsync(SettingStage stage, CancellationToken ct)
    {
        _logger.LogInformation("ProcessStageAsync. Начало обработки этапа {StageName}", stage.Name);

        if (stage.SourceType == Enums.SourceType.DatabaseMssql)
        {
            await ProcessMssqlStageAsync(stage, ct);
        }
    }

    private async Task ProcessMssqlStageAsync(SettingStage stage, CancellationToken ct)
    {
        _logger.LogInformation("ProcessMssqlStage. Начало обработки этапа {StageName}", stage.Name);

        if (string.IsNullOrWhiteSpace(stage.ConnectionString))
            throw new ArgumentNullException(nameof(stage.ConnectionString),
                $"Не заданы настройки подключения в этапе {stage.Name}");

        if (string.IsNullOrWhiteSpace(stage.SelectedTable))
            throw new ArgumentNullException(nameof(stage.SelectedTable),
                $"Не выбрана таблица из которой читаются данные в этапе {stage.Name}");

        if (string.IsNullOrWhiteSpace(stage.SelectedEntitySetName))
            throw new ArgumentNullException(nameof(stage.SelectedEntitySetName),
                $"Не выбран EntitySet в этапе {stage.Name}");

        using var dbService = new MssqlService(stage.ConnectionString, _logger);
        await dbService.ConnectAsync();

        var data = await dbService.ReadTableAsync(stage.SelectedTable, filter: "where Result = null", take: 50);

        var entityDto = _odataClientService.GetEdmxEntityDto(stage.SelectedEntitySetName);
        if (entityDto == null)
            throw new InvalidOperationException($"Не удалось получить метаданные для EntitySet {stage.SelectedEntitySetName}");

        var entityFields = EntityHelper.GetEntityFields(entityDto);

        var savedMappings = stage.ColumnMappings != null && stage.ColumnMappings.Any()
            ? new Dictionary<string, string?>(stage.ColumnMappings)
            : new Dictionary<string, string?>();

        var columnMappings = savedMappings.ToDictionary(
            kvp => kvp.Key,
            kvp => string.IsNullOrEmpty(kvp.Value)
                ? null
                : entityFields.FirstOrDefault(f => f.Name == kvp.Value)
        );

        int processedRows = 0;
        int successRows = 0;
        int errorRows = 0;

        foreach (var row in data)
        {
            if (ct.IsCancellationRequested)
                break;

            var rowAsStrings = row.ToDictionary(
                kvp => kvp.Key,
                kvp => kvp.Value?.ToString() ?? string.Empty
            );

            var dto = new ProcessedEntityDto()
            {
                ColumnMapping = columnMappings,
                Row = rowAsStrings,
                SearchCriteria = stage.SearchCriteria,
                EntitySetName = stage.SelectedEntitySetName ?? string.Empty,
                ChildEntitySetName = stage.SelectedCollectionPropertyName,
                IsCollection = !string.IsNullOrEmpty(stage.SelectedCollectionPropertyName),
                Operation = stage.Operation,
            };

            var externalId = row["Id"].ToString() ?? string.Empty;

            try
            {
                var result = await _operationService.ExecuteOperation(dto, ct);

                if (result.Success)
                {
                    _logger.LogInformation("ProcessMssqlStage. Запись {} таблицы {} успешно загружена", externalId, stage.SelectedTable);
                    successRows++;
                    await dbService.UpdateDbMigrationResult(stage.SelectedTable, externalId, "Migrated", DateTime.UtcNow);
                }
                else
                {
                    _logger.LogError("ProcessMssqlStage. Ошибка обработки строки {}. Сообщение: {}", externalId, result.ErrorMessage);
                    errorRows++;
                    await dbService.UpdateDbMigrationResult(stage.SelectedTable, externalId, "MigratedError", DateTime.UtcNow, result.ErrorMessage);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ProcessMssqlStage. Ошибка обработки строки {}", externalId);
                errorRows++;
                await dbService.UpdateDbMigrationResult(stage.SelectedTable, externalId, "MigratedError", DateTime.UtcNow, ex.Message);
            }

            processedRows++;
            stage.ProgressPercent = data.Count > 0 ? (processedRows * 100) / data.Count : 100;
        }

        stage.LastProcessedRows = processedRows;
        stage.LastSuccessfulRows = successRows;
        stage.LastErrorRows = errorRows;
    }
}
