using System;

namespace MigrationToDRX.Data.Models.Dto;

/// <summary>
/// Базовый класс свойства сущности, полученной из Odata
/// </summary>
public abstract class EntityFieldDto
{
    /// <summary>
    /// Название свойства сущности
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// Тип свойства сущности
    /// </summary>
    public virtual string? Type { get; set; }

    /// <summary>
    /// Может ли свойство быть пустым
    /// </summary>
    public bool Nullable { get; set; }
}
