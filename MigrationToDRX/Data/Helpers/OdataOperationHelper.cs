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
    public static List<EntityFieldDto> AddPropertiesByOperation(OdataOperation? operation, List<EntityFieldDto> properties)
    {
        if (operation == null)
        {
            return properties;
        }

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

        return properties;
    }

}
