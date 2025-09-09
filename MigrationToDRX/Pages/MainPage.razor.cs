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

namespace MigrationToDRX.Pages;

public partial class MainPage
{
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
    protected SearchEntityBy SearchCriteria { get; set; } = SearchEntityBy.Id;

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

    protected List<EntityFieldDto> AvailableEntityFields => EntityFields.Where(f => !ColumnMappings.Any(c => c.Key == f.Name)).ToList();

    /// <summary>
    /// Список колонок, загруженных из Excel
    /// </summary>
    private List<string> ExcelColumns { get; set; } = new();

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
    /// Сервис для работы с OData клиентом
    /// </summary>
    [Inject]
    private OdataClientService OdataClientService { get; set; } = null!;

    /// <summary>
    /// Сервис для работы с уведомлениями
    /// </summary>
    [Inject]
    private NotificationService NotificationService { get; set; } = null!;

    /// <summary>
    /// Сервис для работы с Excel
    /// </summary>
    [Inject]
    private ExcelService ExcelService { get; set; } = null!;

    /// <summary>
    /// Сервис для работы с EdmxEntity
    /// </summary>
    [Inject]
    private EntityService EntityService { get; set; } = null!;

    [Inject]
    private IJSRuntime JS { get; set; } = null!;

    /// <summary>
    /// Признак подключения к OData сервису
    /// </summary>
    private bool IsConnected => OdataClientService.IsConnected;

    /// <summary>
    /// Инициализация при старте страницы
    /// </summary>
    /// <returns></returns>
    protected override async Task OnInitializedAsync()
    {
        //TODO: показать модалку о том, что надо бы вернуться на страницу подключения
        if (IsConnected == false)
        {
            await base.OnInitializedAsync();
        }

        // получаем список сущностей из OData
        EntitySets = OdataClientService.GetEntitySets().OrderBy(e => e.Name).ToList();

        // получаем список операций для выбора
        OperationItems = Data.Helpers.EnumHelper.GetItems<OdataOperation>();

        // получаем список полей для поиска навигационных свойств
        SearchEntityByList = Data.Helpers.EnumHelper.GetItems<SearchEntityBy>();

        await base.OnInitializedAsync();

    }

    /// <summary>
    /// Обработчик изменения выбранной операции
    /// </summary>
    private void OnSelectedOperationChanged()
    {
        //OdataOperationHelper.AddPropertiesByOperation(SelectedOperation, EntityFields, ColumnMappings);

        EntityFields.RemoveAll(p => p == OdataOperationHelper.MainIdProperty || p == OdataOperationHelper.PathProperty);
        var keysToDelete = ColumnMappings.Where(p => p.Value == OdataOperationHelper.MainIdProperty || p.Value == OdataOperationHelper.PathProperty).ToList();
        foreach (var kvp in keysToDelete)
        {
            ColumnMappings[kvp.Key] = null;
        }

        switch (SelectedOperation)
        {
            case OdataOperation.CreateEntity:
                break;

            case OdataOperation.UpdateEntity:
                EntityFields.AddFirst(OdataOperationHelper.MainIdProperty);
                break;

            case OdataOperation.CreateDocumentWithVersion:
                EntityFields.AddFirst(OdataOperationHelper.PathProperty);
                break;

            case OdataOperation.AddVersionToExistedDocument:
                EntityFields.AddFirstRange(new[] { OdataOperationHelper.MainIdProperty, OdataOperationHelper.PathProperty });
                break;

            case OdataOperation.AddEntityToCollection:
                EntityFields.AddFirst(OdataOperationHelper.MainIdProperty);
                break;

            case OdataOperation.UpdateEntityInCollection:
                EntityFields.AddFirst(OdataOperationHelper.MainIdProperty);
                break;
        }

        StateHasChanged();
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
            ColumnMappings = ExcelColumns.Any() ? ExcelColumns.ToDictionary(c => c, _ => (EntityFieldDto?)null) : new();

            return;
        }

