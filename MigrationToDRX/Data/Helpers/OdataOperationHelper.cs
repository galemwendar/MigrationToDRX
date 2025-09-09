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
    private static readonly StructuralFieldDto MainIdProperty = new()
    {
        Name = StringConstants.MainIdPropertyName,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary>
    /// Фейковое структурное поле Путь до файла
    /// </summary>
    /// <remarks>Является ключом для поиска файла на машине клиента
    ///  при добавлении или обновлении версии документа
    /// </remarks>
    private static readonly StructuralFieldDto PathProperty = new()
    {
        Name = StringConstants.PathPropertyName,
        Type = "Edm.String",
        Nullable = false
    };

    /// <summary>
    /// Добавляет свойства сущности в зависимости от операции
    /// </summary>
    /// <param name="operation"> Выбранная операция</param>
    /// <param name="properties">Список сущностей</param>
    /// <param name="columnMappings">Маппинг сущностей</param>
    public static void AddPropertiesByOperation(OdataOperation? operation, List<EntityFieldDto> properties, IDictionary<string, EntityFieldDto?> columnMappings)
    {
        if (operation == null)
        {
            return;
        }

        if (columnMappings.Any())
        {
            // Находим все ключи, значения которых равны MainIdProperty
            var keysToRemove = columnMappings
                .Where(kvp => kvp.Value == MainIdProperty || kvp.Value == PathProperty)
                .Select(kvp => kvp.Key)
                .ToList();
            if (keysToRemove.Any())
            {
                // Удаляем их
                foreach (var key in keysToRemove)
                {
                    columnMappings[key] = null; 
                } 
            }
        }
        
        properties.RemoveAll(p => p == MainIdProperty || p == PathProperty);

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
                properties.AddFirst(MainIdProperty);
                break;

            case OdataOperation.UpdateEntityInCollection:
                properties.AddFirst(MainIdProperty);
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
    public static string ComputeStamp(bool result, int entityId, DateTime timestamp)
    {
        var data = $"{result}|{entityId}|{timestamp:O}";
        
        using var sha256 = System.Security.Cryptography.SHA256.Create();
        var hashBytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(data));

        // Короткая и читаемая метка для Excel
        return BitConverter.ToString(hashBytes, 0, 8).Replace("-", "");
    }
}
