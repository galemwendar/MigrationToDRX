using System;

namespace MigrationToDRX.Data.Models.Dto;

/// <summary>
/// Навигационное свойство сущности
/// </summary>
public class NavigationPropertyDto : EntityFieldDto
{
    /// <summary>
    /// Является ли свойство коллекцией
    /// </summary>
    public bool IsCollection { get; set; }

    /// <summary>
    /// Краткое наименование типа свойства сущности
    /// </summary>
    public override string? ShortType
    {
        get
        {
            var baseType = base.Type;
            return !string.IsNullOrEmpty(baseType) && baseType.Contains(".")
                ? baseType.Split('.').Last()
                : baseType;
        }
    }
}
