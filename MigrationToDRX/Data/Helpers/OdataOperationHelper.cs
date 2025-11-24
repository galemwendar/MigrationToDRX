using System.ComponentModel.DataAnnotations;
using System.Reflection;
using MigrationToDRX.Data.Constants;
using MigrationToDRX.Data.Enums;
using MigrationToDRX.Data.Extensions;
using MigrationToDRX.Data.Models.Dto;

namespace MigrationToDRX.Data.Helpers;

/// <summary>
/// Статический хелпер для работы с операциями миграции
/// </summary>
public static class OdataOperationHelper
{
    /// <summary>
    /// Список служебных полей
    /// </summary>
    private static readonly HashSet<StructuralPropertyDto> ServiceFields = new()
    {
        StructuralProperies.MainId,
        StructuralProperies.Path,
        StructuralProperies.AccessRightTypeGuid,
        StructuralProperies.DocumentId,
        StructuralProperies.FolderId,
        StructuralProperies.RecipientId,
        StructuralProperies.TaskId,
        StructuralProperies.AssignmentId,
        StructuralProperies.Result,
        StructuralProperies.Signature,
        StructuralProperies.Type,
        StructuralProperies.TemplateId,
        StructuralProperies.RelationName,
        StructuralProperies.BaseDocumentId,
        StructuralProperies.FolderName,
        StructuralProperies.ParentFolderId,
        StructuralProperies.RelationDocumentId,
        StructuralProperies.NoteVersion,
        StructuralProperies.NumberVersionId,
    };

    /// <summary>
    /// Операции, требующие выбора сущности для поиска
    /// </summary>
    public static readonly HashSet<OdataOperation> OperationsRequiringEntitySelection = new()
    {
        OdataOperation.AddEntityToCollection,
        OdataOperation.UpdateEntityInCollection,
        OdataOperation.AddVersionToExistedDocument,
        OdataOperation.CreateDocumentWithVersion,
        OdataOperation.CreateEntity,
        OdataOperation.UpdateEntity
    };

    /// <summary>
    /// Проверяет, требует ли операция записи EntityId в результат
    /// </summary>
    /// <param name="operationName">Имя операции (Display Name)</param>
    /// <returns>True, если операция требует записи EntityId</returns>
    public static bool RequiresEntityIdInResult(string operationName)
    {
        return OperationsRequiringEntitySelection.Any(op => op.GetDisplayName() == operationName);
    }

    /// <summary>
    /// Список операций, требующих работы со свойствами-коллекциями
    /// </summary>
    public static readonly HashSet<OdataOperation> OperationsWithCollections = new()
    {
        OdataOperation.AddEntityToCollection,
        OdataOperation.UpdateEntityInCollection
    };

    /// <summary>
    /// Добавляет свойства сущности в зависимости от операции
    /// </summary>
    /// <param name="operation">Выбранная операция</param>
    /// <param name="properties">Список свойств</param>
    /// <param name="columnMappings">Маппинг колонок</param>
    public static void AddPropertiesByOperation(
        OdataOperation? operation,
        List<EntityFieldDto> properties,
        IDictionary<string, EntityFieldDto?> columnMappings)
    {
        if (operation == null)
            return;

        // Удаляем старые служебные поля из маппинга
        RemoveServiceFieldsFromMapping(columnMappings);

        // Удаляем старые служебные поля из списка свойств
        RemoveServiceFieldsFromProperties(properties);

        // Для операций только со служебными свойствами очищаем маппинг
        if (OperationsRequiringEntitySelection.Contains(operation.Value) == false)
        {
            RemoveAllFieldsFromMapping(columnMappings);
        }

        // Добавляем нужные служебные поля в зависимости от операции
        AddServiceFieldsByOperation(operation.Value, properties);
    }

    /// <summary>
    /// Удаляет служебные поля из маппинга
    /// </summary>
    private static void RemoveServiceFieldsFromMapping(IDictionary<string, EntityFieldDto?> columnMappings)
    {
        if (!columnMappings.Any())
            return;

        var keysToRemove = columnMappings
            .Where(kvp => kvp.Value != null && ServiceFields.Contains(kvp.Value))
            .Select(kvp => kvp.Key)
            .ToList();

        foreach (var key in keysToRemove)
            columnMappings[key] = null;
    }

    /// <summary>
    /// Удаляет служебные поля из маппинга
    /// </summary>
    private static void RemoveAllFieldsFromMapping(IDictionary<string, EntityFieldDto?> columnMappings)
    {
        if (!columnMappings.Any())
            return;

        var keysToRemove = columnMappings
            .Where(kvp => kvp.Value != null)
            .Select(kvp => kvp.Key)
            .ToList();

        foreach (var key in keysToRemove)
            columnMappings[key] = null;
    }

    /// <summary>
    /// Удаляет служебные поля из списка свойств
    /// </summary>
    private static void RemoveServiceFieldsFromProperties(List<EntityFieldDto> properties)
    {
        properties.RemoveAll(p => ServiceFields.Contains(p));
    }

