using System;
using System.ComponentModel.DataAnnotations;

namespace MigrationToDRX.Data.Models.Dto;

/// <summary>
/// Результат валидации сущности
/// </summary>
public class ValidationResult
{

    /// <summary>
    /// Успешность операции
    /// </summary>
    [Display(Name = "Успешность")]
    public string? Success { get; set; }

    public ValidationResult(bool success, string? errorMessage)
    {
        Success = success ? "Да" : errorMessage;
    }
}
