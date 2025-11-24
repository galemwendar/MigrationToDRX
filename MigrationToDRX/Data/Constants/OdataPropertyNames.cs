using System;

namespace MigrationToDRX.Data.Constants;

/// <summary>
/// Константы для поиска свойств в сущности
/// </summary>
public static class OdataPropertyNames
{
    /// <summary>
    /// Строка для поиска свойства "Id главной сущности"
    /// </summary>
    public const string MainId = "Id главной сущности";

    /// <summary>
    /// Строка для поиска свойства "Id"
    /// </summary>
    public const string Id = "Id";

    /// <summary>
    /// Строка для поиска свойства "Путь до файла"
    /// </summary>
    public const string Path = "Путь до файла";
    
    /// <summary>
    /// Строка для поиска свойства "accessRightsTypeGuid"
    /// </summary>
    public const string AccessRightTypeGuid = "accessRightsTypeGuid";

    /// <summary>
    /// Строка для поиска свойства "documentId"
    /// </summary>
    public const string DocumentId = "documentId";

    /// <summary>
    /// Строка для поиска свойства "folderId"
    /// </summary>
    public const string FolderId = "folderId";

    /// <summary>
    /// Строка для поиска свойства "recipientId"
    /// </summary>
    public const string RecipientId = "recipientId";

    /// <summary>
    /// Строка для поиска свойства "taskId"
    /// </summary>
    public const string TaskId = "taskId";

    /// <summary>
    /// Строка для поиска свойства "assignmentId"
    /// </summary>
    public const string AssignmentId = "assignmentId";

    /// <summary>
    /// Строка для поиска свойства "assignmentResult"
    /// </summary>
    public const string Result = "result";

    /// <summary>
    /// Строка для поиска свойства "signatureBase64"
    /// </summary>
    public const string Signature = "signatureBase64";

    /// <summary>
    /// Строка для поиска типа подписи
    /// </summary>
    public const string Type = "type";

    /// <summary> 
    /// Строка для поиска Id шаблона 
    /// </summary>
    public const string TemplateId = "templateId";

    /// <summary> 
    /// Строка для поиска имени связи 
    /// </summary>
    public const string RelationName = "relationName";

    /// <summary> 
    /// Строка для поиска Id связываемого документа
    /// </summary>
    public const string BaseDocumentId = "baseDocumentId";

    /// <summary> 
    /// Строка для поиска имени папки
    /// </summary>
    public const string FolderName = "folderName";

    /// <summary> 
    /// Строка для поиска Id родительской папки
    /// </summary>
    public const string  ParentFolderId = "parentFolderId";

    /// <summary> 
    /// Строка для поиска Id связи 
    /// </summary>
    public const string RelationDocumentId = "relationDocumentId";

    /// <summary>
    /// Строка для поиска свойства "numberVersion"
    /// </summary>
    public const string NumberVersion = "numberVersion";

    /// <summary>
    /// Строка для поиска свойства "noteVersion"
    /// </summary>
    public const string NoteVersion = "noteVersion";

    /// <summary>
    /// Строка для поиска свойства "версии"
    /// </summary>
    public const string Versions = "Versions";

    /// <summary>
    /// Строка для поиска свойства "номер версии"
    /// </summary>
    public const string Number = "Number";
}
