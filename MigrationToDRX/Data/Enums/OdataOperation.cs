using System.ComponentModel.DataAnnotations;

namespace MigrationToDRX.Data.Enums;

/// <summary>
/// Enum для описания операций с OData
/// </summary>
public enum OdataOperation
{
    /// <summary>
    /// Создание сущности
    /// </summary>
    [Display(Name ="Создание сущности (документ/справочник/прочее)")]
    CreateEntity = 1,

    /// <summary>
    /// Обновление сущности
    /// </summary>
    [Display(Name = "Обновление сущности")]
    UpdateEntity = 2,

    /// <summary>
    /// Создание документа с версией
    /// </summary>
    [Display(Name = "Создание документа с версией")]
    CreateDocumentWithVersion = 3,

    /// <summary>
    /// Добавление версии в существующий документ
    /// </summary>
    [Display(Name = "Добавление версии в существующий документ")]
    AddVersionToExistedDocument = 4,

    /// <summary>
    /// Добавление сущности в свойстве-коллекции
    /// </summary>
    [Display(Name = "Добавление сущности в свойстве-коллекции")]
    AddEntityToCollection = 5,

    /// <summary>
    /// Обновление сущности в свойстве-коллекции
    /// </summary>
    [Display(Name = "Обновление сущности в свойстве-коллекции")]
    UpdateEntityInCollection = 6,

    /// <summary>
    /// Предоставление доступа к документу
    /// </summary>
    [Display(Name = "Предоставление доступа к документу")]
    GrantAccessRightsToDocument = 7,

    /// <summary>
    /// Отмена доступа к папке
    /// </summary>
    [Display(Name = "Предоставление доступа к папке")]
    GrantAccessRightsToFolder = 8,
}
