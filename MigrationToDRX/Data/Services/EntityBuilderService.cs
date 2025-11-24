using System;
using System.Text.RegularExpressions;
using MigrationToDRX.Data.Constants;
using MigrationToDRX.Data.Enums;
using MigrationToDRX.Data.Helpers;
using MigrationToDRX.Data.Models;
using MigrationToDRX.Data.Models.Dto;

namespace MigrationToDRX.Data.Services;

/// <summary>
/// Сервис предназначен для создания сущностей на основе Excel файла
/// </summary>
public class EntityBuilderService
{
    private readonly OdataClientService _odataClientService;
    private readonly FileService _fileService;

    public EntityBuilderService(OdataClientService odataClientService, FileService fileService)
    {
        _odataClientService = odataClientService;
        _fileService = fileService;
    }

    /// <summary>
    /// Создает сущность на основе Excel файла
    /// </summary>
    /// <param name="dto"></param>
    /// <returns>Готовая сущность для вставки в OData</returns>
    public async Task<IDictionary<string, object>> BuildEntityFromRow(ProcessedEntityDto dto, CancellationToken? ct)
    {
        var buildedEntity = new Dictionary<string, object>();

        var generatedColumns = new List<string>();

        generatedColumns.AddRange(OdataOperationHelper.GetDisplayNames<Data.Models.Dto.OperationResult>());
        generatedColumns.AddRange(OdataOperationHelper.GetDisplayNames<Data.Models.Dto.ValidationResult>());
        generatedColumns.Remove(SystemConstants.IdColumnResult);

        foreach (var (excelColumn, entityField) in dto.ColumnMapping.Where(p => !generatedColumns.Contains(p.Key)|| p.Value != null))
        {
            ct?.ThrowIfCancellationRequested();
            
            if (entityField == null || !dto.Row.TryGetValue(excelColumn, out var cellValue) || string.IsNullOrWhiteSpace(cellValue))
                continue;

            switch (entityField)
            {
                case StructuralPropertyDto structural:
                    await HandleStructuralField(structural, cellValue, dto, buildedEntity, ct);
                    break;

                case NavigationPropertyDto navigation:
                    await HandleNavigationProperty(navigation, cellValue, dto, buildedEntity, ct);
                    break;
            }
        }

        return buildedEntity;
    }

    /// <summary>
    /// Обработка структурного поля
    /// </summary>
    private async Task HandleStructuralField(StructuralPropertyDto structural, 
        string cellValue, 
        ProcessedEntityDto dto, 
        IDictionary<string, object> buildedEntity,
        CancellationToken? ct)
    {
        ct?.ThrowIfCancellationRequested();

        if (structural.Name == OdataPropertyNames.MainId)
        {
            await EnsureEntityExists(SearchEntityBy.Id, 
                cellValue, 
                dto.EntitySetName, 
                $"Не найдена сущность для добавление в {dto.EntitySetName} Id {cellValue}", 
                ct);

            return;
        }

        if (structural.Name == OdataPropertyNames.AccessRightTypeGuid)
        {
            var access = AccessRight.Find(cellValue);

            if (access == null)
            {
                throw new Exception($"Не удалось конвертировать {cellValue} в право доступа");
            }

            buildedEntity[structural.Name] = access.Id;

            return;
        }

        if (structural.Name == OdataPropertyNames.Path)
        {
            HandleFilePath(cellValue, structural.Name, buildedEntity);

            return;
        }

        var convertedValue = EdmTypeHelper.ConvertEdmValue(cellValue, structural.Type!);
        buildedEntity[structural.Name!] = convertedValue ?? throw new Exception($"Не удалось конвертировать {cellValue} в {structural.Type}");
    }

    /// <summary>
    /// Обработка свойства-коллекции
    /// </summary>
    private async Task HandleNavigationProperty(NavigationPropertyDto navigation, 
        string cellValue, 
        ProcessedEntityDto dto, 
        IDictionary<string, object> buildedEntity,
        CancellationToken? ct)
    {
        ct?.ThrowIfCancellationRequested();

        if (navigation.IsCollection || navigation.Type == null || navigation.Name == null)
            return;

        var entitySet = await _odataClientService.GetEntitySetNameByType(navigation.Type)
                    ?? throw new Exception($"Не удалось найти сущность по типу {navigation.Type}");

        if (entitySet == null)
        {
            throw new Exception($"Не удалось найти сущность по типу {navigation.Type}");
        }

        var relatedEntity = await FindRelatedEntity(dto.SearchCriteria, cellValue, entitySet, ct);

        if (relatedEntity != null && relatedEntity.Any())
            buildedEntity[navigation.Name] = relatedEntity;
        else
            throw new Exception($"Не найдена связанная сущность {navigation.Name} по ключу {dto.SearchCriteria}: {cellValue}");
    }

    /// <summary>
    /// Проверяет, настроено ли соединение с OData-сервисом.
    /// </summary>
    private async Task EnsureEntityExists(SearchEntityBy criteria, 
        string value, 
        string entitySet, 
        string errorMessage,
        CancellationToken? ct)
    {
        ct?.ThrowIfCancellationRequested();

        var entity = await FindRelatedEntity(criteria, value, entitySet, ct);
        if (entity == null)
            throw new Exception(errorMessage);
    }

    /// <summary>
    /// Обработка пути к файлу
    /// </summary>
    /// <param name="filePath"></param>
    /// <param name="propertyName"></param>
    /// <param name="buildedEntity"></param>
    /// <exception cref="FileNotFoundException"></exception>
    /// <exception cref="Exception"></exception>
    private void HandleFilePath(string filePath, string propertyName, IDictionary<string, object> buildedEntity)
    {
        if (string.IsNullOrWhiteSpace(filePath))
            return;

        if (!_fileService.IsFileExists(filePath))
            throw new FileNotFoundException($"Файл не найден: {filePath}");

        if (!_fileService.IsLessThenTwoGb(filePath))
            throw new Exception($"Файл слишком большой: {filePath}");

        buildedEntity[propertyName] = filePath;
    }

    /// <summary>
    /// Поиск связанной сущности по значению свойства
    /// </summary>
    private async Task<IDictionary<string, object>?> FindRelatedEntity(SearchEntityBy searchCriteria, 
        string cellValue, 
        string entitySet, 
        CancellationToken? ct)
    {
        ct?.ThrowIfCancellationRequested();

        Type filterType;

        if (searchCriteria == SearchEntityBy.Id)
        {
            filterType = typeof(long);
        }
        else
        {
            filterType = typeof(string);
        }

        // Убираем пробелы и обрабатываем входные данные
        var input = Regex.Replace(cellValue, @"\s+", " ").Trim();

        var relatedEntity = await _odataClientService.GetEntityAsync(entitySet, searchCriteria.ToString(), filterType, input, ct);
        return relatedEntity;
    }
}
