using System.ComponentModel.DataAnnotations;
using MigrationToDRX.Data.Helpers;

namespace MigrationToDRX.Data.Models.Dto;
/// <summary>
/// Результат выполнения операции
/// </summary>
public class OperationResult
{
    /// <summary>
    /// Наименование операции
    /// </summary>
    [Display(Name = "Операция")]
    public string OperationName { get; set; } = string.Empty;

    /// <summary>
    /// Успешность операции
    /// </summary>
    [Display(Name = "Успешность")]
    public bool Success { get; set; }

    /// <summary>
    /// Идентификатор сущности
    /// </summary>
    [Display(Name = "Идентификатор сущности")]
    public long? EntityId { get; set; }

    /// <summary>
    /// Сообщение об ошибке
    /// </summary>
    [Display(Name = "Сообщение об ошибке")]
    public string? ErrorMessage { get; set; }

    /// <summary>
    /// Метка времени проведения операции
    /// </summary>
    [Display(Name = "Метка времени проведения операции")]
    public DateTime Timestamp { get; private set; } = DateTime.Now;

    /// <summary>
    /// Подпись программы
    /// </summary>
    [Display(Name = "Подпись программы")]
    public string Stamp { get; set; } = string.Empty;

    /// <summary>
    /// Сущность, над которой выполнялась операция
    /// </summary>
    public IDictionary<string, object>? Entity { get; set; }

    public OperationResult(bool sucsess, string operationName, long? entityId = null, IDictionary<string, object>? entity = null, string? errorMessage = null)
    {
        Success = sucsess;
        OperationName = operationName;
        EntityId = entityId;
        Entity = entity;
        ErrorMessage = errorMessage;
        Timestamp = DateTime.Now;
        Stamp = sucsess ? OdataOperationHelper.ComputeStamp(sucsess, entityId ?? 0, Timestamp) : string.Empty;
    }
}