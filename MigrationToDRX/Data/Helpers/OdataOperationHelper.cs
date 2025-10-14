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
    /// Фейковое структурное поле MainId
    /// </summary>
    /// <remarks>Является ключом для поиска сущности при обновлении 
    /// или поиска свойства - коллекции
    /// </remarks>
    public static readonly StructuralFieldDto MainIdProperty = new()
    {
        Name = StringConstants.MainIdPropertyName,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле Путь до файла
    /// </summary>
    /// <remarks>Является ключом для поиска файла на машине клиента
    ///  при добавлении или обновлении версии документа
    /// </remarks>
    public static readonly StructuralFieldDto PathProperty = new()
    {
        Name = StringConstants.PathPropertyName,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле accessRightsTypeGuid
    /// </summary>
    public static readonly StructuralFieldDto AccessRightTypeGuidProperty = new()
    {
        Name = StringConstants.AccessRightTypeGuidPropertyName,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле documentId
    /// </summary>
    public static readonly StructuralFieldDto DocumentIdProperty = new()
    {
        Name = StringConstants.DocumentIdPropertyName,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле folderId
    /// </summary>
    public static readonly StructuralFieldDto FolderIdProperty = new()
    {
        Name = StringConstants.FolderIdPropertyName,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле recipientId
    /// </summary>
    public static readonly StructuralFieldDto RecipientIdProperty = new()
    {
        Name = StringConstants.RecipientIdPropertyName,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле taskId
    /// </summary>
    public static readonly StructuralFieldDto TaskIdProperty = new()
    {
        Name = StringConstants.TaskIdPropertyName,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле assignmentId
    /// </summary>
    public static readonly StructuralFieldDto AssignmentIdProperty = new()
    {
        Name = StringConstants.AssignmentIdPropertyName,
        Type = "Edm.Int64",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле assignmentResult
    /// </summary>
    public static readonly StructuralFieldDto ResultProperty = new()
    {
        Name = StringConstants.ResultPropertyName,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле signatureBase64
    /// </summary>
    public static readonly StructuralFieldDto SignatureProperty = new()
    {
        Name = StringConstants.SignaturePropertyName,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле type
    /// </summary>
    public static readonly StructuralFieldDto TypeProperty = new()
    {
        Name = StringConstants.TypePropertyName,
        Type = "Edm.Int32",
        Nullable = false
    };

    /// <summary>
    /// Список служебных полей
    /// </summary>
    private static readonly HashSet<StructuralFieldDto> ServiceFields = new()
    {
        MainIdProperty,
        PathProperty,
        AccessRightTypeGuidProperty,
        DocumentIdProperty,
        FolderIdProperty,
        RecipientIdProperty,
        TaskIdProperty,
        AssignmentIdProperty,
        ResultProperty,
        SignatureProperty,
        TypeProperty
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
                properties.AddFirst(MainIdProperty);
                break;

            case OdataOperation.CreateDocumentWithVersion:
                properties.AddFirst(PathProperty);
                break;

            case OdataOperation.AddVersionToExistedDocument:
                properties.AddFirstRange(new[] { MainIdProperty, PathProperty });
                break;

            case OdataOperation.AddEntityToCollection:
            case OdataOperation.UpdateEntityInCollection:
                properties.AddFirst(MainIdProperty);
                break;

            case OdataOperation.GrantAccessRightsToDocument:
                properties.AddFirst(AccessRightTypeGuidProperty);
                properties.AddFirst(DocumentIdProperty);
                properties.AddFirst(RecipientIdProperty);
                break;

            case OdataOperation.GrantAccessRightsToFolder:
                properties.AddFirst(AccessRightTypeGuidProperty);
                properties.AddFirst(FolderIdProperty);
                properties.AddFirst(RecipientIdProperty);
                break;

            case OdataOperation.StartTask:
                properties.AddFirst(TaskIdProperty);
                break;

            case OdataOperation.CompleteAssignment:
                properties.AddFirst(AssignmentIdProperty);
                properties.AddFirst(ResultProperty);
                break;

            case OdataOperation.ImportSignatureToDocument:
                properties.AddFirst(DocumentIdProperty);
                properties.AddFirst(PathProperty);
                properties.AddFirst(TypeProperty);
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
