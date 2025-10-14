using System;

namespace MigrationToDRX.Data.Constants;

/// <summary>
/// Строковые константы
/// </summary>
public class StringConstants
{
    /// <summary>
    /// Строка для поиска свойства "Id главной сущности"
    /// </summary>
    public const string MainIdPropertyName = "Id главной сущности";

    /// <summary>
    /// Строка для поиска свойства "Id"
    /// </summary>
    public const string IdPropertyName = "Id";

    /// <summary>
    /// Строка для поиска свойства "Путь до файла"
    /// </summary>
    public const string PathPropertyName = "Путь до файла";

    /// <summary>
    /// Строка для поиска свойства "Статус"
    /// </summary>
    public const string StatusPropertyName = "Status";

    /// <summary>
    /// Строка для поиска свойства "Тип нумерации"
    /// </summary>
    public const string NumberingTypePropertyName = "NumberingType";

    /// <summary>
    /// Строка для поиска свойства "Документопоток"
    /// </summary>
    public const string DocumentFlowPropertyName = "DocumentFlow";

    /// <summary>
    /// Строка для поиска свойства "accessRightsTypeGuid"
    /// </summary>
    public const string AccessRightTypeGuidPropertyName = "accessRightsTypeGuid";

    /// <summary>
    /// Строка для поиска свойства "documentId"
    /// </summary>
    public const string DocumentIdPropertyName = "documentId";

    /// <summary>
    /// Строка для поиска свойства "folderId"
    /// </summary>
    public const string FolderIdPropertyName = "folderId";

    /// <summary>
    /// Строка для поиска свойства "recipientId"
    /// </summary>
    public const string RecipientIdPropertyName = "recipientId";

    /// <summary>
    /// Строка для поиска свойства "приложение"
    /// </summary>
    public const string AssociatedApplication = "AssociatedApplication";

    /// <summary>
    /// Строка для поиска свойства "расширение"
    /// </summary>
    public const string Extension = "Extension";

    /// <summary>
    /// Строка для поиска свойства "версии"
    /// </summary>
    public const string Versions = "Versions";

    /// <summary>
    /// Строка для поиска свойства "номер версии"
    /// </summary>
    public const string Number = "Number";

    /// <summary>
    /// Наименование действия для выдачи прав на папку в Odata
    /// </summary>
    public const string GrantAccessRightsToFolderAction = "GrantAccessRightsToFolder";

    /// <summary>
    /// Наименование действия для выдачи прав на документ в Odata
    /// </summary>
    public const string GrantAccessRightsToDocumentAction = "GrantAccessRightsToDocument";

    /// <summary>
    /// Наименование действия для добавления документа папку в Odata
    /// </summary>
    public const string AddDocumentToFolderAction = "AddDocumentToFolder";

    /// <summary>
    /// Наименование сущности для выдачи прав на документ в Odata
    /// </summary>
    public const string Docflow = "Docflow";
}
