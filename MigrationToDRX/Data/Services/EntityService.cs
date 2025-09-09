using MigrationToDRX.Data.Constants;
using MigrationToDRX.Data.Enums;
using MigrationToDRX.Data.Helpers;
using MigrationToDRX.Data.Models.Dto;

namespace MigrationToDRX.Data.Services;

/// <summary>
/// Сервис для работы с сущностями
/// </summary>
public class EntityService
{
    /// <summary>
    /// Сервис для работы с OData
    /// </summary>
    private readonly OdataClientService _odataClientService;

    /// <summary>
    /// Сервис для работы с файлами
    /// </summary>
    private readonly FileService _fileService;


    public EntityService(OdataClientService odataClientService, FileService fileService)
    {
        _odataClientService = odataClientService;
        _fileService = fileService;
    }

    // public async Task<Dictionary<string, object>> CreateEntityAsync(IDictionary<string, object> excelRow, Dictionary<string, string> columnMapping, EdmxEntityDto entitydto)
    // {
    //     var structuralMap = entitydto.StructuralProperties
    //     .ToDictionary(p => p.Name!, p => p);
    //
    //     var navigationMap = entitydto.NavigationProperties
    //         .ToDictionary(p => p.Name!, p => p);
    //
    //     var result = new Dictionary<string, object>();
    //
    //     foreach (var excelCol in columnMapping.Keys)
    //     {
    //         var value = excelRow.TryGetValue(excelCol, out var val) ? val : null;
    //         var entityProp = columnMapping[excelCol];
    //
    //         if (string.IsNullOrWhiteSpace(entityProp))
    //             continue;
    //
    //         if (structuralMap.TryGetValue(entityProp, out var structProp))
    //         {
    //             if (structProp.Name == "Status" && EdmTypeHelper.StatusValues.TryGetValue(value?.ToString()!, out var status))
    //             {
    //                 result[structProp.Name!] = status;
    //             }
    //             else
    //             {
    //                 result[structProp.Name!] = ConvertToODataType(value, structProp.Type)!;
    //             }
    //         }
    //         else if (navigationMap.TryGetValue(entityProp, out var navProp) && !navProp.IsCollection)
    //         {
    //             if (entityProp == "MainId")
    //             {
    //                 result["MainId"] = value!;
    //                 continue;
    //             }
    //
    //             if (EdmTypeHelper.SearchByName)
    //             {
    //                 var relatedEntity = await _odataClientService.GetEntityAsync(navProp.Type!, EdmTypeHelper.SearchCryteria, value!);
    //                 result[navProp.Name!] = relatedEntity;
    //             }
    //             else
    //             {
    //                 if (int.TryParse(value?.ToString(), out int id))
    //                 {
    //                     var relatedEntity = await _odataClientService.GetEntityAsync(navProp.Type!, id);
    //                     result[navProp.Name!] = relatedEntity;
    //                 }
    //             }
    //         }
    //     }
    //
    //     return result;
    // }

    /// <summary>
    /// Конвертация типа в тип, понятный odata
    /// </summary>
    /// <param name="value"></param>
    /// <param name="edmType"></param>
    /// <returns></returns>
    private static object? ConvertToODataType(object? value, string? edmType)
    {
        if (value == null || edmType == null)
            return null;

        return edmType switch
        {
            "Edm.Int32" => int.TryParse(value.ToString(), out var i) ? i : null,
            "Edm.Int64" => long.TryParse(value.ToString(), out var l) ? l : null,
            "Edm.String" => value.ToString(),
            "Edm.Boolean" => bool.TryParse(value.ToString(), out var b) ? b : null,
            "Edm.DateTimeOffset" => DateTimeOffset.Parse(value.ToString() ?? string.Empty),
            "Edm.Double" => double.TryParse(value.ToString(), out var d) ? d : null,
            "Edm.Guid" => Guid.TryParse(value.ToString(), out var g) ? g : null,
            _ => value // по умолчанию
        };
    }


