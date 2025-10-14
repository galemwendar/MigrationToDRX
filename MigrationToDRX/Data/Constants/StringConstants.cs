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

    public const string IdColumnResult = "Идентификатор сущности";

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
    /// Строка для поиска свойства "taskId"
    /// </summary>
    public const string TaskIdPropertyName = "taskId";

    /// <summary>
    /// Строка для поиска свойства "assignmentId"
    /// </summary>
    public const string AssignmentIdPropertyName = "assignmentId";

    /// <summary>
    /// Строка для поиска свойства "assignmentResult"
    /// </summary>
    public const string ResultPropertyName = "result";

    public const string SignaturePropertyName = "signatureBase64";

    public const string TypePropertyName = "type";
    

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
    /// Наименование действия для создания документа в Odata
    /// </summary>
    public const string StartTaskAction = "StartTask";

    /// <summary>
    /// Наименование действия для завершения документа в Odata
    /// </summary>
    public const string CompleteAssignmentAction = "CompleteAssignment";

    /// <summary>
    /// Наименование действия для импорта подписи к документу в Odata
    /// </summary>
    public const string ImportSignatureToDocumentAction = "ImportSignatureToDocument";

    /// <summary>
    /// namespace Docflow
    /// </summary>
    public const string Docflow = "Docflow";

    /// <summary>
    /// namespace ExcelMigrator
    /// </summary>
    public const string ExcelMigrator = "ExcelMigrator";
}
