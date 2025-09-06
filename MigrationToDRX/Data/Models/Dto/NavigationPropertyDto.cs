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
    /// Тип свойства сущности
    /// </summary>
    /// <summary>
    /// Тип свойства сущности с кастомной логикой
    /// </summary>
    public override string? Type
    {
        get
        {
            var baseType = base.Type;
            return !string.IsNullOrEmpty(baseType) && baseType.Contains(".")
                ? baseType.Split('.').Last()
                : baseType;
        }
        set => base.Type = value;
    }
}