        // получаем метаданные сущности и парсим поля
        if (OdataClientService.GetEdmxEntityDto(SelectedEntitySet.Name) is { } dto)
        {
            // Заполняем поля сущности
            EntityFields = EntityService.GetEntityFields(dto);

            // Добавляем свойства сущности в зависимости от операции
            OdataOperationHelper.AddPropertiesByOperation(SelectedOperation, EntityFields, ColumnMappings);

            // Заполняем список свойств-коллекций
            CollectionProperties = dto.NavigationProperties.Where(p => p.IsCollection).ToList();

            // Сбрасываем маппинг
            ColumnMappings = ExcelColumns.ToDictionary(c => c, _ => (EntityFieldDto?)null);

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
            // очищаем список полей
            EntityFields = new();

            // Сбрасываем маппинг
            ColumnMappings = ExcelColumns.Any() ? ExcelColumns.ToDictionary(c => c, _ => (EntityFieldDto?)null) : new();

            return;
        }

        var dto = OdataClientService.GetChildEntities(SelectedCollectionProperty);

        // Заполняем поля сущности
        EntityFields = EntityService.GetEntityFields(dto);

        // Добавляем свойства сущности в зависимости от операции
        OdataOperationHelper.AddPropertiesByOperation(SelectedOperation, EntityFields, ColumnMappings);

        // Сбрасываем маппинг
        ClearExcelToFieldsMapping();

