using Microsoft.AspNetCore.Components;
using Microsoft.OData.Edm;
using MigrationToDRX.Data.Constants;
using MigrationToDRX.Data.Enums;
using MigrationToDRX.Data.Extensions;
using MigrationToDRX.Data.Helpers;
using MigrationToDRX.Data.Models.Dto;
using MigrationToDRX.Data.Services;
using Radzen;
using Microsoft.JSInterop;
using Radzen.Blazor;
using MigrationToDRX.Data.Services.DbServices;
using MigrationToDRX.Data.Models.ViewModels;
using MigrationToDRX.Data.Services.Settings;
namespace MigrationToDRX.Pages;

public partial class MainPage
{

    /// <summary>
    /// Выбранный тип миграции (Excel, БД)
    /// </summary>
    protected SourceType SelectedSourceType { get; set; }

    /// <summary>
    /// Строка подключения к базе данных
    /// </summary>
    public string? DbConnectionString { get; set; }

    /// <summary>
    /// Сервис
    /// </summary>
    protected DbService? DbService { get; set; }

    /// <summary>
    /// Таблицы, полученные из БД
    /// </summary>
    public List<string> DbTables { get; set; } = new();

    /// <summary>
    /// Выбранная таблица БД для загрузки в RX
    /// </summary>
    public string? SelectedTable { get; set; }

    /// <summary>
    /// Установлено ли успешно соединение с БД
    /// </summary>
    protected bool IsDbConnectionSuccess => DbService?.IsConnected ?? false;

    /// <summary>
    /// Список типов источника для выбора
    /// </summary>
    private List<EnumItem<SourceType>> SourceTypes { get; set; } = new();

    /// <summary>
    /// Выбранная операция миграции
    /// </summary>
    protected OdataOperation SelectedOperation { get; set; }

    /// <summary>
    /// Список операций для выбора
    /// </summary>
    private List<EnumItem<OdataOperation>> OperationItems { get; set; } = new();

    /// <summary>
    /// Выбранный поиск навигационных свойств
    /// </summary>
    protected SearchEntityBy SearchCriteria { get; set; }

    /// <summary>
    /// Список полей для поиска навигационных свойств
    /// </summary>
    private List<EnumItem<SearchEntityBy>> SearchEntityByList { get; set; } = new();

    /// <summary>
    /// Выбранный EntitySet
    /// </summary>
    protected IEdmEntitySet? SelectedEntitySet { get; set; }

    /// <summary>
    /// Список всех сущностей в OData
    /// </summary>
    private List<IEdmEntitySet> EntitySets { get; set; } = new();

    /// <summary>
    /// Выбранное свойство-коллекция
    /// </summary>
    protected NavigationPropertyDto? SelectedCollectionProperty { get; set; }

    /// <summary>
    /// Список свойств-коллекций в выбранной сущности
    /// </summary>
    private List<NavigationPropertyDto> CollectionProperties { get; set; } = new();

    /// <summary>
    /// Список полей сущности, полученных из OData
    /// </summary>
    protected List<EntityFieldDto> EntityFields { get; set; } = new();

    protected HashSet<EntityFieldDto> AvailableEntityFields => EntityFields.Where(f => !ColumnMappings.Any(c => c.Value == f)).ToHashSet();

    /// <summary>
    /// Список колонок, загруженных из Excel
    /// </summary>
    private List<string> TableColumns { get; set; } = new();

    /// <summary>
    /// Строки Excel, загруженные из файла
    /// </summary>
    private List<Dictionary<string, string>> PreviewRows { get; set; } = new();

    /// <summary>
    /// Словарь "имя колонки → список доступных полей".
    /// Используется для привязки данных к каждому DropDown в таблице.
    /// </summary>
    protected Dictionary<string, EntityFieldDto?> ColumnMappings { get; set; } = new();

    /// <summary>
    /// Загружать все строки из Excel
    /// </summary>
    protected bool UploadAllRows { get; set; } = true;

    /// <summary>
    /// Повторно загружать обработанные строки
    /// </summary>
    protected bool ForceUploadProcessedRows { get; set; } = false;

    /// <summary>
    /// Количество строк для загрузки
    /// </summary>
    protected int RowsToUpload { get; set; } = 100;

    /// <summary>
    /// Начальная строка для загрузки
    /// </summary>
    protected int StartFrom { get; set; } = 1;

    /// <summary>
    /// Признак того, что пользователь отменил операцию
    /// </summary>
    //protected bool cancelRequested = false;

