using System.Text.RegularExpressions;
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

    /// <summary>
    /// Сервис для создания сущностей
    /// </summary>
    private readonly EntityBuilderService _entityBuilderService;


    public EntityService(OdataClientService odataClientService, FileService fileService, EntityBuilderService entityBuilderService)
    {
        _odataClientService = odataClientService;
        _fileService = fileService;
        _entityBuilderService = entityBuilderService;
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
    /// Обработка сценария работы с сущностями
    /// </summary>
    /// <param name="entity">Сущность для создания\обновления</param>
    /// <param name="entitySet">Коллекция сущностей</param>
    /// <param name="scenario">Сценарий работы</param>
    /// <returns>Результат выполнения</returns>
    /// <exception cref="ArgumentException"></exception>
    public async Task<OperationResult> ProceedEntitiesToOdata(ProcessedEntityDto dto)
    {
        return dto.Operation switch
        {
            OdataOperation.CreateEntity => await CreateEntityAsync(dto),
            OdataOperation.UpdateEntity => await UpdateEntityAsync(dto),
            OdataOperation.CreateDocumentWithVersion => await CreateDocumentWithVersionAsync(dto),
            OdataOperation.AddVersionToExistedDocument => await AddVersionToExistedDocumentAsync(dto),
            OdataOperation.AddEntityToCollection => await AddEntityToCollectionAsync(dto),
            OdataOperation.UpdateEntityInCollection => await UpdateEntityInCollectionAsync(dto),
            _ => throw new ArgumentException("Не удалось обработать сценарий")
        };
    }

    /// <summary>
    /// Проверяет сущность на основе Excel файла
    /// </summary>
    public async Task<ValidationResult> ValidateEntity(ProcessedEntityDto dto)
    {
        try
        {
            var entity = await BuildEntityFromRow(dto);

            if (entity != null)
            {
                return new ValidationResult(true, null);
            }
            else
            {
                return new ValidationResult(false, "Не удалось проверить сущность");
            }
        }
        catch (Exception ex)
        {
            return new ValidationResult(false, ex.Message + " :" + ex.InnerException?.Message);
        }
    }

    /// <summary>
    /// Строит сущность из строки Excel на основе маппинга и данных строки
    /// </summary>
    public async Task<IDictionary<string, object>> BuildEntityFromRow(ProcessedEntityDto dto)
    {
        return await _entityBuilderService.BuildEntityFromRow(dto);
    }

    /// <summary>
    /// Создает сущность в OData и возвращает результат выполнения операции
    /// </summary>
    private async Task<OperationResult> CreateEntityAsync(ProcessedEntityDto dto)
    {
        try
        {
            var entity = await BuildEntityFromRow(dto);

            var entityToSave = entity
                .Where(p => p.Key != StringConstants.PathPropertyName
                    && p.Key != StringConstants.MainIdPropertyName
                    && p.Key != StringConstants.IdPropertyName)
                .ToDictionary(p => p.Key, p => p.Value);

            var savedEntity = await _odataClientService.InsertEntityAsync(entityToSave, dto.EntitySetName);

            if (savedEntity != null)
            {
                var newId = savedEntity.TryGetValue(StringConstants.IdPropertyName, out var id) ? (long)id : 0;

                if (newId == 0)
                {
                    return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать сущность");
                }
                else
                {
                    return new OperationResult(sucsess: true, operationName: dto.Operation.GetDisplayName(), entityId: newId, entity: savedEntity);
                }
            }

            return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать сущность");
        }
        catch (Exception ex)
        {
            return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Обновляет сущность в OData и возвращает результат выполнения операции
    /// </summary>
    private async Task<OperationResult> UpdateEntityAsync(ProcessedEntityDto dto)
    {
        try
        {
            var entity = await BuildEntityFromRow(dto);

            var entityToSave = entity
                    .Where(p => p.Key != StringConstants.PathPropertyName
                        && p.Key != StringConstants.MainIdPropertyName && p.Key != StringConstants.IdPropertyName)
                    .ToDictionary(p => p.Key, p => p.Value);

            var entityId = entity.TryGetValue(StringConstants.IdPropertyName, out var id) ? (long)id : 0;

            if (entityId == 0)
            {
                throw new Exception($"Не удалось найти Id сущности {dto.EntitySetName}");
            }

            var mainEntity = _odataClientService.GetEntityAsync(dto.EntitySetName, entityId);

            if (mainEntity == null)
            {
                throw new Exception($"Не удалось найти сущность {dto.EntitySetName} по Id {entityId}");
            }

            var updatedEntity = await _odataClientService.UpdateEntityAsync(entityToSave, dto.EntitySetName, entityId);

            if (updatedEntity != null)
            {
                return new OperationResult(sucsess: true, operationName: dto.Operation.GetDisplayName(), entityId: entityId, entity: updatedEntity);
            }
            else
            {
                return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось обновить сущность");
            }
        }
        catch (Exception ex)
        {
            return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }

    }

    /// <summary>
    /// Создает документ c телом в OData и возвращает результат выполнения операции
    /// </summary>
    private async Task<OperationResult> CreateDocumentWithVersionAsync(ProcessedEntityDto dto)
    {
        try
        {
            // перед созданем документа убедимся, что файл найден и не слишком большой
            var filePath = dto.Row!.TryGetValue(StringConstants.PathPropertyName, out var path)
                ? path?.ToString() ?? ""
                : "";

            bool fileIsFound = string.IsNullOrWhiteSpace(filePath) == false && _fileService.IsFileExists(filePath) && _fileService.IsLessThenTwoGb(filePath);

            if (fileIsFound == false)
            {
                return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Файл не найден или слишком большой");
            }

            // создаем сущность
            var createResult = await CreateEntityAsync(dto);

            if (createResult.Success == false)
            {
                return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать документ");
            }

            var savedEntity = createResult.Entity;

            if (createResult.Success && savedEntity != null && savedEntity.TryGetValue(StringConstants.IdPropertyName, out var id))
            {
                var eDocId = Convert.ToInt64(id);

                // находим созданную сущность и заполняем тело документа
                await FindEdocAndSetBodyAsync(eDocId, filePath);
                return new OperationResult(sucsess: true, operationName: dto.Operation.GetDisplayName());
            }
            else
            {
                return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать документ");
            }
        }
        catch (Exception ex)
        {
            return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }

    }

    /// <summary>
    /// Добавляет версию документа в OData и возвращает результат выполнения операции
    /// </summary>
    private async Task<OperationResult> AddVersionToExistedDocumentAsync(ProcessedEntityDto dto)
    {
        // перед созданем документа убедимся, что файл найден и не слишком большой
        var filePath = dto.Row.TryGetValue(StringConstants.PathPropertyName, out var path)
            ? path?.ToString() ?? ""
            : "";

        bool fileIsFound = string.IsNullOrWhiteSpace(filePath) == false && _fileService.IsFileExists(filePath) && _fileService.IsLessThenTwoGb(filePath);

        if (fileIsFound == false)
        {
            return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Файл не найден или слишком большой");
        }

        if (dto.Row.TryGetValue(StringConstants.IdPropertyName, out var id))
        {
            // находим сущность и заполняем тело документа
            var eDocId = Convert.ToInt64(id);
            await FindEdocAndSetBodyAsync(eDocId, filePath);
            return new OperationResult(sucsess: true, operationName: dto.Operation.GetDisplayName());
        }
        else
        {
            return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать документ");
        }
    }

    /// <summary>
    /// Создает свойство - коллекцию в Odata
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    /// <exception cref="ArgumentException"></exception>
    private async Task<OperationResult> AddEntityToCollectionAsync(ProcessedEntityDto dto)
    {
        try
        {
            if (dto.ChildEntitySetName == null)
            {
                throw new ArgumentException("Не указан тип свойства - коллекции");
            }

            var entity = await BuildEntityFromRow(dto);

            var entityToSave = entity
                .Where(p => p.Key != StringConstants.PathPropertyName
                    && p.Key != StringConstants.MainIdPropertyName
                    && p.Key != StringConstants.IdPropertyName)
                .ToDictionary(p => p.Key, p => p.Value);

            var mainId = entity.TryGetValue(StringConstants.MainIdPropertyName, out var id) ? (long)id : 0;

            if (mainId == 0)
            {
                throw new Exception($"Не удалось найти Id главной сущности {dto.EntitySetName}");
            }

            var savedEntity = await _odataClientService.InsertChildEntityAsync(entityToSave, mainId, dto.EntitySetName, dto.ChildEntitySetName!);

            if (savedEntity != null)
            {
                var newId = savedEntity.TryGetValue(StringConstants.IdPropertyName, out var childId) ? (long)childId : 0;

                if (newId == 0)
                {
                    return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать сущность");
                }
                else
                {
                    return new OperationResult(sucsess: true, operationName: dto.Operation.GetDisplayName(), entityId: newId, entity: savedEntity);
                }
            }

            return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать сущность");
        }
        catch (Exception ex)
        {
            return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Обновляет свойство - коллекцию в Odata
    /// </summary>

    private async Task<OperationResult> UpdateEntityInCollectionAsync(ProcessedEntityDto dto)
    {
        try
        {
            var entity = await BuildEntityFromRow(dto);

            var entityToSave = entity
                    .Where(p => p.Key != StringConstants.PathPropertyName
                        && p.Key != StringConstants.MainIdPropertyName && p.Key != StringConstants.IdPropertyName)
                    .ToDictionary(p => p.Key, p => p.Value);

            var mainEntityId = entity.TryGetValue(StringConstants.MainIdPropertyName, out var id) ? (long)id : 0;

            if (mainEntityId == 0)
            {
                throw new Exception($"Не удалось найти Id сущности {dto.EntitySetName}");
            }

            var childEntityId = entity.TryGetValue(StringConstants.IdPropertyName, out var id2) ? (int)id2 : 0;

            if (childEntityId == 0)
            {
                throw new Exception($"Не удалось найти Id свойства-коллекции {dto.EntitySetName}");
            }

            var entityToUpdate = await _odataClientService.GetChildEntityAsync(dto.EntitySetName, mainEntityId, dto.ChildEntitySetName!, childEntityId);

            if (entityToUpdate == null)
            {
                throw new Exception($"Не удалось найти свойство-коллекцию {dto.EntitySetName} по Id {childEntityId}");
            }

            var updatedEntity = await _odataClientService.UpdateChildEntityAsync(entityToSave, dto.EntitySetName, mainEntityId, dto.ChildEntitySetName!);

            if (updatedEntity != null)
            {
                return new OperationResult(sucsess: true, operationName: dto.Operation.GetDisplayName(), entityId: childEntityId, entity: updatedEntity);
            }

            return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось обновить свойство-коллекцию");

        }
        catch (Exception ex)
        {
            return new OperationResult(sucsess: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Получает список свойств сущности в зависимости от ее структуры в Odata
    /// </summary>
    /// <param name="dto">DTO сущности</param>
    public List<EntityFieldDto> GetEntityFields(EdmxEntityDto? dto)
    {
        if (dto == null)
        {
            return new();
        }

        var structuralProperties = dto.StructuralProperties
            .Select(p => new StructuralFieldDto
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

    #region Служебные приватные методы

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

        byte[] body;
        try
        {
            body = await ReadFileEvenIfOpenAsync(filePath);

            if (body.Length == 0)
            {
                body = await File.ReadAllBytesAsync(filePath);
            }
        }
        catch (Exception ex)
        {
            throw new Exception($"Не удалось прочитать файл: {ex.Message}");
        }



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
    /// Читает файл даже если он открыт
    /// </summary>
    private byte[] ReadFileEvenIfOpen(string path)
    {
        using var stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
        byte[] buffer = new byte[stream.Length];
        stream.Read(buffer, 0, buffer.Length);
        return buffer;
    }
    
    /// <summary>
    /// Читает файл даже если он открыт
    /// </summary>
    public async Task<byte[]> ReadFileEvenIfOpenAsync(string path, CancellationToken cancellationToken = default)
    {
        using var stream = new FileStream(
            path,
            FileMode.Open,
            FileAccess.Read,
            FileShare.ReadWrite,
            bufferSize: 81920,  // стандартный буфер .NET
            useAsync: true       // важно для асинхронного чтения
        );

        var buffer = new byte[stream.Length];
        int offset = 0;

        while (offset < buffer.Length)
        {
            int bytesRead = await stream.ReadAsync(buffer.AsMemory(offset, buffer.Length - offset), cancellationToken);
            if (bytesRead == 0) break; // конец файла
            offset += bytesRead;
        }

        return buffer;
    }

    #endregion
}
