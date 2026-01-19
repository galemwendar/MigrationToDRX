using Microsoft.OData.Edm;
using MigrationToDRX.Data.Enums;
using MigrationToDRX.Data.Models.Dto;

namespace MigrationToDRX.Data.Services.Settings;

public class SettingStage
{
    /// <summary>
    /// Имя этапа
    /// </summary>
    public string Name { get; set; }

    /// <summary>
    /// Описание этапа
    /// </summary>
    public string? Description { get; set; }

    /// <summary>
    /// Номер этапа (последовательность)
    /// </summary>
    public int Number { get; set; }

    /// <summary>
    /// Тип источника
    /// </summary>
    public SourceType SourceType { get; set; }

    /// <summary>
    /// Операция
    /// </summary>
    public OdataOperation Operation { get; set; }

    /// <summary>
    /// Включить расширенные операции
    /// </summary>
    public bool EnableExtendedOperations { get; set; }

    /// <summary>
    /// Выбранная операция
    /// </summary>
    public OdataOperation SelectedOperation { get; set; }

    /// <summary>
    /// Имя выбранного Odata сета
    /// </summary>
    public string? SelectedEntitySetName { get; set; }

    /// <summary>
    /// Выбранный Odata сет (не сериализуется)
    /// </summary>
    [System.Text.Json.Serialization.JsonIgnore]
    public IEdmEntitySet? SelectedEntitySet { get; set; }

    /// <summary>
    /// Поиск по критериям
    /// </summary>
    public SearchEntityBy SearchCriteria { get; set; }

    /// <summary>
    /// Загрузить все строки
    /// </summary>
    public bool UploadAllRows { get; set; }

    /// <summary>
    /// Загрузить в том числе уже обработанные строки
    /// </summary>
    public bool ForceUploadProcessedRows { get; set; }

    /// <summary>
    /// Загружать со стоки
    /// </summary>
    public int StartFrom { get; set; }

    /// <summary>
    /// Количество загружаемых строк
    /// </summary>
    public int RowsToUpload { get; set; }

    /// <summary>
    /// Строка подключения к БД
    /// </summary>
    public string? ConnectionString { get; set; }

    /// <summary>
    /// Выбранная в БД таблица
    /// </summary>
    public string? SelectedTable { get; set; }

    /// <summary>
    /// Сопоставление колонок (имя колонки -> имя поля сущности)
    /// </summary>
    public Dictionary<string, string?> ColumnMappings { get; set; }

    /// <summary>
    /// Имя выбранного свойства-коллекции
    /// </summary>
    public string? SelectedCollectionPropertyName { get; set; }

}
