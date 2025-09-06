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
using MigrationToDRX.Data.Extensions;

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
    /// Навигационные свойства коллекции
    /// </summary>
    private List<NavigationPropertyDto> CollectionPropeties => EdmxEntityDto == null ? new() : EdmxEntityDto.NavigationProperties.Where(p => p.IsCollection).ToList();

    /// <summary>
    /// Признак, по которому будет производится поиск по ссылочному свойству
    /// </summary>
    private SearchEntityBy SearchInMainEntityBy = SearchEntityBy.Id;

    /// <summary>
    /// Признак, по которому будет производится поиск по ссылочному в свойстве-коллекции
    /// </summary>
    private SearchEntityBy SearchInChildEntityBy = SearchEntityBy.Id;

    private OdataScenario CurrentScenario = OdataScenario.CreateEntity;

    private record ScenarioOption(OdataScenario Value, string Description);

    private List<ScenarioOption> ScenarioOptions = new()
    {
        new(OdataScenario.CreateEntity, "Создание сущности (документ/справочник/прочее)"),
        new(OdataScenario.UpdateEntity, "Обновление сущности"),
        new(OdataScenario.CreateDocumentWithVersion, "Создание документа с версией"),
        new(OdataScenario.AddVersionToExistedDocument, "Добавление версии в существующий документ"),
        new(OdataScenario.AddEntityToCollection, "Добавление сущности в свойство-коллекцию (еще не реализовано)"),
        new(OdataScenario.UpdateEntityInCollection, "Обновление сущности в свойстве-коллекции (еще не реализовано)")
    };

    private List<EntityFieldDto> BaseEntityFieldsToMap = new();

    private List<EntityFieldDto> EntityFieldsToMap = new();

    #endregion

    /// <summary>
    /// Словарь "имя колонки → список доступных полей".
    /// Используется для привязки данных к каждому DropDown в таблице.
    /// </summary>
    private Dictionary<string, IEnumerable<EntityFieldDto>> availableFields = new();

    /// <summary>
    /// Инициализация компонента
    /// </summary>
    protected override async Task OnInitializedAsync()
    {
        if (OdataClientService != null && OdataClientService.IsConnected)
        {
            EntitySets = OdataClientService.GetEntitySets();
        }

        OnScenarioChanged(CurrentScenario);

        await base.OnInitializedAsync();
    }

    /// <summary>
    /// Обработчик изменения выбранной сущности
    /// </summary>
    private void OnEntitySetsSelectChanged()
    {
        foreach (var kvp in columnMapping)
        {
            columnMapping[kvp.Key] = string.Empty;
        }

        if (!string.IsNullOrWhiteSpace(SelectedEntitySetName))
        {
            EdmxEntityDto = OdataClientService!.GetEdmxEntityDto(SelectedEntitySetName);

            if (BaseEntityFieldsToMap == null)
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

            BaseEntityFieldsToMap = new List<EntityFieldDto>();

            if (EdmxEntityDto.StructuralProperties != null)
            {
                BaseEntityFieldsToMap.AddRange(EdmxEntityDto.StructuralProperties);
            }

            if (EdmxEntityDto.NavigationProperties != null)
            {
                BaseEntityFieldsToMap.AddRange(EdmxEntityDto.NavigationProperties.Where(prop => prop.IsCollection == false));
            }

        }
        else
        {
            BaseEntityFieldsToMap = new();
        }

        RecalculateEntityFields();
        RefreshAvailableFields();
        StateHasChanged();
    }


    /// <summary>
    /// Обработчик изменения выбранного свойства коллекции
    /// </summary>
    private void OnCollectionPropertyChanged()
    {
        if (!string.IsNullOrWhiteSpace(SelectedCollectionPropertyName))
        {
            var prop = CollectionPropeties?.FirstOrDefault(p => p.Name == SelectedCollectionPropertyName);
            if (prop != null && !string.IsNullOrWhiteSpace(prop.Type))
            {
                ChildEdmxEntityDto = OdataClientService?.GetChildEntities(prop);

                BaseEntityFieldsToMap = new List<EntityFieldDto>();
                if (ChildEdmxEntityDto?.StructuralProperties != null)
                {
                    BaseEntityFieldsToMap.AddRange(ChildEdmxEntityDto.StructuralProperties);
                }
                if (ChildEdmxEntityDto?.NavigationProperties != null)
                {
                    BaseEntityFieldsToMap.AddRange(ChildEdmxEntityDto.NavigationProperties.Where(prop => prop.IsCollection == false));
                }


            }
        }
        else
        {
            BaseEntityFieldsToMap = new();
        }

        RecalculateEntityFields();
        StateHasChanged();
    }

    /// <summary>
    /// Пересобирает базовый список доступных полей сущности (EntityFieldsToMap)
    /// в зависимости от выбранного сценария:
    /// - начинаем с базовых полей BaseEntityFieldsToMap,
    /// - добавляем дополнительные поля (MainId, Path и др.) по условиям сценария.
    /// </summary>
    private void RecalculateEntityFields()
    {
        if (BaseEntityFieldsToMap == null)
        {
            EntityFieldsToMap = new();
            return;
        }

        // начинаем с "чистых" свойств сущности
        var fields = new List<EntityFieldDto>(BaseEntityFieldsToMap);

        var mainIdProp = new StructuralFieldDto { Name = StringConstants.MainIdPropertyName, Type = "Edm.String", Nullable = false };
        var pathProp = new StructuralFieldDto { Name = StringConstants.PathPropertyName, Type = "Edm.String", Nullable = false };

        switch (CurrentScenario)
        {
            case OdataScenario.CreateEntity:
                break;

            case OdataScenario.UpdateEntity:
                fields.AddFirst(mainIdProp);
                break;

            case OdataScenario.CreateDocumentWithVersion:
                fields.AddFirst(pathProp);
                break;

            case OdataScenario.AddVersionToExistedDocument:
                fields.AddFirstRange(new[] { mainIdProp, pathProp });
                break;

            case OdataScenario.AddEntityToCollection:
                fields.AddFirst(mainIdProp);
                break;

            case OdataScenario.UpdateEntityInCollection:
                fields.AddFirst(mainIdProp);
                break;
        }

        EntityFieldsToMap = fields;
    }

    /// <summary>
    /// Обработчик загрузки файла
    /// </summary>
    /// <param name="args"></param>
    /// <returns></returns>
    private async Task OnFileUpload(UploadChangeEventArgs args)
    {
        if (args.Files == null || args.Files.Count() == 0)
        {
            columns = new();
            items = new();
            columnMapping = new();

            StateHasChanged();
            return;
        }

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

    /// <summary>
    /// Обработчик изменения выбранного сценария.
    /// - Запоминаем новый сценарий.
    /// - Пересчитываем список всех доступных полей сущности (RecalculateEntityFields).
    /// - Перестраиваем словарь доступных полей для всех колонок (RefreshAvailableFields).
    /// - Обновляем UI (StateHasChanged).
    /// </summary>
    private void OnScenarioChanged(object value)
    {
        CurrentScenario = (OdataScenario)value;
        RecalculateEntityFields();
        RefreshAvailableFields();
        StateHasChanged();
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
            var result = await EntityService!.ProceedEntitiesToOdata(new ProcessedEntityDto
            {
                Entity = entity,
                EntitySet = SelectedEntitySetName,
                Scenario = CurrentScenario,
                IsCollection = false,
                SearchEntityBy = SearchInMainEntityBy
            });

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

    /// <summary>
    /// Возвращает список доступных полей для выбора в колонке
    /// </summary>
    /// <param name="column">Колонка</param>
    /// <returns></returns>
    private IEnumerable<EntityFieldDto> GetAvailableEntityFields(string column)
    {
        // Берем все поля
        var allFields = EntityFieldsToMap ?? new List<EntityFieldDto>();

        // Исключаем те, что уже выбраны в других колонках
        var selectedFields = columnMapping
            .Where(kv => kv.Key != column && !string.IsNullOrWhiteSpace(kv.Value))
            .Select(kv => kv.Value)
            .ToHashSet();

        return allFields.Where(f => !selectedFields.Contains(f.Name!));
    }

    /// <summary>
    /// Пересчитывает список доступных полей для каждой колонки.
    /// - Берём все поля сущности (EntityFieldsToMap).
    /// - Исключаем те, что уже выбраны в других колонках (columnMapping).
    /// - Даже если для колонки нет доступных полей, создаём пустой список,
    ///   чтобы избежать KeyNotFoundException при рендере DropDown.
    /// </summary>
    private void RefreshAvailableFields()
    {
        // Если нет колонок или EntityFieldsToMap — словарь очищаем
        if (columns == null || EntityFieldsToMap == null)
        {
            availableFields.Clear();
            return;
        }

        foreach (var col in columns)
        {
            var allFields = EntityFieldsToMap;

            // Смотрим, какие значения уже выбраны в других колонках
            var selectedFields = columnMapping
                .Where(kv => kv.Key != col && !string.IsNullOrWhiteSpace(kv.Value))
                .Select(kv => kv.Value)
                .ToHashSet();

            // Формируем список доступных полей для колонки
            var filteredFields = allFields
                .Where(f => !selectedFields.Contains(f.Name!))
                .ToList();

            // Обязательно кладём ключ в словарь, даже если список пуст
            availableFields[col] = filteredFields;
        }
    }
    /// <summary>
    /// Обработчик выбора нового значения в DropDown для конкретной колонки.
    /// - Запоминаем выбранное значение в columnMapping.
    /// - Пересчитываем доступные поля (чтобы исключить выбранное из других DropDown).
    /// - Обновляем UI.
    /// </summary>
    private void OnColumnValueChanged(string col, object value)
    {
        columnMapping[col] = value?.ToString();
        RefreshAvailableFields();
        StateHasChanged();
    }

}
