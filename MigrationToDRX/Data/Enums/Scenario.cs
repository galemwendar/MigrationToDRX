namespace MigrationToDRX.Data.Enums;

/// <summary>
/// Сценарий работы c ceoyjcnzvb
/// </summary>
public enum OdataScenario
{
    /// <summary>
    /// Создание сущности
    /// </summary>
    CreateEntity = 1,

    /// <summary>
    /// Обновление сущности
    /// </summary>
    UpdateEntity = 2,

    /// <summary>
    /// Создание документа с версией
    /// </summary>
    CreateDocumentWithVersion = 3,

    /// <summary>
    /// Добавление версии в существующий документ
    /// </summary>
    AddVersionToExistedDocument = 4,

    /// <summary>
    /// Добавление сущности в свойстве-коллекции
    /// </summary>
    AddEntityToCollection = 5,

    /// <summary>
    /// Обновление сущности в свойстве-коллекции
    /// </summary>
    UpdateEntityInCollection = 6,
}
