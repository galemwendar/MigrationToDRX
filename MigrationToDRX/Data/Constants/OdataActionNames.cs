namespace MigrationToDRX.Data.Constants;

/// <summary>
/// Наименование Action для поиска в Odata
/// </summary>
public static class OdataActionNames
{
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
    /// Наименование действия для добавления связей в Odata
    /// </summary>
    public const string AddRelationsAction = "AddRelations";

    /// <summary>
    /// Наименование действия для создания папки в родительской папке в Odata
    /// </summary>
    public const string CreateChildFolderAction = "CreateChildFolder";

    /// <summary>
    /// Наименование действия для добавления папки в родительскую папку в Odata
    /// </summary>
    public const string AddChildFolderAction = "AddChildFolder";

    /// <summary>
    /// Наименование действия для создания версии из шаблона в Odata
    /// </summary>
    public const string CreateVersionFromTemplateAction = "CreateVersionFromTemplate";

    /// <summary>
    /// Наименование действия для импорта подписи к документу в Odata
    /// </summary>
    public const string ImportSignatureToDocumentAction = "ImportSignatureToDocument";

    /// <summary>
    /// Наименование действия для добавления документа папку в Odata
    /// </summary>
    public const string AddDocumentToFolderAction = "AddDocumentToFolder";

    /// <summary>
    /// Наименование действия для переименования примечания версии документа.
    /// </summary>
    public const string RenameVersionNoteAction = "RenameVersionNote";
}