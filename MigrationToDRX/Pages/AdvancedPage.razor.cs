using Microsoft.AspNetCore.Components;
using Microsoft.OData.Edm;
using MigrationToDRX.Data.Enums;
using MigrationToDRX.Data.Helpers;
using MigrationToDRX.Data.Models.Dto;
using MigrationToDRX.Data.Services;
using Radzen;

namespace MigrationToDRX.Pages;

public partial class AdvancedPage : ComponentBase
{
    protected string? FileName { get; set; }
    protected OdataOperation SelectedOperation { get; set; }
    protected List<EnumItem<OdataOperation>> OperationItems { get; set; } = new();

    protected List<IEdmEntitySet> Entities { get; set; } = new();
    protected IEdmEntitySet? SelectedEntity { get; set; }

    protected List<string> ExcelColumns { get; set; } = new();
    protected List<EntityFieldDto> EntityFields { get; set; } = new();
    protected List<Dictionary<string, string>> PreviewRows { get; set; } = new();

    // Excel column -> Entity field
    protected Dictionary<string, EntityFieldDto?> ColumnMappings { get; set; } = new();

    // Для навигационных свойств: Excel колонка -> вложенное свойство навигационной сущности
    protected Dictionary<string, EntityFieldDto?> ColumnMappingsNav { get; set; } = new();


    [Inject]
    private ExcelService? ExcelService { get; set; }

    [Inject]
    private OdataClientService? OdataClientService { get; set; }

    /// <summary>
    /// Сервис для работы с уведомлениями
    /// </summary>
    [Inject]
    private NotificationService? NotificationService { get; set; }

    /// <summary>
    /// Инициализация при старте страницы
    /// </summary>
    protected override async Task OnInitializedAsync()
    {
        Entities = OdataClientService!.GetEntitySets().OrderBy(e => e.Name).ToList();

        OperationItems = Enum.GetValues(typeof(OdataOperation))
            .Cast<OdataOperation>()
            .Select(op => new EnumItem<OdataOperation>
            {
                Value = op,
                DisplayName = op.GetDisplayName()
            })
            .ToList();

        await base.OnInitializedAsync();
    }

    protected void OnEntityChanged(object value)
    {

        // метаданные сущности
        var dto = OdataClientService!.GetEdmxEntityDto(SelectedEntity!.Name);
        if (dto != null)
        {
            var structuralProperties = dto.StructuralProperties
                .Select(p => new StructuralFieldDto
                {
                    Name = p.Name?.ToString() ?? "",
                    Type = p.Type?.ToString() ?? "Неизвестно",
                    Nullable = p.Nullable
                })
                .ToList();

            var navigationProperties = dto.NavigationProperties
                .Select(p => new NavigationPropertyDto
                {
                    Name = p.Name?.ToString() ?? "",
                    Type = p.Type?.ToString() ?? "Неизвестно",
                    Nullable = p.Nullable
                })
                .ToList();

            EntityFields = structuralProperties
                .Concat<EntityFieldDto>(navigationProperties)
                .ToList();

            // Сбрасываем маппинг
            ColumnMappingsNav = navigationProperties
                .Where(f => string.IsNullOrWhiteSpace(f.Name) == false)
                .ToDictionary(f => f.Name!, f => (EntityFieldDto?)null);
        }
    }

    protected async Task OnFileUpload(UploadChangeEventArgs args)
    {
        var file = args.Files.FirstOrDefault();
        if (file != null)
        {
            FileName = file.Name;

            using var stream = new MemoryStream();
            await file.OpenReadStream(100 * 1024 * 1024).CopyToAsync(stream);
            stream.Position = 0;

            var rows = ExcelService!.ReadExcel(stream);

            if (rows.Count == 0)
            {
                ExcelColumns = new List<string>();
                PreviewRows = new List<Dictionary<string, string>>();
                return;
            }

            // Формируем список колонок из заголовков
            ExcelColumns = rows.First().Keys.ToList();

            // Формируем PreviewRows (берем максимум 5-6 строк)
            PreviewRows = rows
                .Take(6)
                .Select(row => ExcelColumns.ToDictionary(
                    col => col,
                    col => row[col]?.ToString() ?? string.Empty))
                .ToList();

            // Сбрасываем маппинг
            ColumnMappings = ExcelColumns.ToDictionary(c => c, c => (EntityFieldDto?)null);
            
            // Сбрасываем маппинг
            ColumnMappingsNav = EntityFields
                .Where(f => string.IsNullOrWhiteSpace(f.Name) == false && f is NavigationPropertyDto)
                .ToDictionary(f => f.Name!, f => (EntityFieldDto?)null);

        }
        else
        {
            NotificationService!.Notify(new NotificationMessage
            {
                Summary = "Ошибка",
                Detail = "Не загрузить документ",
                Severity = NotificationSeverity.Error,
                Duration = 4000
            });
        }

    }

    public List<StructuralFieldDto> GetEntityFileds(NavigationPropertyDto navigationProperty)
    {
        if (navigationProperty == null)
        {
            return new List<StructuralFieldDto>();
        }

        if (string.IsNullOrWhiteSpace(navigationProperty.Type))
        {
            return new List<StructuralFieldDto>();
        }

        return OdataClientService!.GetEdmxEntityDtoByType(navigationProperty.Type)!.StructuralProperties
            .Select(p => new StructuralFieldDto
            {
                Name = p.Name?.ToString() ?? "",
                Type = p.Type?.ToString() ?? "Неизвестно",
                Nullable = p.Nullable
            })
            .ToList();
    }


    protected Task StartImport()
    {
        // здесь ColumnMappings[col] → имя поля сущности
        // можно пройтись по PreviewRows и собрать DTO
        Console.WriteLine($"Импортируем {PreviewRows.Count} строк в {SelectedEntity} как {SelectedOperation}");
        return Task.CompletedTask;
    }

    public async Task OnImport(MigrationToDRX.Pages.AdvancedPage args)
    {
        Console.WriteLine($"Импортируем как {SelectedOperation.GetDisplayName()}...");
        await Task.CompletedTask;
    }


    public async Task AutoMap()
    {
        // Здесь логика: пройтись по PreviewRows, замапить по EntityFields,
        // собрать модель и отправить в OData через Simple.OData.Client
        Console.WriteLine($"Импортируем как {SelectedOperation.GetDisplayName()}...");
        await Task.CompletedTask;
    }

    public async Task DryRun()
    {
        // Здесь логика: пройтись по PreviewRows, замапить по EntityFields,
        // собрать модель и отправить в OData через Simple.OData.Client
        Console.WriteLine($"Импортируем как {SelectedOperation.GetDisplayName()}...");
        await Task.CompletedTask;
    }

    public async Task RemoveRow(string col)
    {

    }
}