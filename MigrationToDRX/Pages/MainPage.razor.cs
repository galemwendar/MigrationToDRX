using System;
using System.Data;
using System.Dynamic;
using Microsoft.AspNetCore.Components;
using Microsoft.OData.Edm;
using MigrationToDRX.Data.Models.Dto;
using MigrationToDRX.Data.Services;
using Radzen;
using MigrationToDRX.Data.Enums;
using MigrationToDRX.Data;

namespace MigrationToDRX.Pages;

public partial class MainPage
{
    #region Сервисы
    /// <summary>
    /// Сервис для работы с OData клиентом
    /// </summary>
    [Inject]
    private OdataClientService? OdataClientService { get; set; }

    /// <summary>
    /// Сервис для работы с уведомлениями
    /// </summary>
    [Inject]
    private NotificationService? NotificationService { get; set; }

    /// <summary>
    /// Сервис для работы с Excel
    /// </summary>
    [Inject]
    private ExcelService? ExcelService { get; set; }

    [Inject]
    private EntityService? EntityService { get; set; }

    #endregion

    #region Работа с Excel

    private bool showProgressUploadFile = false;

    private bool cancelUploadFile = false;

    private int progressUploadFile;

    /// <summary>
    /// Список объектов, загруженных из Excel
    /// </summary>
    private List<ExpandoObject> items = new();

    /// <summary>
    /// Список колонок, загруженных из Excel
    /// </summary>
    private List<string> columns = new();

    /// <summary>
    /// Сопоставления ExcelКолонка -> EntitySetСвойство
    /// </summary>
    private Dictionary<string, string> columnMapping = new();

    #endregion

    #region Работа с OData
    /// <summary>
    /// Признак подключения к OData сервису
    /// </summary>
    private bool IsConnected => OdataClientService?.IsConnected ?? false;

    /// <summary>
    /// Выбранный EntitySet
    /// </summary>
    private string? SelectedEntitySetName { get; set; }

    /// <summary>
    /// Выбранное навигационное свойство коллекции
    /// </summary>
    private string? SelectedCollectionPropertyName { get; set; }

    /// <summary>
    /// Выбранный EntityType
    /// </summary>
    private EdmxEntityDto? EdmxEntityDto { get; set; }

    /// <summary>
    /// Выбранный EntityType для навигационного свойства коллекции
    /// </summary>
    private EdmxEntityDto? ChildEdmxEntityDto { get; set; }

    /// <summary>
    /// Список сущностей (EntitySets)
    /// </summary>
    private List<IEdmEntitySet> EntitySets { get; set; } = new();

    /// <summary>
    /// Структурные поля сущности
    /// </summary>
    private List<StructuralFieldDto> StructuralFields => EdmxEntityDto == null ? new() : EdmxEntityDto.StructuralProperties.ToList();

    /// <summary>
    /// Навигационные свойства коллекции
    /// </summary>
    private List<NavigationPropertyDto> CollectionPropeties => EdmxEntityDto == null ? new() : EdmxEntityDto.NavigationProperties.Where(p => p.IsCollection).ToList();

    /// <summary>
    /// Флаг работы со свойством-коллекцией
    /// </summary>
    private bool WorkWithCollectionProperty = false;


    private int SearchEntityBy = 1;

    private OdataScenario CurrentScenario = OdataScenario.CreateEntity;

    private List<StructuralFieldDto> EntityFieldsToMap = new();

    #endregion

    /// <summary>
    /// Инициализация компонента
    /// </summary>
    protected override async Task OnInitializedAsync()
    {
        if (OdataClientService != null && OdataClientService.IsConnected)
        {
            EntitySets = OdataClientService.GetEntitySets();
        }

        await base.OnInitializedAsync();
    }

    /// <summary>
    /// Обработчик изменения выбранной сущности
    /// </summary>
    private void OnEntitySetsSelectChanged()
    {
        if (!string.IsNullOrWhiteSpace(SelectedEntitySetName))
        {
            EdmxEntityDto = OdataClientService!.GetEdmxEntityDto(SelectedEntitySetName);

            if (EdmxEntityDto == null)
            {
                NotificationService!.Notify(new NotificationMessage
                {
                    Summary = "Ошибка",
                    Detail = "Не удалось получить свойства сущности",
                    Severity = NotificationSeverity.Error,
                    Duration = 4000
                });

                return;
            }

            EntityFieldsToMap = EdmxEntityDto.StructuralProperties;
        }

        StateHasChanged();
    }

    /// <summary>
    /// Обработчик изменения выбранного свойства коллекции
    /// </summary>
    private void OnCollectionPropertyChanged()
    {
        if (string.IsNullOrWhiteSpace(SelectedCollectionPropertyName)) return;

        var prop = CollectionPropeties?.FirstOrDefault(p => p.Name == SelectedCollectionPropertyName);
        if (prop != null && !string.IsNullOrWhiteSpace(prop.Type))
        {
            ChildEdmxEntityDto = OdataClientService?.GetChildEntities(prop);
            EntityFieldsToMap = ChildEdmxEntityDto?.StructuralProperties ?? new();
        }

        StateHasChanged();
    }

