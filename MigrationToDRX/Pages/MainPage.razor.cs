using System;
using System.Data;
using System.Dynamic;
using MigrationToDRX.Data.Models;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.OData.Edm;
using MigrationToDRX.Data.Models.Dto;
using MigrationToDRX.Data.Services;
using Radzen;

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

    /// <summary>
    /// Флаг работы с обновлением сущностей
    /// </summary>
    private bool WorkWithExistedEntities = false;

    /// <summary>
    /// Флаг работы с телами документов
    /// </summary>
    private bool WorkWithEdocBodies = false;

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

    /// <summary>
    /// Обработчик изменения свойства WorkWithCollection
    /// </summary>
    private void OnWorkWithCollectionPropertyChanged()
    {
        var mainIdProp = new StructuralFieldDto() { Name = "Id главной сущности", Type = "Edm.String", Nullable = false };
        if (WorkWithCollectionProperty)
        {
            EntityFieldsToMap.Add(mainIdProp);
        }
        else if (WorkWithCollectionProperty == false && EntityFieldsToMap.Contains(mainIdProp))
        {
            EntityFieldsToMap.Remove(mainIdProp);
        }

        StateHasChanged();
    }

    /// <summary>
    /// Обработчик изменения свойства WorkWithEdocBodies
    /// </summary>
    private void OnWorkWithEdocBodiesChanged()
    {
        var pathProp = new StructuralFieldDto() { Name = "Путь до файла", Type = "Edm.String", Nullable = false };
        if (WorkWithCollectionProperty)
        {
            EntityFieldsToMap.Add(pathProp);
        }
        else if (WorkWithCollectionProperty == false && EntityFieldsToMap.Contains(pathProp))
        {
            EntityFieldsToMap.Remove(pathProp);
        }

        StateHasChanged();
    }

    /// <summary>
    /// Обработчик изменения свойства WorkWithExistedEntities
    /// </summary>
    private void OnWorkWithExistedEntitiesChanged()
    {
        StateHasChanged();
    }

    void OnCompleteUploadFile(UploadCompleteEventArgs args)
    {
        showProgressUploadFile = false;
    }

    void OnProgressUploadFile(UploadProgressArgs args)
    {
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
    
    private async Task LoadData()
    {

    }

    private async Task ValidateData()
    {
        
    }
}
