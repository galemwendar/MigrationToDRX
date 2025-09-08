using System.ComponentModel.DataAnnotations;

namespace MigrationToDRX.Data.Enums;

/// <summary>
/// Enum для обозначения элемента, по которому будет происходить поиск сущности
/// </summary>
public enum SearchEntityBy
{
    /// <summary>
    /// Имя сущности
    /// </summary>
    [Display(Name = "Имя сущности")]
    Name = 1,

    /// <summary>
    /// Идентификатор сущности
    /// </summary>
    [Display(Name = "Идентификатор сущности")]
    Id = 2,
}
