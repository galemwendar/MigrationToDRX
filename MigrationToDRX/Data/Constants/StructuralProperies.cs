using MigrationToDRX.Data.Models.Dto;

namespace MigrationToDRX.Data.Constants;

public static class StructuralProperies
{
        /// <summary>
    /// Фейковое структурное поле MainId
    /// </summary>
    /// <remarks>Является ключом для поиска сущности при обновлении 
    /// или поиска свойства - коллекции
    /// </remarks>
    public static readonly StructuralPropertyDto MainId = new()
    {
        Name = OdataPropertyNames.MainId,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле Путь до файла
    /// </summary>
    /// <remarks>Является ключом для поиска файла на машине клиента
    ///  при добавлении или обновлении версии документа
    /// </remarks>
    public static readonly StructuralPropertyDto Path = new()
    {
        Name = OdataPropertyNames.Path,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле accessRightsTypeGuid
    /// </summary>
    public static readonly StructuralPropertyDto AccessRightTypeGuid = new()
    {
        Name = OdataPropertyNames.AccessRightTypeGuid,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле documentId
    /// </summary>
    public static readonly StructuralPropertyDto DocumentId = new()
    {
        Name = OdataPropertyNames.DocumentId,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле folderId
    /// </summary>
    public static readonly StructuralPropertyDto FolderId = new()
    {
        Name = OdataPropertyNames.FolderId,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле recipientId
    /// </summary>
    public static readonly StructuralPropertyDto RecipientId = new()
    {
        Name = OdataPropertyNames.RecipientId,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле taskId
    /// </summary>
    public static readonly StructuralPropertyDto TaskId = new()
    {
        Name = OdataPropertyNames.TaskId,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле assignmentId
    /// </summary>
    public static readonly StructuralPropertyDto AssignmentId = new()
    {
        Name = OdataPropertyNames.AssignmentId,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле assignmentResult
    /// </summary>
    public static readonly StructuralPropertyDto Result = new()
    {
        Name = OdataPropertyNames.Result,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле signatureBase64
    /// </summary>
    public static readonly StructuralPropertyDto Signature = new()
    {
        Name = OdataPropertyNames.Signature,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле type
    /// </summary>
    public static readonly StructuralPropertyDto Type = new()
    {
        Name = OdataPropertyNames.Type,
        Type = "Edm.Int32",
        Nullable = false
    };

    /// <summary> 
    /// Фейковое структурное поле templateId
    /// </summary>
    public static readonly StructuralPropertyDto TemplateId = new()
    {
        Name = OdataPropertyNames.TemplateId,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary> 
    /// Фейковое структурное поле relationName
    /// </summary>
    public static readonly StructuralPropertyDto RelationName = new()
    {
        Name = OdataPropertyNames.RelationName,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary> 
    /// Фейковое структурное поле baseDocumentId
    /// </summary>
    public static readonly StructuralPropertyDto BaseDocumentId = new()
    {
        Name = OdataPropertyNames.BaseDocumentId,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary> 
    /// Фейковое структурное поле folderName
    /// </summary>
    public static readonly StructuralPropertyDto FolderName = new()
    {
        Name = OdataPropertyNames.FolderName,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary> 
    /// Фейковое структурное поле parentFolderId
    /// </summary>
    public static readonly StructuralPropertyDto ParentFolderId = new()
    {
        Name = OdataPropertyNames.ParentFolderId,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary> 
    /// Фейковое структурное поле relationDocumentId
    /// </summary>
    public static readonly StructuralPropertyDto RelationDocumentId = new()
    {
        Name = OdataPropertyNames.RelationDocumentId,
        Type = "Edm.Int64",
        Nullable = false
    };

    public static readonly StructuralPropertyDto NumberVersionId = new()
    {
        Name = OdataPropertyNames.NumberVersion,
        Type = "Edm.Int32",
        Nullable = false
    };

    public static readonly StructuralPropertyDto NoteVersion = new()
    {
        Name = OdataPropertyNames.NoteVersion,
        Type = "Edm.String",
        Nullable = false
    };
}