    /// <summary>
    /// Признак того, что операция выполняется
    /// </summary>
    protected bool isProceed = false;

    /// <summary>
    /// Максимальное количество строк для обработки
    /// </summary>
    protected int maxRowsCount = 0;

    protected string Unit => $" / {maxRowsCount}";

    private int progress { get; set; }

    /// <summary>
    /// Имя файла для выгрузки
    /// </summary>
    protected string? FileName { get; set; }

    private CancellationTokenSource? cancelRequested;

    /// <summary>
    /// Сервис для работы с OData клиентом
    /// </summary>
    [Inject]
    protected OdataClientService OdataClientService { get; set; } = null!;

    [Inject]
    protected OperationService OperationService { get; set; } = null!;

    /// <summary>
    /// Сервис для работы с уведомлениями
    /// </summary>
    [Inject]
    protected NotificationService NotificationService { get; set; } = null!;

    /// <summary>
    /// Сервис для работы с Excel
    /// </summary>
    [Inject]
    protected ExcelService ExcelService { get; set; } = null!;

    /// <summary>
    /// Сервис для работы с EdmxEntity
    /// </summary>
    [Inject]
    protected EntityService EntityService { get; set; } = null!;

    [Inject]
    protected IJSRuntime JS { get; set; } = null!;

    /// <summary>
    /// Cервис для работы с диалогами
    /// </summary>
    [Inject]
    private DialogService DialogService { get; set; } = null!;

    /// <summary>
    /// Сервис для работы с навигацией
    /// </summary>
    [Inject]
    private NavigationManager NavigationManager { get; set; } = null!;

    /// <summary>
    /// Сервис для работы с файлом конфигурации
    /// </summary>
    [Inject]
    private SettingService SettingService { get; set; } = null!;

    /// <summary>
    /// Признак подключения к OData сервису
    /// </summary>
    private bool IsConnected => OdataClientService.IsConnected;

    private RadzenDataGrid<Dictionary<string, string>>? dataGrid;

    /// <summary>
    /// Включить расширенные операции
    /// </summary>
    protected bool EnableExtendedOperations { get; set; } = false;

    /// <summary>
    /// Список настроек этапов миграции
    /// </summary>
    protected List<SettingStage> SettingStages { get; set; } = new();

