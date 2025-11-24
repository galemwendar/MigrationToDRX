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
    [Display(Name = "Создание сущности (документ/справочник/прочее)")]
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
    [Display(Name = "Выдача прав на документ")]
    GrantAccessRightsToDocument = 7,

    /// <summary>
    /// Предоставление доступа к папке
    /// </summary>
    [Display(Name = "Выдача прав на папку")]
    GrantAccessRightsToFolder = 8,

    /// <summary>
    /// Добавление документа в папку
    /// </summary>
    [Display(Name = "Добавление документа в папку")]
    AddDocumentToFolder = 9,

    /// <summary>
    /// Запуск задачи
    /// </summary>
    [Display(Name = "Стартовать задачу")]
    StartTask = 10,

    /// <summary>
    /// Выполнение задания
    /// </summary>
    [Display(Name = "Выполнить задание")]
    CompleteAssignment = 11,

    /// <summary>
    /// Добавление связей
    /// </summary>
    [Display(Name = "Добавление связей")]
    AddRelations = 12,

    /// <summary>
    /// Создание папки в родительской папке
    /// </summary>
    [Display(Name = "Создание папки в родительской папке")]
    CreateChildFolder = 13,

    /// <summary>
    /// Добавление папки в родительскую папку
    /// </summary>
    [Display(Name = "Добавление папки в родительскую папку")]
    AddChildFolder = 14,

    /// <summary>
    /// Создание версии из шаблона
    /// </summary>
    [Display(Name = "Создание версии из шаблона")]
    CreateVersionFromTemplate = 15,


    #region Пакет разработки ExcelMigrator

    /// <summary>
    /// Импорт подписи на документ
    /// </summary>
    [Display(Name = "Импортировать подпись на документ")]
    ImportSignatureToDocument = 100,

    /// <summary>
    /// Переименовать примечание версии документа.
    /// </summary>
    [Display(Name = "Переименовать примечание версии документа")]
    RenameVersionNote = 101,

    #endregion
}
