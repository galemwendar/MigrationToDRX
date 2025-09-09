using System;
using MigrationToDRX.Data.Enums;

namespace MigrationToDRX.Data.Models.Dto;

/// <summary>
/// Дто для передачи данных на сервер
/// </summary>
public class ProcessedEntityDto
{
    /// <summary>
    ///  Маппинг столбцов Excel на свойства сущности
    /// </summary>
    public Dictionary<string, EntityFieldDto?> ColumnMapping { get; set; } = new();

    /// <summary>
    /// Строка Excel
    /// </summary>
    public Dictionary<string, string> Row { get; set; } = new();

    /// <summary>
    /// Операция миграции
    /// </summary>
    public OdataOperation Operation { get; set; }

    /// <summary>
    /// Сущность
    /// </summary>
    public string EntitySetName { get; set; } = "";

    /// <summary>
    /// Свойство-коллекция
    /// </summary>
    public string? ChildEntitySetName { get; set; }

    /// <summary>
    /// Флаг, указывающий, что работаем со свойством-коллекцией
    /// </summary>
    public bool IsCollection { get; set; }

    /// <summary>
    /// Критерий поиска для навигационных свойств
    /// </summary>
    public SearchEntityBy SearchCriteria { get; set; }
}