    /// <summary>
    /// Выбранный этап для редактирования
    /// </summary>
    protected SettingStage? SelectedStage { get; set; }

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        await base.OnAfterRenderAsync(firstRender);
        if (firstRender)
        {
            if (IsConnected == false)
            {
                await InvokeAsync(async () =>
                {
                    await DialogService.Alert(
                        "Потеряно соединение с сервисом интеграции DirectumRX.\n" +
                        "Вы будете перенаправлены на страницу авторизации",
                        "Ошибка",
                        new AlertOptions
                        {
                            OkButtonText = "Ок",
                            CloseDialogOnEsc = false,
                            CloseDialogOnOverlayClick = false,
                            ShowClose = false
                        });
                });
                NavigationManager.NavigateTo("/");
                return;
            }
        }
    }

    /// <summary>
    /// Обработчик изменения выбранной операции
    /// </summary>
    private void OnSelectedOperationChanged()
    {
        OdataOperationHelper.AddPropertiesByOperation(SelectedOperation, EntityFields, ColumnMappings);
        StateHasChanged();
    }

    /// <summary>
    /// Инициализация страницы
    /// </summary>
    /// <returns></returns>
    protected override async Task OnInitializedAsync()
    {
        await base.OnInitializedAsync();
        // получаем список сущностей из OData
        EntitySets = OdataClientService.GetEntitySets().OrderBy(e => e.Name).ToList();

        // получаем список типов источинка
        SourceTypes = Data.Helpers.EnumHelper.GetItems<SourceType>();

        // получаем список операций для выбора
        OperationItems = Data.Helpers.EnumHelper.GetItems<OdataOperation>()
            .Where(op => !IsExtendedOperation(op.Value))
            .ToList();

        // получаем список полей для поиска навигационных свойств
        SearchEntityByList = Data.Helpers.EnumHelper.GetItems<SearchEntityBy>();

        // загружаем настройки этапов
        await LoadSettingStages();
    }

    /// <summary>
    /// Загрузка настроек этапов миграции
    /// </summary>
    private async Task LoadSettingStages()
    {
        SettingStages = await SettingService.GetSettingStages();

        // Восстанавливаем IEdmEntitySet для каждого этапа
        foreach (var stage in SettingStages)
        {
            if (!string.IsNullOrEmpty(stage.SelectedEntitySetName))
            {
                stage.SelectedEntitySet = EntitySets.FirstOrDefault(e => e.Name == stage.SelectedEntitySetName);
            }
        }
    }

    /// <summary>
    /// Обработчик изменения SelectedEntitySet
    /// </summary>
    protected void OnSelectedEntitySetChanged(object value)
    {
        if (SelectedEntitySet == null)
        {
            // очищаем список полей
            EntityFields = new();
            // Сбрасываем маппинг
            ColumnMappings = TableColumns.Any() ? TableColumns.ToDictionary(c => c, _ => (EntityFieldDto?)null) : new();
            return;
        }

        // Получаем метаданные сущности и парсим поля
        if (OdataClientService.GetEdmxEntityDto(SelectedEntitySet.Name) is { } dto)
        {
            // Заполняем поля сущности
            EntityFields = EntityHelper.GetEntityFields(dto);
            // Добавляем свойства сущности в зависимости от операции
            OdataOperationHelper.AddPropertiesByOperation(SelectedOperation, EntityFields, ColumnMappings);
            // Заполняем список свойств-коллекций
            CollectionProperties = dto.NavigationProperties.Where(p => p.IsCollection).ToList();
            // Сбрасываем маппинг
            ColumnMappings = TableColumns.ToDictionary(c => c, _ => (EntityFieldDto?)null);
        }

        StateHasChanged();
    }

    /// <summary>
    /// Обработчик изменения SelectedCollectionProperty
    /// </summary>
    protected void OnSelectedCollectionPropertyChanged(object value)
    {
        if (SelectedCollectionProperty == null)
        {
            EntityFields = new();
            ColumnMappings = TableColumns.Any() ? TableColumns.ToDictionary(c => c, _ => (EntityFieldDto?)null) : new();
            return;
        }

        var dto = OdataClientService.GetChildEntities(SelectedCollectionProperty);
        EntityFields = EntityHelper.GetEntityFields(dto);
        OdataOperationHelper.AddPropertiesByOperation(SelectedOperation, EntityFields, ColumnMappings);
        ClearExcelToFieldsMapping();

        StateHasChanged();
    }

    /// <summary>
    /// Обработчик загрузки файла
    /// </summary>
    private async Task OnFileUpload(UploadChangeEventArgs args)
    {
        ColumnMappings = new();
        PreviewRows = new();
        TableColumns = new();

        // Если нет файла — очищаем связанные словари и списки
        if (args.Files == null || !args.Files.Any())
        {
            StateHasChanged();
            return;
        }

        var file = args.Files.FirstOrDefault();
        if (file != null)
        {
            FileName = file.Name;

            using var stream = new MemoryStream();
            await file.OpenReadStream(SystemConstants.MaxExcelFileSize).CopyToAsync(stream);
            stream.Position = 0;

            var rows = ExcelService.ReadExcel(stream);

            if (rows.Count == 0)
            {
                TableColumns = new List<string>();
                PreviewRows = new List<Dictionary<string, string>>();
                return;
            }

            // Формируем список колонок из заголовков
            //HACK: Внимание! Если заголовков нет, то будет использоваться первая строка!
            // Данные этой строки НЕ БУДУТ загружены в OData!
            TableColumns = rows.First().Keys.ToList();

            // Формируем PreviewRows (берем максимум 5-6 строк)
            PreviewRows = rows
            // HACK:    .Take(6) <= Так можно ограничить, сколько строк мы забираем и храним в памяти
                .Select(row => TableColumns.ToDictionary(
                    col => col,
                    col => row[col].ToString() ?? string.Empty))
                .ToList();

            RowsToUpload = PreviewRows.Count;

            // Сбрасываем маппинг
            ClearExcelToFieldsMapping();

        }
        else
        {
            NotificationService.Notify(new NotificationMessage
            {
                Summary = "Ошибка",
                Detail = "Не загрузить документ",
                Severity = NotificationSeverity.Error,
                Duration = 4000
            });
        }

        StateHasChanged();
    }

    /// <summary>
    /// Обработчик загрузки таблицы БД
    /// </summary>
    private async Task OnDbTableChanged()
    {
        if (DbService is null)
        {
            await InvokeAsync(async () =>
            {
                await DialogService.Alert(
                    "Получение данных из таблицы БД\n" +
                    "Не удалось получить данные из таблицы БД. Сервис БД не инициализирован.",
                    "Ошибка",
                    new AlertOptions
                    {
                        OkButtonText = "Ок",
                        CloseDialogOnEsc = false,
                        CloseDialogOnOverlayClick = false,
                        ShowClose = false
                    });
            });
            return;
        }

        if (string.IsNullOrWhiteSpace(SelectedTable))
        {
            await InvokeAsync(async () =>
            {
                await DialogService.Alert(
                    "Получение данных из таблицы БД\n" +
                    "Не выбрана таблица для получения данных.",
                    "Ошибка",
                    new AlertOptions
                    {
                        OkButtonText = "Ок",
                        CloseDialogOnEsc = false,
                        CloseDialogOnOverlayClick = false,
                        ShowClose = false
                    });
            });
            return;
        }

        ColumnMappings = new();
        PreviewRows = new();
        TableColumns = new();

        // Если нет файла — очищаем связанные словари и списки

        var rows = await DbService.ReadTableAsync(SelectedTable);

        if (rows.Count == 0)
        {
            TableColumns = new List<string>();
            PreviewRows = new List<Dictionary<string, string>>();
            return;
        }

        // Формируем список колонок из заголовков
        //HACK: Внимание! Если заголовков нет, то будет использоваться первая строка!
        // Данные этой строки НЕ БУДУТ загружены в OData!
        TableColumns = rows.First().Keys.ToList();

        // Формируем PreviewRows (берем максимум 5-6 строк)
        PreviewRows = rows
        // HACK:    .Take(6) <= Так можно ограничить, сколько строк мы забираем и храним в памяти
            .Select(row => TableColumns.ToDictionary(
                col => col,
                col => row[col].ToString() ?? string.Empty))
            .ToList();

        RowsToUpload = PreviewRows.Count;

        // Сбрасываем маппинг
        ClearExcelToFieldsMapping();

        StateHasChanged();
    }

    /// <summary>
    /// Возвращает список доступных полей для выбора в колонке
    /// </summary>
    /// <param name="column">Колонка</param>
    /// <returns></returns>
    private IEnumerable<EntityFieldDto> GetAvailableEntityFields(string column)
    {
        // Берем все поля
        var allFields = EntityFields;

        // Исключаем те, что уже выбраны в других колонках
        var selectedFields = ColumnMappings
            .Where(kv => kv.Key != column && kv.Value != null)
            .Select(kv => kv.Value)
            .ToHashSet();

        return allFields.Where(f => !selectedFields.Contains(f));
    }

    /// <summary>
    /// Очищает словарь со свойствами сущности в Excel
    /// </summary>
    private void ClearExcelToFieldsMapping()
    {
        ColumnMappings = TableColumns.Any() ? TableColumns.ToDictionary(c => c, _ => (EntityFieldDto?)null) : new();
    }

    private async Task Validate()
    {
        if (ColumnMappings.Any() == false || PreviewRows.Any() == false)
        {
            return;
        }

        cancelRequested?.Cancel();
        cancelRequested?.Dispose();

        cancelRequested = new CancellationTokenSource();
        var ct = cancelRequested.Token;

        isProceed = true;

        var validationColumns = OdataOperationHelper.GetDisplayNames<ValidationResult>();
        CreateResultColumns(validationColumns);
        var resultColumnName = OdataOperationHelper.GetDisplayName<ValidationResult>(nameof(ValidationResult.Success));

        StartFrom = UploadAllRows ? 1 : StartFrom;
        maxRowsCount = UploadAllRows ? PreviewRows.Count : RowsToUpload + StartFrom - 1;
        maxRowsCount = maxRowsCount > PreviewRows.Count ? PreviewRows.Count : maxRowsCount;

        progress = 0;

        StateHasChanged();
        await Task.Delay(10);

        for (int i = StartFrom - 1; i < maxRowsCount; i++)
        {
            // Даем UI обработать события (в т.ч. нажатие Отмена)
            await Task.Delay(1, ct);
            ct.ThrowIfCancellationRequested();

            var row = PreviewRows[i];
            var dto = new ProcessedEntityDto()
            {
                ColumnMapping = ColumnMappings,
                Row = row,
                SearchCriteria = SearchCriteria,
                EntitySetName = SelectedEntitySet?.Name ?? string.Empty,
                ChildEntitySetName = SelectedCollectionProperty?.Name,
                IsCollection = SelectedCollectionProperty != null,
                Operation = SelectedOperation,
            };

            try
            {
                var result = await EntityService.ValidateEntity(dto, ct);
                row[resultColumnName] = result.Success ?? string.Empty;
                continue;
            }
            catch (OperationCanceledException)
            {
                isProceed = false;
                break;
            }
            catch (Exception e)
            {
                row[resultColumnName] = e.Message;
                continue;
            }
            finally
            {
                progress = i + 1;
                StateHasChanged();
            }


        }
        isProceed = false;
    }

    private async Task Upload()
    {
        if (ColumnMappings.Any() == false || PreviewRows.Any() == false)
        {
            return;
        }

        cancelRequested?.Cancel();
        cancelRequested?.Dispose();

        cancelRequested = new CancellationTokenSource();
        var ct = cancelRequested.Token;

        isProceed = true;

        var validationColumns = OdataOperationHelper.GetDisplayNames<OperationResult>();

        CreateResultColumns(validationColumns);

        var resultColumnName = OdataOperationHelper.GetDisplayName<OperationResult>(nameof(OperationResult.Success));
        var timeStampColumnName = OdataOperationHelper.GetDisplayName<OperationResult>(nameof(OperationResult.Timestamp));
        var signColumnName = OdataOperationHelper.GetDisplayName<OperationResult>(nameof(OperationResult.Stamp));
        var operationNameColumnName = OdataOperationHelper.GetDisplayName<OperationResult>(nameof(OperationResult.OperationName));
        var errorsColumnName = OdataOperationHelper.GetDisplayName<OperationResult>(nameof(OperationResult.ErrorMessage));
        var idColumnName = OdataOperationHelper.GetDisplayName<OperationResult>(nameof(OperationResult.EntityId));

        StartFrom = UploadAllRows ? 1 : StartFrom;
        maxRowsCount = UploadAllRows ? PreviewRows.Count : RowsToUpload + StartFrom - 1;
        maxRowsCount = maxRowsCount > PreviewRows.Count ? PreviewRows.Count : maxRowsCount;

        progress = 0;

        StateHasChanged();
        await Task.Delay(10);

        for (int i = StartFrom - 1; i < maxRowsCount; i++)
        {
            await Task.Delay(1, ct);
            ct.ThrowIfCancellationRequested();

            var row = PreviewRows[i];

            if (string.IsNullOrWhiteSpace(row[resultColumnName]) == false && row[resultColumnName]?.ToString() != "Да")
            {
                // валидация не удалась, пропускаем
                row[errorsColumnName] = "Валидация не удалась";
                continue;
            }

            if (string.IsNullOrWhiteSpace(row[signColumnName]) == false && ForceUploadProcessedRows == false)
            {
                // TODO: Вычислять, что подпись проставлена именно этой программой.
                row[errorsColumnName] = "Строка уже была обработана в прошлом запросе.\n Чтобы повторно обработать строку, поставьте галочку \"в том числе уже обработанные\"";

                // Если подпись стоит, значит уже была обработана в прошлом запросе
                continue;
            }

            var dto = new ProcessedEntityDto()
            {
                ColumnMapping = ColumnMappings,
                Row = row,
                SearchCriteria = SearchCriteria,
                EntitySetName = SelectedEntitySet?.Name ?? string.Empty,
                ChildEntitySetName = SelectedCollectionProperty?.Name,
                IsCollection = SelectedCollectionProperty != null,
                Operation = SelectedOperation,
            };

            try
            {
                var result = await OperationService.ExecuteOperation(dto, ct);

                if (result == null)
                {
                    throw new Exception("Не удалось провести операцию");
                }

                if (result.Success == false)
                {
                    throw new Exception($"Операция не удалась: {result.ErrorMessage}");
                }

                row[resultColumnName] = result.Success ? "Да" : "Нет";
                row[timeStampColumnName] = result.Timestamp.ToLongTimeString();
                row[signColumnName] = result.Stamp;
                row[operationNameColumnName] = SelectedOperation.GetDisplayName() ?? string.Empty;

                // Не изменять Идентификатор сущности для операций только со служебными свойствами.
                if (OdataOperationHelper.RequiresEntityIdInResult(dto.Operation) && result.EntityId != null)
                {
                    row[idColumnName] = result.EntityId.ToString() ?? string.Empty;
                }
                // Для очистки предыдущих ошибок
                row[errorsColumnName] = string.Empty;

                continue;
            }
            catch (OperationCanceledException)
            {
                isProceed = false;
                break;
            }
            catch (Exception ex)
            {
                row[resultColumnName] = "Нет";
                row[operationNameColumnName] = SelectedOperation.GetDisplayName() ?? string.Empty;
                row[errorsColumnName] = ex.Message + (string.IsNullOrWhiteSpace(ex.InnerException?.Message) ? string.Empty : " : " + ex.InnerException?.Message);

                continue;
            }
            finally
            {
                progress = i + 1;
                StateHasChanged();
            }
        }

        isProceed = false;
    }

    /// <summary>
    /// Скачивает файл Excel с отчетом
    /// </summary>
    private async Task DownloadExcel()
    {
        var fileBytes = ExcelService.GetExcelBytes(PreviewRows, TableColumns, "Отчет");
        var base64 = Convert.ToBase64String(fileBytes);
        await JS.InvokeVoidAsync("downloadFileFromBase64", $"Отчет_по_{FileName}_{SelectedOperation.GetDisplayName()}_за_{DateTime.Now.ToShortDateString()}.xlsx", base64);
    }

    /// <summary>
    /// Выбран тип источинка Excel
    /// </summary>
    /// <returns></returns>
    private bool SelectedExcelSourceType() => SelectedSourceType == SourceType.Excel;

    /// <summary>
    /// Выбран тип источинка База данных MSSQL
    /// </summary>
    /// <returns></returns>
    private bool SelectedDatabaseMssqlSourceType() => SelectedSourceType == SourceType.DatabaseMssql;

    /// <summary>
    /// Подключиться к БД по строке подключения
    /// </summary>
    /// <returns></returns>
    private async Task ConnectToDatabase()
    {
        if (string.IsNullOrWhiteSpace(DbConnectionString))
        {
            await InvokeAsync(async () =>
            {
                await DialogService.Alert(
                    "Подключение к базе данных\n" +
                    "Не удалось подключиться к базе данных. Проверьте строку подключения.",
                    "Ошибка",
                    new AlertOptions
                    {
                        OkButtonText = "Ок",
                        CloseDialogOnEsc = false,
                        CloseDialogOnOverlayClick = false,
                        ShowClose = false
                    });
            });
            DbService = null;
            return;
        }

        try
        {
            switch (SelectedSourceType)
            {
                case SourceType.DatabaseMssql: DbService = new MssqlService(DbConnectionString); break;
                default: return;
            }

            await DbService.ConnectAsync();
            DbTables = (await DbService.GetTablesAsync()).ToList();
        }
        catch (Exception ex)
        {
            await InvokeAsync(async () =>
            {
                await DialogService.Alert(
                    "Подключение к базе данных\n" +
                    $"Не удалось подключиться к базе данных: {ex.Message}",
                    "Ошибка",
                    new AlertOptions
                    {
                        OkButtonText = "Ок",
                        CloseDialogOnEsc = false,
                        CloseDialogOnOverlayClick = false,
                        ShowClose = false
                    });
            });
            DbService = null;
        }
    }

    /// <summary>
    /// Создает список колонок в таблицу
    /// </summary>
    private void CreateResultColumns(List<string>? resultColumns)
    {
        if (resultColumns == null)
        {
            return;
        }
        // Определяем, какие новые колонки действительно нужно добавить
        var newColumns = resultColumns.Except(TableColumns).ToList();

        // Добавляем их в ExcelColumns и ColumnMappings
        TableColumns.AddRange(newColumns);
        foreach (var col in newColumns)
            ColumnMappings[col] = null;

        // Обновляем PreviewRows: один проход, сразу добавляем все недостающие колонки
        PreviewRows = PreviewRows
            .Select(row =>
            {
                var newRow = new Dictionary<string, string>(row);

                foreach (var col in newColumns)
                    if (!newRow.ContainsKey(col))
                        newRow[col] = "";

                return newRow;
            })
            .ToList();

        StateHasChanged();
    }

    /// <summary>
    /// Обработка нажатия на кнопку отмены операции
    /// в диалоговом окне
    /// </summary>
    private void CancelOperation()
    {
        // Скрываем прогресс сразу после нажатия отмены
        isProceed = false;
        StateHasChanged();

        // Инициируем отмену выполняемой операции
        cancelRequested?.Cancel();
    }

    /// <summary>
    /// Очищает словарь со свойствами сущности в Excel
    /// </summary>
    private void RemoveMapping()
    {
        ColumnMappings = TableColumns.Any() ? TableColumns.ToDictionary(c => c, _ => (EntityFieldDto?)null) : new();
    }

    private bool RequiresEntitySelection()
    {
        return OdataOperationHelper.OperationsRequiringEntitySelection.Contains(SelectedOperation);
    }

    /// <summary>
    /// Обработчик изменения чекбокса расширенных операций
    /// </summary>
    private void OnExtendedOperationsChanged()
    {
        if (EnableExtendedOperations)
        {
            // Добавляем все операции
            OperationItems = Data.Helpers.EnumHelper.GetItems<OdataOperation>();
        }
        else
        {
            // Оставляем только базовые операции
            OperationItems = Data.Helpers.EnumHelper.GetItems<OdataOperation>()
                .Where(op => !IsExtendedOperation(op.Value))
                .ToList();

            // Если выбрана расширенная операция - сбрасываем выбор
            if (IsExtendedOperation(SelectedOperation))
            {
                SelectedOperation = default;
            }
        }

        StateHasChanged();
    }

    /// <summary>
    /// Проверяет, является ли операция расширенной
    /// </summary>
    private bool IsExtendedOperation(OdataOperation operation)
    {
        return operation == OdataOperation.ImportSignatureToDocument
            || operation == OdataOperation.RenameVersionNote
            || operation == OdataOperation.ImportCertificate;
    }

    #region Управление этапами

    /// <summary>
    /// Выбор этапа для редактирования
    /// </summary>
    private async Task SelectStage(SettingStage stage)
    {
        SelectedStage = stage;

        // Очищаем данные предыдущего этапа
        PreviewRows = new();
        TableColumns = new();
        ColumnMappings = new();
        DbService = null;
        DbTables = new();

        // Загружаем настройки выбранного этапа в форму
        if (SelectedStage != null)
        {
            SelectedSourceType = SelectedStage.SourceType;
            SelectedOperation = SelectedStage.Operation;
            EnableExtendedOperations = SelectedStage.EnableExtendedOperations;

            // Восстанавливаем IEdmEntitySet из сохраненного имени
            if (!string.IsNullOrEmpty(SelectedStage.SelectedEntitySetName))
            {
                SelectedEntitySet = EntitySets.FirstOrDefault(e => e.Name == SelectedStage.SelectedEntitySetName);
                SelectedStage.SelectedEntitySet = SelectedEntitySet;

                // Вызываем OnSelectedEntitySetChanged чтобы заполнить EntityFields
                OnSelectedEntitySetChanged(SelectedEntitySet);
            }
            else
            {
                SelectedEntitySet = null;
            }

            SearchCriteria = SelectedStage.SearchCriteria;
            UploadAllRows = SelectedStage.UploadAllRows;
            ForceUploadProcessedRows = SelectedStage.ForceUploadProcessedRows;
            StartFrom = SelectedStage.StartFrom;
            RowsToUpload = SelectedStage.RowsToUpload;
            DbConnectionString = SelectedStage.ConnectionString;
            SelectedTable = SelectedStage.SelectedTable;

            // Сохраняем маппинг временно
            var savedMappings = SelectedStage.ColumnMappings != null && SelectedStage.ColumnMappings.Any()
                ? new Dictionary<string, string?>(SelectedStage.ColumnMappings)
                : null;

            // Если источник - БД, подключаемся и загружаем данные
            if (SelectedStage.SourceType == SourceType.DatabaseMssql && !string.IsNullOrWhiteSpace(SelectedStage.ConnectionString))
            {
                DbService = new MssqlService(SelectedStage.ConnectionString);
                await DbService.ConnectAsync();
                DbTables = (await DbService.GetTablesAsync()).ToList();

                // Загружаем данные из выбранной таблицы
                if (!string.IsNullOrWhiteSpace(SelectedStage.SelectedTable))
                {
                    await OnDbTableChanged();
                }
            }

            // Восстанавливаем ColumnMappings ПОСЛЕ загрузки данных
            if (savedMappings != null)
            {
                ColumnMappings = savedMappings.ToDictionary(
                    kvp => kvp.Key,
                    kvp => string.IsNullOrEmpty(kvp.Value)
                        ? null
                        : EntityFields.FirstOrDefault(f => f.Name == kvp.Value)
                );
            }
        }

        StateHasChanged();
    }

    /// <summary>
    /// Сохранение настроек текущего этапа
    /// </summary>
    private async Task SaveStageSettings()
    {
        if (SelectedStage == null) return;

        // Сохраняем настройки из формы в выбранный этап
        SelectedStage.SourceType = SelectedSourceType;
        SelectedStage.Operation = SelectedOperation;
        SelectedStage.EnableExtendedOperations = EnableExtendedOperations;
        SelectedStage.SelectedOperation = SelectedOperation;
        SelectedStage.SelectedEntitySet = SelectedEntitySet;
        SelectedStage.SelectedEntitySetName = SelectedEntitySet?.Name;
        SelectedStage.SelectedCollectionPropertyName = SelectedCollectionProperty?.Name;
        SelectedStage.SearchCriteria = SearchCriteria;
        SelectedStage.UploadAllRows = UploadAllRows;
        SelectedStage.ForceUploadProcessedRows = ForceUploadProcessedRows;
        SelectedStage.StartFrom = StartFrom;
        SelectedStage.RowsToUpload = RowsToUpload;
        SelectedStage.ConnectionString = DbConnectionString;
        SelectedStage.SelectedTable = SelectedTable;

        // Сохраняем только имена полей из маппинга
        SelectedStage.ColumnMappings = ColumnMappings.ToDictionary(
            kvp => kvp.Key,
            kvp => kvp.Value?.Name
        );

        await SettingService.UpdateStages(SettingStages);

        NotificationService.Notify(new NotificationMessage
        {
            Summary = "Сохранено",
            Detail = $"Настройки этапа \"{SelectedStage.Name}\" сохранены",
            Severity = NotificationSeverity.Success,
            Duration = 3000
        });
    }

    /// <summary>
    /// Добавление нового этапа
    /// </summary>
    private async Task AddNewStage()
    {
        var newStage = new SettingStage
        {
            Number = SettingStages.Any() ? SettingStages.Max(s => s.Number) + 1 : 1,
            Name = $"Этап {SettingStages.Count + 1}",
            Description = "Описание этапа",
            SourceType = SourceType.Excel,
            Operation = OdataOperation.CreateEntity,
            EnableExtendedOperations = false,
            UploadAllRows = true,
            StartFrom = 1,
            RowsToUpload = 100,
            SearchCriteria = SearchEntityBy.Name,
            ColumnMappings = new()
        };

        SettingStages.Add(newStage);
        await SettingService.UpdateStages(SettingStages);
        SelectedStage = newStage;
        SelectStage(newStage);
    }

    /// <summary>
    /// Удаление этапа
    /// </summary>
    private async Task DeleteStage(SettingStage stage)
    {
        var confirmed = await DialogService.Confirm(
            $"Вы уверены, что хотите удалить этап \"{stage.Name}\"?",
            "Подтверждение удаления",
            new ConfirmOptions { OkButtonText = "Да", CancelButtonText = "Отмена" });

        if (confirmed == true)
        {
            SettingStages.Remove(stage);

            // Переназначаем номера этапов
            for (int i = 0; i < SettingStages.Count; i++)
            {
                SettingStages[i].Number = i + 1;
            }

            if (SelectedStage == stage)
            {
                SelectedStage = SettingStages.FirstOrDefault();
            }

            await SettingService.UpdateStages(SettingStages);
            StateHasChanged();
        }
    }

    /// <summary>
    /// Переместить этап вверх
    /// </summary>
    private async Task MoveStageUp(SettingStage stage)
    {
        var index = SettingStages.IndexOf(stage);
        if (index > 0)
        {
            var previousStage = SettingStages[index - 1];

            // Меняем номера местами
            var tempNumber = stage.Number;
            stage.Number = previousStage.Number;
            previousStage.Number = tempNumber;

            // Меняем позиции в списке
            SettingStages[index] = previousStage;
            SettingStages[index - 1] = stage;

            await SettingService.UpdateStages(SettingStages);
            StateHasChanged();
        }
    }

    /// <summary>
    /// Переместить этап вниз
    /// </summary>
    private async Task MoveStageDown(SettingStage stage)
    {
        var index = SettingStages.IndexOf(stage);
        if (index < SettingStages.Count - 1)
        {
            var nextStage = SettingStages[index + 1];

            // Меняем номера местами
            var tempNumber = stage.Number;
            stage.Number = nextStage.Number;
            nextStage.Number = tempNumber;

            // Меняем позиции в списке
            SettingStages[index] = nextStage;
            SettingStages[index + 1] = stage;

            await SettingService.UpdateStages(SettingStages);
            StateHasChanged();
        }
    }

    #endregion
}
