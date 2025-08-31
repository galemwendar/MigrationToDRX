using System;

namespace MigrationToDRX.Data.Models.Dto;

/// <summary>
/// Свойство сущности
/// </summary>
public class StructuralFieldDto: EntityFieldDto
{
    /// <summary>
    /// Краткое описание свойства
    /// </summary>
    public override string? Summary => $"{Name} ({Type}) {(Nullable ? "Nullable" : "Not Nullable")}";
}
