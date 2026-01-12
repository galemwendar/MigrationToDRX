using System.ComponentModel.DataAnnotations;

namespace MigrationToDRX.Data.Enums;

/// <summary>
/// Типы миграции
/// </summary>
public enum SourceType
{
    /// <summary>
    /// Excel
    /// </summary>
    [Display(Name = "Excel")]
    Excel = 1,

    /// <summary>
    /// База данных
    /// </summary>
    [Display(Name = "База данных (MSSQL)")]
    DatabaseMssql = 2
}