    /// <summary>
    /// Обработка сценария работы с сущностями
    /// </summary>
    /// <param name="entity">Сущность для создания\обновления</param>
    /// <param name="entitySet">Коллекция сущностей</param>
    /// <param name="scenario">Сценарий работы</param>
    /// <returns>Результат выполнения</returns>
    /// <exception cref="ArgumentException"></exception>
    public async Task<SaveEntityResult> ProceedEntitiesToOdata(ProcessedEntityDto dto)
    {
        return dto.Scenario switch
        {
            OdataOperation.CreateEntity => await CreateEntityAsyncWithResult(dto),
            OdataOperation.UpdateEntity => await UpdateEntityAsyncWithResult(dto),
            OdataOperation.CreateDocumentWithVersion => await CreateDocumentWithVersionAsync(dto),
            OdataOperation.AddVersionToExistedDocument => await AddVersionToExistedDocumentAsync(dto),
            OdataOperation.AddEntityToCollection => await AddEntityToCollectionAsync(dto),
            OdataOperation.UpdateEntityInCollection => await UpdateEntityInCollectionAsync(dto),
            _ => throw new ArgumentException("Не удалось обработать сценарий")
        };
    }

    private async Task<SaveEntityResult> UpdateEntityAsyncWithResult(ProcessedEntityDto dto)
    {
        throw new NotImplementedException();
    }


    private async Task<SaveEntityResult> UpdateEntityInCollectionAsync(ProcessedEntityDto dto)
    {
        throw new NotImplementedException();
    }


    private async Task<SaveEntityResult> AddEntityToCollectionAsync(ProcessedEntityDto dto)
    {
        throw new NotImplementedException();
    }


    private async Task<SaveEntityResult> AddVersionToExistedDocumentAsync(ProcessedEntityDto dto)
    {
        throw new NotImplementedException();
    }


    private async Task<SaveEntityResult> UpdateEntityAsync(ProcessedEntityDto dto)
    {
        var eDocId = dto.Entity!.TryGetValue(StringConstants.MainIdPropertyName, out var id) ? (long)id : 0;

        if (eDocId == 0)
        {
            return new SaveEntityResult()
            {
                Success = false,
                Error = "Не удалось найти Id документа"
            };
        }

        var filePath = dto.Entity!.TryGetValue(StringConstants.PathPropertyName, out var path) ? (string)path : "";

        if (filePath != null && _fileService.IsFileExists(filePath) && _fileService.IsLessThenTwoGb(filePath))
        {
            await FindEdocAndSetBodyAsync(eDocId, filePath);
            return new SaveEntityResult()
            {
                Success = true,
            };
        }
        else
        {
            return new SaveEntityResult()
            {
                Success = false,
                Error = "Файл не найден или слишком большой"
            };
        }

    }


    /// <summary>
    /// Создание сущностей
    /// </summary>
    /// <param name="entity"></param>
    /// <param name="entitySet"></param>
    /// <returns>Дто результата создания сущности</returns>
    public async Task<SaveEntityResult> CreateEntityAsyncWithResult(ProcessedEntityDto dto)
    {
        var result = new SaveEntityResult();
        try
        {
            IDictionary<string, object>? savedEntity = await InstertEntityAsync(dto);
            result.Entity = savedEntity;
            result.Success = true;
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Error = ex.Message;
        }

        return result;
    }




    public async Task<SaveEntityResult> CreateDocumentWithVersionAsync(ProcessedEntityDto dto)
    {
        try
        {
            IDictionary<string, object>? savedEntity = await InstertEntityAsync(dto);

            if (savedEntity != null && savedEntity.TryGetValue("Id", out var id))
            {
                var filePath = dto.Entity!.TryGetValue(StringConstants.PathPropertyName, out var path)
                    ? path?.ToString() ?? ""
                    : "";


                if (string.IsNullOrWhiteSpace(filePath) == false && _fileService.IsFileExists(filePath) && _fileService.IsLessThenTwoGb(filePath))
                {
                    var eDocId = Convert.ToInt64(id);
                    await FindEdocAndSetBodyAsync(eDocId, filePath);
                    return new SaveEntityResult()
                    {
                        Entity = savedEntity,
                        Success = true,
                    };
                }
                else
                {
                    return new SaveEntityResult()
                    {
                        Success = false,
                        Error = "Файл не найден или слишком большой"
                    };
                }
            }
            else
            {
                return new SaveEntityResult()
                {
                    Success = false,
                    Error = "Не удалось создать документ"
                };
            }
        }
        catch (Exception ex)
        {
            return new SaveEntityResult()
            {
                Success = false,
                Error = ex.Message
            };
        }

    }

