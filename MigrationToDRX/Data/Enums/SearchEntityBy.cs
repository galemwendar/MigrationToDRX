namespace MigrationToDRX.Data.Enums;

/// <summary>
/// Enum для обозначения элемента, по которому будет происходить поиск сущности
/// </summary>
public enum SearchEntityBy
{
    /// <summary>
    /// Имя сущности
    /// </summary>
    Name = 1,

    /// <summary>
    /// Идентификатор сущности
    /// </summary>
    Id = 2,
}