    /// <summary>
    /// Добавляет служебные поля в зависимости от операции
    /// </summary>
    private static void AddServiceFieldsByOperation(OdataOperation operation, List<EntityFieldDto> properties)
    {
        switch (operation)
        {
            case OdataOperation.CreateEntity:
                break;

            case OdataOperation.UpdateEntity:
                properties.AddFirst(StructuralProperies.MainId);
                break;

            case OdataOperation.CreateDocumentWithVersion:
                properties.AddFirst(StructuralProperies.Path);
                break;

            case OdataOperation.AddVersionToExistedDocument:
                properties.AddFirstRange(new[] { StructuralProperies.MainId, StructuralProperies.Path });
                break;

            case OdataOperation.AddEntityToCollection:
            case OdataOperation.UpdateEntityInCollection:
                properties.AddFirst(StructuralProperies.MainId);
                break;

            case OdataOperation.GrantAccessRightsToDocument:
                properties.AddFirst(StructuralProperies.AccessRightTypeGuid);
                properties.AddFirst(StructuralProperies.DocumentId);
                properties.AddFirst(StructuralProperies.RecipientId);
                break;

            case OdataOperation.GrantAccessRightsToFolder:
                properties.AddFirst(StructuralProperies.AccessRightTypeGuid);
                properties.AddFirst(StructuralProperies.FolderId);
                properties.AddFirst(StructuralProperies.RecipientId);
                break;

            case OdataOperation.AddDocumentToFolder:
                properties.AddFirst(StructuralProperies.DocumentId);
                properties.AddFirst(StructuralProperies.FolderId);
                break;

            case OdataOperation.StartTask:
                properties.AddFirst(StructuralProperies.TaskId);
                break;

            case OdataOperation.CompleteAssignment:
                properties.AddFirst(StructuralProperies.AssignmentId);
                properties.AddFirst(StructuralProperies.Result);
                break;

            case OdataOperation.ImportSignatureToDocument:
                properties.AddFirst(StructuralProperies.DocumentId);
                properties.AddFirst(StructuralProperies.Path);
                properties.AddFirst(StructuralProperies.Type);
                break;

            case OdataOperation.CreateChildFolder:
                properties.AddFirst(StructuralProperies.FolderName);
                properties.AddFirst(StructuralProperies.ParentFolderId);
                break;

            case OdataOperation.AddChildFolder:
                properties.AddFirst(StructuralProperies.FolderId);
                properties.AddFirst(StructuralProperies.ParentFolderId);
                break;

            case OdataOperation.CreateVersionFromTemplate:
                properties.AddFirst(StructuralProperies.DocumentId);
                properties.AddFirst(StructuralProperies.TemplateId);
                break;

            case OdataOperation.AddRelations:
                properties.AddFirst(StructuralProperies.RelationName);
                properties.AddFirst(StructuralProperies.BaseDocumentId);
                properties.AddFirst(StructuralProperies.RelationDocumentId);
                break;
            
            case OdataOperation.RenameVersionNote:
                properties.AddFirst(StructuralProperies.DocumentId);
                properties.AddFirst(StructuralProperies.NumberVersionId);
                properties.AddFirst(StructuralProperies.NoteVersion);
                break;

            default:
                break;
        }
    }

    /// <summary>
    /// Поставить метку на результат операции
    /// </summary>
    /// <param name="result">Результат операции</param>
    /// <param name="entityId">Идентификатор сущности, над которой проводилась операция</param>
    /// <param name="timestamp">Время выполнения операции</param>
    /// <returns>Метка, которая указывает, что операция выполнялась данной программой.</returns>
    public static string ComputeStamp(bool result, long entityId, DateTime timestamp)
    {
        var data = $"{result}|{entityId}|{timestamp:O}";

        using var sha256 = System.Security.Cryptography.SHA256.Create();
        var hashBytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(data));

        // Короткая и читаемая метка для Excel
        return BitConverter.ToString(hashBytes, 0, 8).Replace("-", "");
    }

    /// <summary>
    /// Получает список свойств объекта и возвращает список их названий
    /// на основе атрибута DisplayName
    /// </summary>
    public static List<string> GetDisplayNames<T>()
    {
        return typeof(T)
            .GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance)
            .Select(p => p.GetCustomAttribute<DisplayAttribute>())
            .Where(attr => attr != null)
            .Select(attr => attr!.Name ?? string.Empty)
            .ToList();
    }

    /// <summary>
    /// Получает Display(Name) поля или свойства типа T по его имени.
    /// Если атрибута Display нет — возвращает имя поля.
    /// </summary>
    public static string GetDisplayName<T>(string propertyName)
    {
        if (string.IsNullOrEmpty(propertyName))
            throw new ArgumentNullException(nameof(propertyName));

        var prop = typeof(T).GetProperty(propertyName, BindingFlags.Public | BindingFlags.Instance);
        if (prop == null) return propertyName;

        var displayAttr = prop.GetCustomAttribute<DisplayAttribute>();
        return displayAttr?.Name ?? propertyName;
    }
}