    /// <summary>
    /// Создать тело документа
    /// </summary>
    /// <param name="eDocId"></param>
    /// <param name="filePath"></param>
    /// <param name="ForceUpdateBody"></param>
    /// <returns></returns>
    private async Task FindEdocAndSetBodyAsync(long eDocId, string filePath, bool ForceUpdateBody = false)
    {
        var eDoc = await _odataClientService.FindEdocAsync(eDocId);

        if (eDoc == null)
        {
            throw new ArgumentException("Не удалось найти документ");
        }

        var extension = Path.GetExtension(filePath).Replace(".", "");

        eDoc.TryGetValue("Id", out var docIdObj);

        if (docIdObj == null)
        {
            throw new ArgumentException("Не удалось найти Id документа");
        }

        var docId = Convert.ToInt64(docIdObj);

        var version = GetLastVersion(extension, eDoc);
        var targetApp = await _odataClientService.FindAssociatedApplication(extension);

        if (targetApp == null)
        {
            return;
        }

        if (version == null)
        {
            version = await _odataClientService.CreateNewVersion(docId, "Первоначальная версия", targetApp);
        }

        else if (NeedNewVersion(extension, version) || ForceUpdateBody == true)
        {
            version = await _odataClientService.CreateNewVersion(docId, Path.GetFileName(filePath), targetApp);
        }

        var body = await File.ReadAllBytesAsync(filePath);
        await _odataClientService.FillBodyAsync(docId, body, version!);
    }

    /// <summary>
    /// Проверяет необходимость создания новой версии
    /// </summary>
    /// <param name="extension">расширение файла</param>
    /// <param name="version">верия</param>
    private bool NeedNewVersion(string extension, IDictionary<string, object> version)
    {

        if (!version.TryGetValue("AssociatedApplication", out var application))
        { return true; }

        if (application is IDictionary<string, object> currentApp && currentApp.TryGetValue("Extension", out var currentExtension))
        { return currentExtension.ToString() != extension; }

        return true;

    }

    /// <summary>
    /// Получает последнюю версию документа
    /// </summary>
    /// <param name="extension">расширение файла</param>
    /// <param name="eDoc">документ</param>
    /// <returns>последняя версия</returns>
    private IDictionary<string, object>? GetLastVersion(string extension, IDictionary<string, object> eDoc)
    {
        if (eDoc.TryGetValue("Versions", out var versions))
        {
            if (versions == null)
            {
                return null;
            }

            if (versions is IEnumerable<IDictionary<string, object>> versionList)
            {
                var version = versionList
                    .Select(version => new
                    {
                        Version = version,
                        Number = version["Number"] as int? ?? 0 // Преобразование "Number" в int
                    })
                    .OrderByDescending(version => version.Number)
                    .FirstOrDefault();

                return version?.Version ?? null;
            }
            else if (versions is IDictionary<string, object> versionDict)
            {
                return versionDict;
            }
        }
        return null;
    }

    /// <summary>
    /// Находит связанные сущности и вставляет их в сущность
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    private async Task<IDictionary<string, object>?> FindRelatedEntitiesAsync(ProcessedEntityDto dto)
    {
        var entityToSave = dto.Entity!
            .Where(p => p.Key != StringConstants.PathPropertyName && p.Key != StringConstants.MainIdPropertyName)
            .ToDictionary(p => p.Key, p => p.Value);

        var navProps = dto.Edmx!.NavigationProperties.Where(p => p.IsCollection == false).ToList();

        foreach (var prop in entityToSave)
        {
            if (navProps.Any(p => p.Name == prop.Key)) // убедились, что свойство является навигационным
            {
                var relatedEntity = await GetRelatedEntity(prop, dto); // получили связанную сущность
                entityToSave[prop.Key] = relatedEntity;
            }
        }

        return entityToSave;
    }

    /// <summary>
    /// Получает связанную сущность по ключу
    /// </summary>
    /// <param name="prop">Имя связанной сущности и его ключ</param>
    /// <param name="dto">Dto сущности</param>
    /// <returns>связанная сущность, готовая для вставки в Odata</returns>
    /// <exception cref="Exception"></exception>
    private async Task<object> GetRelatedEntity(KeyValuePair<string, object> prop, ProcessedEntityDto dto)
    {
        try
        {
            var searchCryteriaFound = dto.SearchCriterias!.TryGetValue(prop.Key, out var searchCryteria);

            if (searchCryteriaFound)
            {
                var relatedEntity = await _odataClientService.GetEntityAsync(prop.Key, searchCryteria!, prop.Value);
                if (relatedEntity != null)
                {
                    return relatedEntity;
                }
                else
                {
                    throw new Exception("Не найдена связанная сущность " + prop.Key + " по ключу " + searchCryteria + ": " + prop.Value);
                }
            }
            else
            {
                throw new ArgumentException("Не указан ключ поиска для связанной сущности " + prop.Key);
            }
        }
        catch (Exception ex)
        {
            throw new Exception("Ошибка при поиске связанной сущности " + prop.Key + ": " + ex.Message);
        }
    }