    /// <summary>
    /// Обработчик загрузки файла
    /// </summary>
    /// <param name="args"></param>
    /// <returns></returns>
    private async Task OnFileUpload(UploadChangeEventArgs args)
    {
        var file = args.Files.FirstOrDefault();
        if (file != null)
        {
            using var stream = new MemoryStream();
            await file.OpenReadStream(100 * 1024 * 1024).CopyToAsync(stream);
            stream.Position = 0;

            var dictList = ExcelService!.ReadExcel(stream);

            columns = dictList.FirstOrDefault()?.Keys.ToList() ?? new();
            items = dictList.Select(dict =>
            {
                var expando = new ExpandoObject();
                var expandoDict = (IDictionary<string, object>)expando!;
                foreach (var kv in dict)
                    expandoDict[kv.Key] = kv.Value;
                return expando;
            }).ToList();

            // Инициализация словаря с пустыми значениями
            foreach (var col in columns)
            {
                if (!columnMapping.ContainsKey(col))
                    columnMapping[col] = null!;
            }
        }
    }

    private void OnScenarioChanged(bool isOn, OdataScenario scenario)
    {
        var mainIdProp = new StructuralFieldDto() { Name = StringConstants.MainIdPropertyName, Type = "Edm.String", Nullable = false };
        var pathProp = new StructuralFieldDto() { Name = StringConstants.PathPropertyName, Type = "Edm.String", Nullable = false };

        if (EntityFieldsToMap.Contains(mainIdProp))
        {
            EntityFieldsToMap.Remove(mainIdProp);
        }

        if (EntityFieldsToMap.Contains(pathProp))
        {
            EntityFieldsToMap.Remove(pathProp);
        }

        if (isOn)
        {
            CurrentScenario = scenario;

            switch (scenario)
            {
                case OdataScenario.CreateEntity:
                    break;

                case OdataScenario.UpdateEntity:
                    EntityFieldsToMap.Add(mainIdProp);
                    break;

                case OdataScenario.CreateDocumentWithVersion:
                    EntityFieldsToMap.Add(pathProp);
                    break;

                case OdataScenario.AddVersionToExistedDocument:
                    EntityFieldsToMap.Add(mainIdProp);
                    EntityFieldsToMap.Add(pathProp);
                    break;

                case OdataScenario.AddEntityToCollection:
                    EntityFieldsToMap.Add(mainIdProp);
                    break;

                case OdataScenario.UpdateEntityInCollection:
                    EntityFieldsToMap.Add(mainIdProp);
                    break;
            }
        }
        
        StateHasChanged();

    }


    /// <summary>
    /// Обработчик завершения загрузки файла
    /// </summary>
    void OnCompleteUploadFile(UploadCompleteEventArgs args)
    {
        showProgressUploadFile = false; //TODO на текущий момент это не работает
    }

    /// <summary>
    /// Обработчик прогресса загрузки файла
    /// </summary>
    /// <param name="args"></param>
    void OnProgressUploadFile(UploadProgressArgs args)
    {
        //TODO на текущий момент это не работает.
        // Должен показываться прогресс загрузки excel файла на случай, если файл большой и все затянется.
        showProgressUploadFile = true;
        progressUploadFile = args.Progress;

        // cancel upload
        args.Cancel = cancelUploadFile;

        // reset cancel flag
        cancelUploadFile = false;
    }

    void OnCancelUploadFile()
    {
        cancelUploadFile = true;
    }

    /// <summary>
    /// Загружает данные из Excel в OData
    /// </summary>
    /// <returns></returns>
    private async Task LoadData()
    {
        if (OdataClientService == null || string.IsNullOrEmpty(SelectedEntitySetName))
            return;

        var entities = BuildEntityDictionaries();


        // TODO: сначала нужно проверить, что все обязательные свойства указаны в Excel
        // если нет, то выводить ошибку
        foreach (var entity in entities)
        {
            var result = await EntityService!.ProceedEntitiesToOdata(entity, SelectedEntitySetName, CurrentScenario);

            if (result == null)
            {
                NotificationService!.Notify(new NotificationMessage
                {
                    Summary = "Ошибка",
                    Detail = "Не удалось выполнить сценарий",
                    Severity = NotificationSeverity.Error,
                    Duration = 4000
                });

                continue;
            }

            if (!result.Success && result.Error != null)
            {
                NotificationService!.Notify(new NotificationMessage
                {
                    Summary = "Ошибка",
                    Detail = result.Error,
                    Severity = NotificationSeverity.Error,
                    Duration = 4000
                });
            }
        }

         NotificationService!.Notify(new NotificationMessage
            {
                Summary = "Сообщение",
                Detail = "Сценарий выполнен",
                Severity = NotificationSeverity.Info,
                Duration = 4000
            });


    }

    private async Task ValidateData()
    {
        NotificationService!.Notify(new NotificationMessage
        {
            Summary = "Ошибка",
            Detail = "Валидация еще не реализована",
            Severity = NotificationSeverity.Error,
            Duration = 4000
        });
    }
    
    /// <summary>
    /// Собирает данные из Excel в список словарей для отправки в OData.
    /// </summary>
    private IEnumerable<IDictionary<string, object>> BuildEntityDictionaries()
    {
        foreach (var item in items) // item = ExpandoObject (строка из Excel)
        {
            var rowDict = new Dictionary<string, object>();
            var itemDict = item as IDictionary<string, object>;

            if (itemDict == null)
            {
                throw new ArgumentException("");
            }

            foreach (var col in columns) // колонки Excel
                {
                    if (!columnMapping.TryGetValue(col, out var entityProperty))
                        continue; // колонка не сматчена

                    if (string.IsNullOrWhiteSpace(entityProperty))
                        continue; // не указано, куда мапить

                    var value = itemDict[col];
                    rowDict[entityProperty] = value ?? string.Empty;
                }

            if (rowDict.Count > 0)
                yield return rowDict;
        }
    }

}
