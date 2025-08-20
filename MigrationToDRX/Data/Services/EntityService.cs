using System;
using System.Globalization;
using ClosedXML.Excel;
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

    public async Task<Dictionary<string, object>> CreateEntityAsync(IDictionary<string, object> excelRow, Dictionary<string, string> columnMapping, EdmxEntityDto entitydto)
    {
        var structuralMap = entitydto.StructuralProperties
        .ToDictionary(p => p.Name!, p => p);

        var navigationMap = entitydto.NavigationProperties
            .ToDictionary(p => p.Name!, p => p);

        var result = new Dictionary<string, object>();

        foreach (var excelCol in columnMapping.Keys)
        {
            var value = excelRow.TryGetValue(excelCol, out var val) ? val : null;
            var entityProp = columnMapping[excelCol];

            if (string.IsNullOrWhiteSpace(entityProp))
                continue;

            if (structuralMap.TryGetValue(entityProp, out var structProp))
            {
                if (structProp.Name == "Status" && EdmTypeHelper.StatusValues.TryGetValue(value?.ToString()!, out var status))
                {
                    result[structProp.Name!] = status;
                }
                else
                {
                    result[structProp.Name!] = ConvertToODataType(value, structProp.Type)!;
                }
            }
            else if (navigationMap.TryGetValue(entityProp, out var navProp) && !navProp.IsCollection)
            {
                if (entityProp == "MainId")
                {
                    result["MainId"] = value!;
                    continue;
                }

                if (EdmTypeHelper.SearchByName)
                {
                    var relatedEntity = await _odataClientService.GetEntityAsync(navProp.Type!, EdmTypeHelper.SearchCryteria, value!);
                    result[navProp.Name!] = relatedEntity;
                }
                else
                {
                    if (int.TryParse(value?.ToString(), out int id))
                    {
                        var relatedEntity = await _odataClientService.GetEntityAsync(navProp.Type!, id);
                        result[navProp.Name!] = relatedEntity;
                    }
                }
            }
        }

        return result;
    }

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
            "Edm.DateTimeOffset" => DateTimeOffset.Parse(value.ToString() ?? string.Empty, new CultureInfo("ru-RU")),
            "Edm.Double" => double.TryParse(value.ToString(), out var d) ? d : null,
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
    public async Task<SaveEntityResult> ProceedEntitiesToOdata(IDictionary<string, object> entity, string entitySet, OdataScenario scenario)
    {
        return scenario switch
        {
            OdataScenario.CreateEntity => await CreateEntityAsync(entity, entitySet),
            OdataScenario.UpdateEntity => await UpdateEntityAsync(entity, entitySet),
            OdataScenario.CreateDocumentWithVersion => await CreateDocumentWithVersionAsync(entity, entitySet),
            OdataScenario.AddVersionToExistedDocument => await AddVersionToExistedDocumentAsync(entity, entitySet),
            OdataScenario.AddEntityToCollection => await AddEntityToCollectionAsync(entity, entitySet),
            OdataScenario.UpdateEntityInCollection => await UpdateEntityInCollectionAsync(entity, entitySet),
            _ => throw new ArgumentException("Не удалось обработать сценарий")
        };
    }

    private async Task<SaveEntityResult> UpdateEntityInCollectionAsync(IDictionary<string, object> entity, string entitySet)
    {
        throw new NotImplementedException();
    }


    private async Task<SaveEntityResult> AddEntityToCollectionAsync(IDictionary<string, object> entity, string entitySet)
    {
        throw new NotImplementedException();
    }


    private async Task<SaveEntityResult> AddVersionToExistedDocumentAsync(IDictionary<string, object> entity, string entitySet)
    {
        throw new NotImplementedException();
    }


    private async Task<SaveEntityResult> UpdateEntityAsync(IDictionary<string, object> entity, string entitySet)
    {
        var eDocId = entity.TryGetValue(StringConstants.MainIdPropertyName, out var id) ? (int)id : 0;

        if (eDocId == 0)
        {
            return new SaveEntityResult()
            {
                Success = false,
                Error = "Не удалось найти Id документа"
            };
        }

        var filePath = entity.TryGetValue(StringConstants.PathPropertyName, out var path) ? (string)path : "";

        if (filePath != null && _fileService.IsFileExists(filePath) && _fileService.IsLessThenTwoGb(filePath))
        {
            await SetBody(eDocId, filePath);
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
    public async Task<SaveEntityResult> CreateEntityAsync(IDictionary<string, object> entity, string entitySet)
    {
        var result = new SaveEntityResult();
        try
        {
            var entityToSave = entity
                .Where(p => p.Key != StringConstants.PathPropertyName && p.Key != StringConstants.MainIdPropertyName)
                .ToDictionary(p => p.Key, p => p.Value);

            var savedEntity = await _odataClientService.InsertEntityAsync(entityToSave, entitySet);
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

    public async Task<SaveEntityResult> CreateDocumentWithVersionAsync(IDictionary<string, object> entity, string entitySet)
    {
        try
        {
            var entityToSave = entity
                .Where(p => p.Key != StringConstants.PathPropertyName && p.Key != StringConstants.MainIdPropertyName)
                .ToDictionary(p => p.Key, p => p.Value);

            var savedEntity = await _odataClientService.InsertEntityAsync(entityToSave, entitySet);

            if (savedEntity != null && savedEntity.TryGetValue("Id", out var id))
            {
                var filePath = entity.TryGetValue(StringConstants.PathPropertyName, out var path) 
                    ? path?.ToString() ?? "" 
                    : "";


                if (string.IsNullOrWhiteSpace(filePath) == false && _fileService.IsFileExists(filePath) && _fileService.IsLessThenTwoGb(filePath))
                {
                    var eDocId = Convert.ToInt32(id);
                    await SetBody(eDocId, filePath);
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
    /// Создть тело документа
    /// </summary>
    /// <param name="eDoc"></param>
    /// <param name="filePath"></param>
    /// <param name="ForceUpdateBody"></param>
    /// <returns></returns>
    public async Task SetBody(int eDocId, string filePath, bool ForceUpdateBody = false)
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

        var docId = Convert.ToInt32(docIdObj);

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


    private bool NeedNewVersion(string extension, IDictionary<string, object> version)
    {

        if (!version.TryGetValue("AssociatedApplication", out var application))
        { return true; }

        if (application is IDictionary<string, object> currentApp && currentApp.TryGetValue("Extension", out var currentExtension))
        { return currentExtension.ToString() != extension; }

        return true;

    }

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

}