    /// <summary>
    /// Вставляет сущность в OData
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    private async Task<IDictionary<string, object>?> InstertEntityAsync(ProcessedEntityDto dto)
    {
        var entityToSave = await FindRelatedEntitiesAsync(dto);

        if (entityToSave != null)
        {
            var savedEntity = await _odataClientService.InsertEntityAsync(entityToSave, dto.Edmx!.Name!);
            return savedEntity;

        }
        else
        {
            throw new ArgumentException("Связанные сущности не найдены");
        }
    }

    /// <summary>
    /// Обновляет сущность в OData
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    private async Task<IDictionary<string, object>?> UpdateEntryAsync(ProcessedEntityDto dto)
    {
        var entityToSave = await FindRelatedEntitiesAsync(dto);
        var key = entityToSave!.TryGetValue(StringConstants.MainIdPropertyName, out var id) ? (long)id : 0;

        if (key == 0)
        {
            throw new ArgumentException("Не удалось найти Id сущности");
        }

        if (entityToSave != null)
        {
            var savedEntity = await _odataClientService.UpdateEntityAsync(entityToSave, dto.Edmx!.Name!, key);
            return savedEntity;
        }
        else
        {
            throw new ArgumentException("Связанные сущности не найдены");
        }
    }

    /// <summary>
    /// Получает список свойств сущности в зависимости от ее структуры в Odata
    /// </summary>
    /// <param name="dto">DTO сущности</param>
    public List<EntityFieldDto> GetEntityFields(EdmxEntityDto? dto)
    {
        if(dto == null)
        {
            return new();
        }
        
        var structuralProperties = dto.StructuralProperties
            .Select(p => new StructuralFieldDto
            {
                Name = p.Name?.ToString() ?? "",
                Type = p.Type?.ToString() ?? "Неизвестно",
                Nullable = p.Nullable
            })
            .ToList();

        var navigationProperties = dto.NavigationProperties
            .Select(p => new NavigationPropertyDto
            {
                Name = p.Name?.ToString() ?? "",
                Type = p.Type?.ToString() ?? "Неизвестно",
                Nullable = p.Nullable
            })
            .ToList();

        // Заполняем поля сущности
        return structuralProperties
            .Concat<EntityFieldDto>(navigationProperties)
            .ToList();
    }
    
    /// <summary>
    /// Строит сущность из строки Excel на основе маппинга и данных строки
    /// </summary>
    /// <param name="mapping">Маппинг столбцов Excel на свойства сущности</param>
    /// <param name="row">Данные строки Excel</param>
    /// <param name="searchBy">Критерий поиска для навигационных свойств</param>
    /// <returns>Построенная сущность в виде словаря</returns>
    /// <exception cref="Exception">Выбрасывается, если не удалось конвертировать значение или найти связанную сущность</exception>
    public async Task<IDictionary<string, object?>> BuildEntityFromRow(Dictionary<string, EntityFieldDto?> mapping, IDictionary<string, string> row, SearchEntityBy searchBy)
    {
        var buildedEntity = new Dictionary<string, object?>();
        
        foreach (var kvp in mapping)
        {
            var excelColumn = kvp.Key;
            var entityField = kvp.Value;
            
            if (entityField == null)
            {
                continue;
            }

            if (!row.TryGetValue(excelColumn, out var cellValue))
            {
                continue;
            }

            if (string.IsNullOrWhiteSpace(cellValue))
            {
                continue;
            }

            if (entityField is StructuralFieldDto structural)
            {
                if (structural.Type == null || structural.Name == null)
                {
                    continue;
                }
                
                var convertedValue = EdmTypeHelper.ConvertEdmValue(cellValue, structural.Type);

                buildedEntity[structural.Name] = convertedValue ?? throw new Exception($"Не удалось конвертировать значение {cellValue} в тип {structural.Type} для свойства {structural.Name}");
            }
            else if (entityField is NavigationPropertyDto navigation)
            {
                if(navigation.IsCollection || navigation.Type == null || navigation.Name == null)
                {
                    continue;
                }
                
                var relatedEntity = await _odataClientService.GetEntityAsync(navigation.Type, searchBy.ToString(), cellValue);
                
                if (relatedEntity.Any())
                {
                    buildedEntity[navigation.Name] = relatedEntity;
                }
                else
                {
                    throw new Exception($"Не найдена связанная сущность {navigation.Name} по ключу {searchBy}: {cellValue}");
                }
            }
        }
        

        return buildedEntity;
    }
    

}
