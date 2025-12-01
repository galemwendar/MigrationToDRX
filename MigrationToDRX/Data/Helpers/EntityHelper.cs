using MigrationToDRX.Data.Constants;
using MigrationToDRX.Data.Models.Dto;

namespace MigrationToDRX.Data.Helpers;

/// <summary>
/// Статический хелпер для работы с сущностями
/// </summary>
public static class EntityHelper
{
    /// <summary>
    /// Фильтрует служебные поля из сущности
    /// </summary>
    public static IDictionary<string, object> FilterServiceFields(IDictionary<string, object> entity)
    {
        return entity
            .Where(p => p.Key != OdataPropertyNames.Path
                && p.Key != OdataPropertyNames.MainId
                && p.Key != OdataPropertyNames.Id)
            .ToDictionary(p => p.Key, p => p.Value);
    }

    /// <summary>
    /// Получает значение поля из EntityDto по имени служебного свойства
    /// </summary>
    public static long GetFieldValueFromEntityDto(ProcessedEntityDto dto, string fieldName)
    {
        var fieldKey = dto.ColumnMapping
            .Where(kvp => kvp.Value is StructuralPropertyDto sf && sf.Name == fieldName)
            .Select(kvp => kvp.Key)
            .SingleOrDefault();

        long value = 0;

        if (fieldKey != null && dto.Row.TryGetValue(fieldKey, out var raw) && !string.IsNullOrWhiteSpace(raw))
        {
            value = Convert.ToInt64(raw.Trim());
        }

        return value;
    }

    /// <summary>
    /// Получает путь к файлу из EntityDto
    /// </summary>
    /// <param name="dto">Построенная сущность</param>
    /// <returns>строка с путем для файла</returns>
    public static string GetFilePathFromEntityDto(ProcessedEntityDto dto)
    {
        var filePathKey = dto.ColumnMapping
            .Where(kvp => kvp.Value is StructuralPropertyDto sf && sf.Name == OdataPropertyNames.Path)
            .Select(kvp => kvp.Key)
            .SingleOrDefault();

        string filePath = "";

        if (filePathKey != null && dto.Row.TryGetValue(filePathKey, out var raw) && !string.IsNullOrWhiteSpace(raw))
        {
            filePath = raw!.ToString()!.Trim();
        }

        return filePath;
    }

    /// <summary>
    /// Получает список свойств сущности в зависимости от ее структуры в Odata
    /// </summary>
    /// <param name="dto">DTO сущности</param>
    public static List<EntityFieldDto> GetEntityFields(EdmxEntityDto? dto)
    {
        if (dto == null)
        {
            return new();
        }

        var structuralProperties = dto.StructuralProperties
            .Select(p => new StructuralPropertyDto
            {
                Name = p.Name?.ToString() ?? "",
                Type = p.Type?.ToString() ?? "??????????",
                Nullable = p.Nullable
            })
            .ToList();

        var navigationProperties = dto.NavigationProperties
            .Select(p => new NavigationPropertyDto
            {
                Name = p.Name?.ToString() ?? "",
                Type = p.Type?.ToString() ?? "??????????",
                Nullable = p.Nullable
            })
            .ToList();

        // Заполняем поля сущности
        return structuralProperties
            .Concat<EntityFieldDto>(navigationProperties)
            .ToList();
    }
}
