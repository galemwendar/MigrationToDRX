using System;

namespace MigrationToDRX.Data.Models.Dto;

/// <summary>
/// Дто сохранения сущности на Odata сервере
/// </summary>
public class SaveEntityResult
{
    /// <summary>
    /// Успешно ли сохранение сущности
    /// </summary>
    public bool Success { get; set; }

    /// <summary>
    /// Ошибка при сохранении сущности
    /// </summary>
    public string? Error { get; set; }

    /// <summary>
    /// Сохраненная сущность
    /// </summary>
    public IDictionary<string, object>? Entity { get; set; }
}
