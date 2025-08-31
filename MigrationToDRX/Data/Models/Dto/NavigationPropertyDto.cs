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
    /// Краткое описание
    /// </summary>
    public override string? Summary => $"{Name} ({(IsCollection ? "Collection of " : "")}{Type}) {(Nullable ? "Nullable" : "Not Nullable")}";
}
