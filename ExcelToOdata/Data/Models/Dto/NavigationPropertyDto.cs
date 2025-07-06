using System;

namespace ExcelToOdata.Data.Models.Dto;

/// <summary>
/// Навигационное свойство сущности
/// </summary>
public class NavigationPropertyDto
{
   /// <summary>
    /// Название навигационного свойства
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// Тип навигационного свойства (имя сущности или коллекции)
    /// </summary>
    public string? Type { get; set; }

    /// <summary>
    /// Является ли свойство коллекцией
    /// </summary>
    public bool IsCollection { get; set; }

    /// <summary>
    /// Может ли быть null
    /// </summary>
    public bool Nullable { get; set; }

    /// <summary>
    /// Краткое описание
    /// </summary>
    public string? Summary => $"{Name} ({(IsCollection ? "Collection of " : "")}{Type}) {(Nullable ? "Nullable" : "Not Nullable")}";

}