        StateHasChanged();
    }

    /// <summary>
    /// Обработчик загрузки файла
    /// </summary>
    private async Task OnFileUpload(UploadChangeEventArgs args)
    {
        // Если нет файла — очищаем связанные словари и списки
        if (args.Files == null || !args.Files.Any())
        {
            ColumnMappings = new();
            PreviewRows = new();

            StateHasChanged();
            return;
        }

        var file = args.Files.FirstOrDefault();
        if (file != null)
        {
            using var stream = new MemoryStream();
            await file.OpenReadStream(SystemConstants.MaxExcelFileSize).CopyToAsync(stream);
            stream.Position = 0;

            var rows = ExcelService.ReadExcel(stream);

            if (rows.Count == 0)
            {
                ExcelColumns = new List<string>();
                PreviewRows = new List<Dictionary<string, string>>();
                return;
            }

            // Формируем список колонок из заголовков
            //HACK: Внимание! Если заголовков нет, то будет использоваться первая строка!
            // Данные этой строки НЕ БУДУТ загружены в OData! 
            ExcelColumns = rows.First().Keys.ToList();

            // Формируем PreviewRows (берем максимум 5-6 строк)
            PreviewRows = rows
            // HACK:    .Take(6) <= Так можно ограничить, сколько строк мы забираем и храним в памяти
                .Select(row => ExcelColumns.ToDictionary(
                    col => col,
                    col => row[col].ToString() ?? string.Empty))
                .ToList();

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
        ColumnMappings = ExcelColumns.Any() ? ExcelColumns.ToDictionary(c => c, _ => (EntityFieldDto?)null) : new();
    }

    private async Task Validate()
    {
        if (ColumnMappings.Any() == false)
        {
            return;
        }

        if (PreviewRows.Any() == false)
        {
            return;
        }

        var validationColumns = OdataOperationHelper.GetDisplayNames<Data.Models.Dto.ValidationResult>();

        CreateResultColumns(validationColumns);
        var resultColumnName = OdataOperationHelper.GetDisplayName<Data.Models.Dto.ValidationResult>(nameof(Data.Models.Dto.ValidationResult.Success));

        var maxRowsCount = UploadAllRows ? PreviewRows.Count : RowsToUpload;

        for (int i = 0; i < maxRowsCount; i++)
        {
            var row = PreviewRows[i];
            var dto = new ProcessedEntityDto()
            {
                ColumnMapping = ColumnMappings,
                Row = row,
                SearchCriteria = SearchCriteria,
                EntitySetName = SelectedEntitySet!.Name,
                ChildEntitySetName = SelectedCollectionProperty?.Name,
                IsCollection = SelectedCollectionProperty != null,
                Operation = SelectedOperation,
            };

            try
            {
                var result = await EntityService.ValidateEntity(dto);
                row[resultColumnName] = result.Success ?? string.Empty;
                continue;
            }
            catch (Exception e)
            {
                row[resultColumnName] = e.Message;
                continue;
            }
        }
    }

    private async Task Upload()
    {
        if (ColumnMappings.Any() == false)
        {
            return;
        }

        if (PreviewRows.Any() == false)
        {
            return;
        }

        var validationColumns = OdataOperationHelper.GetDisplayNames<Data.Models.Dto.OperationResult>();

        CreateResultColumns(validationColumns);

        var resultColumnName = OdataOperationHelper.GetDisplayName<Data.Models.Dto.OperationResult>(nameof(Data.Models.Dto.OperationResult.Success));
        var timeStampColumnName = OdataOperationHelper.GetDisplayName<Data.Models.Dto.OperationResult>(nameof(Data.Models.Dto.OperationResult.Timestamp));
        var signColumnName = OdataOperationHelper.GetDisplayName<Data.Models.Dto.OperationResult>(nameof(Data.Models.Dto.OperationResult.Stamp));
        var operationNameColumnName = OdataOperationHelper.GetDisplayName<Data.Models.Dto.OperationResult>(nameof(Data.Models.Dto.OperationResult));
        var errorsColumnName = OdataOperationHelper.GetDisplayName<Data.Models.Dto.OperationResult>(nameof(Data.Models.Dto.OperationResult.ErrorMessage));

        var maxRowsCount = UploadAllRows ? PreviewRows.Count : RowsToUpload;

        for (int i = 0; i < maxRowsCount; i++)
        {
            var row = PreviewRows[i];

            if (row[resultColumnName] != null && row[resultColumnName].ToString() != "Да")
            {
                // валидация не удалась, пропускаем
                continue;
            }

            if (row[signColumnName] != null && ForceUploadProcessedRows == false)
            {
                // TODO: Вычислять, что подпись проставлена именно этой программой.

                // Если подпись стоит, значит уже была обработана в прошлом запросе
                continue;
            }

            var dto = new ProcessedEntityDto()
            {
                ColumnMapping = ColumnMappings,
                Row = row,
                SearchCriteria = SearchCriteria,
                EntitySetName = SelectedEntitySet!.Name,
                ChildEntitySetName = SelectedCollectionProperty?.Name,
                IsCollection = SelectedCollectionProperty != null,
                Operation = SelectedOperation,
            };

            try
            {
                var result = await EntityService.ProceedEntitiesToOdata(dto);

                row[resultColumnName] = result.Success ? "Да" : "Нет";
                row[timeStampColumnName] = result.Timestamp.ToLongTimeString();
                row[signColumnName] = result.Stamp;
                row[operationNameColumnName] = result.OperationName;

                continue;
            }
            catch (Exception ex)
            {
                row[resultColumnName] = "Нет";
                row[operationNameColumnName] = SelectedOperation.GetDisplayName();
                row[errorsColumnName] = ex.Message + " : " + ex.InnerException?.Message;

                 continue;
            }
        }
    }

    private async Task DownloadExcel()
    {
        var fileBytes = ExcelService.GetExcelBytes(PreviewRows, ExcelColumns, "Preview");
        var base64 = Convert.ToBase64String(fileBytes);
        await JS.InvokeVoidAsync("downloadFileFromBase64", "Preview.xlsx", base64);
    }
        
    private void CreateResultColumns(List<string>? resultColumns)
    {
        if (resultColumns == null)
        {
            return;
        }
        // Определяем, какие новые колонки реально нужно добавить

        var newColumns = resultColumns.Except(ExcelColumns).ToList();

        // Добавляем их в ExcelColumns и ColumnMappings
        ExcelColumns.AddRange(newColumns);
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
}