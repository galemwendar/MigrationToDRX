using DocumentFormat.OpenXml.Spreadsheet;
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

    /// <summary>
    /// Обработка сценария работы с сущностями
    /// </summary>
    /// <returns>Результат выполнения</returns>
    /// <exception cref="ArgumentException"></exception>
    public async Task<OperationResult> ProceedEntitiesToOdata(ProcessedEntityDto dto, CancellationToken? ct)
    {
        return dto.Operation switch
        {
            OdataOperation.CreateEntity => await CreateEntityAsync(dto, isCancelled),
            OdataOperation.UpdateEntity => await UpdateEntityAsync(dto, isCancelled),
            OdataOperation.CreateDocumentWithVersion => await CreateDocumentWithVersionAsync(dto, isCancelled),
            OdataOperation.AddVersionToExistedDocument => await AddVersionToExistedDocumentAsync(dto, isCancelled),
            OdataOperation.AddEntityToCollection => await AddEntityToCollectionAsync(dto, isCancelled),
            OdataOperation.UpdateEntityInCollection => await UpdateEntityInCollectionAsync(dto, isCancelled),
            OdataOperation.GrantAccessRightsToDocument => await GrantAccessRightsToDocumentAsync(dto, isCancelled),
            OdataOperation.GrantAccessRightsToFolder => await GrantAccessRightsToFolderAsync(dto, isCancelled),
            OdataOperation.AddDocumentToFolder => await AddDocumentToFolderAsync(dto, isCancelled),
            OdataOperation.StartTask => await StartTaskAsync(dto, isCancelled),
            OdataOperation.CompleteAssignment => await CompleteAssignmentAsync(dto, isCancelled),
            OdataOperation.ImportSignatureToDocument => await ImportSignatureToDocumentAsync(dto, isCancelled),
            OdataOperation.CreateChildFolder => await CreateChildFolderAsync(dto, isCancelled),
            OdataOperation.AddChildFolder => await AddChildFolderAsync(dto, isCancelled),
            OdataOperation.CreateVersionFromTemplate => await CreateVersionFromTemplateAsync(dto, isCancelled),
            OdataOperation.AddRelations => await AddRelationsAsync(dto, isCancelled),
            OdataOperation.RenameVersionNote => await RenameVersionNoteAsync(dto, isCancelled),
            OdataOperation.ImportCertificate => await ImportCertificateAsync(dto, isCancelled),

            _ => throw new ArgumentException("Не удалось обработать сценарий")
        };
    }

    /// <summary>
    /// Проверяет сущность на основе Excel файла
    /// </summary>
    public async Task<ValidationResult> ValidateEntity(ProcessedEntityDto dto, CancellationToken? ct)
    {
        try
        {
            var entity = await _entityBuilderService.BuildEntityFromRow(dto, ct);

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
    /// Создает сущность в OData и возвращает результат выполнения операции
    /// </summary>
    private async Task<OperationResult> CreateEntityAsync(ProcessedEntityDto dto,  CancellationToken? ct)
    {
        try
        {
            var entity = await _entityBuilderService.BuildEntityFromRow(dto, ct);
            var entityToSave = FilterServiceFields(entity);

            var savedEntity = await _odataClientService.InsertEntityAsync(entityToSave, dto.EntitySetName, ct);

            if (savedEntity != null)
            {
                var newId = savedEntity.TryGetValue(OdataPropertyNames.Id, out var id) ? (long)id : 0;

                if (newId == 0)
                {
                    return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать сущность");
                }
                else
                {
                    return new OperationResult(success: true, operationName: dto.Operation.GetDisplayName(), entityId: newId, entity: savedEntity);
                }
            }

            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать сущность");
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Обновляет сущность в OData и возвращает результат выполнения операции
    /// </summary>
    private async Task<OperationResult> UpdateEntityAsync(ProcessedEntityDto dto,  CancellationToken? ct)
    {
        try
        {
            var entity = await _entityBuilderService.BuildEntityFromRow(dto, ct);
            var entityToSave = FilterServiceFields(entity);

            var entityId = GetFieldValueFromEntityDto(dto, OdataPropertyNames.MainId);

            if (entityId == 0)
            {
                throw new Exception($"Не удалось найти Id сущности {dto.EntitySetName}");
            }

            var mainEntity = _odataClientService.GetEntityAsync(dto.EntitySetName, entityId, ct);

            if (mainEntity == null)
            {
                throw new Exception($"Не удалось найти сущность {dto.EntitySetName} по Id {entityId}");
            }

            var updatedEntity = await _odataClientService.UpdateEntityAsync(entityToSave, dto.EntitySetName, entityId, ct);

            if (updatedEntity != null)
            {
                return new OperationResult(success: true, operationName: dto.Operation.GetDisplayName(), entityId: entityId, entity: updatedEntity);
            }
            else
            {
                return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось обновить сущность");
            }
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }

    }

    /// <summary>
    /// Создает документ c телом в OData и возвращает результат выполнения операции
    /// </summary>
    private async Task<OperationResult> CreateDocumentWithVersionAsync(ProcessedEntityDto dto,  CancellationToken? ct)
    {
        try
        {
            // ищем excel-ключ для PathPropertyName
            string filePath = GetFilePathFromEntityDto(dto);

            bool fileIsFound = string.IsNullOrWhiteSpace(filePath) == false && _fileService.IsFileExists(filePath) && _fileService.IsLessThenTwoGb(filePath);

            if (fileIsFound == false)
            {
                return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Файл не найден или слишком большой");
            }

            // создаем сущность
            var createResult = await CreateEntityAsync(dto, ct);

            if (createResult.Success == false)
            {
                return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать документ");
            }

            var savedEntity = createResult.Entity;

            if (createResult.Success && savedEntity != null && savedEntity.TryGetValue(OdataPropertyNames.Id, out var id))
            {
                var eDocId = Convert.ToInt64(id);

                // находим созданную сущность и заполняем тело документа
                var updatedEntity = await FindEdocAndSetBodyAsync(eDocId, filePath, ct);
                return new OperationResult(success: true, operationName: dto.Operation.GetDisplayName(), entityId: eDocId, entity: updatedEntity);
            }
            else
            {
                return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать документ");
            }
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }

    }

    /// <summary>
    /// Добавляет версию документа в OData и возвращает результат выполнения операции
    /// </summary>
    private async Task<OperationResult> AddVersionToExistedDocumentAsync(ProcessedEntityDto dto, CancellationToken? ct)
    {
        // перед созданем документа убедимся, что файл найден и не слишком большой
        var filePath = GetFilePathFromEntityDto(dto);

        bool fileIsFound = string.IsNullOrWhiteSpace(filePath) == false && _fileService.IsFileExists(filePath) && _fileService.IsLessThenTwoGb(filePath);

        if (fileIsFound == false)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Файл не найден или слишком большой");
        }
        // находим сущность и заполняем тело документа
        var eDocId = GetFieldValueFromEntityDto(dto, OdataPropertyNames.MainId);

        if(eDocId == 0)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось найти Id сущности");
        }
        
        var updatedEntity = await FindEdocAndSetBodyAsync(eDocId, filePath, ct);

        return new OperationResult(success: true, operationName: dto.Operation.GetDisplayName(), entityId: eDocId, entity: updatedEntity);
    }

    /// <summary>
    /// Создает свойство - коллекцию в Odata
    /// </summary>
    /// <exception cref="ArgumentException"></exception>
    private async Task<OperationResult> AddEntityToCollectionAsync(ProcessedEntityDto dto,  CancellationToken? ct)
    {
        try
        {
            if (dto.ChildEntitySetName == null)
            {
                throw new ArgumentException("Не указан тип свойства - коллекции");
            }

            var entity = await _entityBuilderService.BuildEntityFromRow(dto, ct);
            var entityToSave = FilterServiceFields(entity);

            var mainId = GetFieldValueFromEntityDto(dto, OdataPropertyNames.MainId);

            if (mainId == 0)
            {
                throw new Exception($"Не удалось найти Id главной сущности {dto.EntitySetName}");
            }

            var savedEntity = await _odataClientService.InsertChildEntityAsync(
                entityToSave, 
                mainId, 
                dto.EntitySetName, 
                dto.ChildEntitySetName!,
                ct);

            if (savedEntity != null)
            {
                var newId = savedEntity.TryGetValue(OdataPropertyNames.Id, out var childId) ? (long)childId : 0;

                if (newId == 0)
                {
                    return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать сущность");
                }
                else
                {
                    return new OperationResult(success: true, operationName: dto.Operation.GetDisplayName(), entityId: newId, entity: savedEntity);
                }
            }

            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось создать сущность");
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Обновляет свойство - коллекцию в Odata
    /// </summary>
    private async Task<OperationResult> UpdateEntityInCollectionAsync(ProcessedEntityDto dto,  CancellationToken? ct)
    {
        try
        {
            var entity = await _entityBuilderService.BuildEntityFromRow(dto, ct);
            var entityToSave = FilterServiceFields(entity);

            var mainEntityId = GetFieldValueFromEntityDto(dto, OdataPropertyNames.MainId);

            if (mainEntityId == 0)
            {
                throw new Exception($"Не удалось найти Id сущности {dto.EntitySetName}");
            }

            long childEntityId = 0;

            if (entity.TryGetValue(OdataPropertyNames.Id, out var id2))
            {
                childEntityId = Convert.ToInt64(id2);
            }

            if (childEntityId == 0)
            {
                throw new Exception($"Не удалось найти Id свойства-коллекции {dto.EntitySetName}");
            }

            var entityToUpdate = await _odataClientService.GetChildEntityAsync(
                dto.EntitySetName, 
                mainEntityId, 
                dto.ChildEntitySetName!, 
                childEntityId,
                ct);

            if (entityToUpdate == null)
            {
                throw new Exception($"Не удалось найти свойство-коллекцию {dto.EntitySetName} по Id {childEntityId}");
            }

            var updatedEntity = await _odataClientService.UpdateChildEntityAsync(
                entityToSave, 
                dto.EntitySetName, 
                mainEntityId, 
                dto.ChildEntitySetName!, 
                childEntityId,
                ct);

            if (updatedEntity != null)
            {
                return new OperationResult(success: true, operationName: dto.Operation.GetDisplayName(), entityId: childEntityId, entity: updatedEntity);
            }

            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось обновить свойство-коллекцию");

        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
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

    /// <summary> 
    /// Выполнить действие на сервере, если действие существует (IsBound = true)
    /// </summary>
    /// <param name="moduleName">Имя модуля</param>
    /// <param name="actionName">Имя действия</param>
    /// <param name="parametres">Параметры действия</param>
    private async Task<OperationResult> ExecuteActionAsync(string moduleName, 
        string actionName, 
        IDictionary<string, object> parametres,
        CancellationToken? ct)
    {
        try
        {
            await _odataClientService.ExecuteBoundActionAsync(moduleName, actionName, parametres, ct);

            return new OperationResult(success: true, operationName: actionName);
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: actionName, errorMessage: ex.Message);
        }
    }

    private async Task<OperationResult> ExecuteSimpleActionAsync(string moduleName, 
        string actionName, 
        ProcessedEntityDto dto, 
        CancellationToken? ct)
    {
        try
        {
            var parametres = await _entityBuilderService.BuildEntityFromRow(dto, ct);
            return await ExecuteActionAsync(moduleName, actionName, parametres, ct);
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Импортировать подпись на документ
    /// </summary>
    /// <returns></returns>
    private async Task<OperationResult> ImportSignatureToDocumentAsync(ProcessedEntityDto dto, CancellationToken? ct)
    {
        try
        {
            var parametres = await _entityBuilderService.BuildEntityFromRow(dto, ct);

            var pathToSignature = GetFilePathFromEntityDto(dto);

            var base64Signature = await _fileService.GetFileAsBase64Async(pathToSignature);


            parametres.Remove(OdataPropertyNames.Path);
            parametres.Add(OdataPropertyNames.Signature, base64Signature);
            if (string.IsNullOrWhiteSpace(pathToSignature))
            {
                throw new ArgumentException("Не указан путь к файлу с подписью");
            }


            return await ExecuteActionAsync(OdataNameSpaces.ExcelMigrator, OdataActionNames.ImportSignatureToDocumentAction, parametres);
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Импортировать сертификат пользователя
    /// </summary>
    /// <returns></returns>
    private async Task<OperationResult> ImportCertificateAsync(ProcessedEntityDto dto, Func<bool> isCancelled)
    {
        try
        {
            var parametres = await _entityBuilderService.BuildEntityFromRow(dto, isCancelled);

            var pathToCertificate = GetFilePathFromEntityDto(dto);

            var base64Certificate = await _fileService.GetFileAsBase64Async(pathToCertificate);


            parametres.Remove(OdataPropertyNames.Path);
            parametres.Add(OdataPropertyNames.Certificate, base64Certificate);
            if (string.IsNullOrWhiteSpace(pathToCertificate))
            {
                throw new ArgumentException("Не указан путь к файлу сертификата");
            }

            return await ExecuteActionAsync(OdataNameSpaces.ExcelMigrator, OdataActionNames.ImportCertificateAction, parametres);
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }


    /// <summary>
    /// Импортировать сертификат пользователя
    /// </summary>
    /// <returns></returns>
    private async Task<OperationResult> ImportCertificateAsync(ProcessedEntityDto dto, Func<bool> isCancelled)
    {
        try
        {
            var parametres = await _entityBuilderService.BuildEntityFromRow(dto, isCancelled);

            var pathToCertificate = GetFilePathFromEntityDto(dto);

            var base64Certificate = await _fileService.GetFileAsBase64Async(pathToCertificate);


            parametres.Remove(OdataPropertyNames.Path);
            parametres.Add(OdataPropertyNames.Certificate, base64Certificate);
            if (string.IsNullOrWhiteSpace(pathToCertificate))
            {
                throw new ArgumentException("Не указан путь к файлу сертификата");
            }

            return await ExecuteActionAsync(OdataNameSpaces.ExcelMigrator, OdataActionNames.ImportCertificateAction, parametres);
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Переименовать примечание версии документа.
    /// </summary>
    private async Task<OperationResult> RenameVersionNoteAsync(ProcessedEntityDto dto, CancellationToken? ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.ExcelMigrator, OdataActionNames.RenameVersionNoteAction, dto, ct);
    
    /// <summary>
    /// Выдать права на папку
    /// </summary>
    private async Task<OperationResult> GrantAccessRightsToFolderAsync(ProcessedEntityDto dto, CancellationToken? ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.GrantAccessRightsToFolderAction, dto, ct);
        
    /// <summary>
    /// Стартовать задачу
    /// </summary>
    private async Task<OperationResult> StartTaskAsync(ProcessedEntityDto dto, CancellationToken? ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.StartTaskAction, dto, ct);

    /// <summary>
    /// Выдать права на документ
    /// </summary>
    private async Task<OperationResult> GrantAccessRightsToDocumentAsync(ProcessedEntityDto dto, CancellationToken? ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.GrantAccessRightsToDocumentAction, dto, ct);

    /// <summary>
    /// Добавить документ в папку
    /// </summary>
    private async Task<OperationResult> AddDocumentToFolderAsync(ProcessedEntityDto dto, CancellationToken? ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.AddDocumentToFolderAction, dto, ct);

    /// <summary>
    /// Выполнить задание
    /// </summary>
    private async Task<OperationResult> CompleteAssignmentAsync(ProcessedEntityDto dto, CancellationToken? ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.CompleteAssignmentAction, dto, ct);

    /// <summary>
    /// Создать версию из шаблона.
    /// </summary>
    private async Task<OperationResult> CreateVersionFromTemplateAsync(ProcessedEntityDto dto, CancellationToken? ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.CreateVersionFromTemplateAction, dto, ct);

    /// <summary>
    /// Создать связь между документами.
    /// </summary>
    private async Task<OperationResult> AddRelationsAsync(ProcessedEntityDto dto, CancellationToken? ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.AddRelationsAction, dto, ct);

    /// <summary>
    /// Создать папку в родительской папке.
    /// </summary>
    /// <param name="dto"></param>
    /// <param name="ct"></param>
    /// <returns></returns>
    private async Task<OperationResult> CreateChildFolderAsync(ProcessedEntityDto dto, CancellationToken? ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.CreateChildFolderAction, dto, ct);

    /// <summary>
    /// Добавить папку в родительскую папку.
    /// </summary>
    private async Task<OperationResult> AddChildFolderAsync(ProcessedEntityDto dto, CancellationToken? ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.AddChildFolderAction, dto, ct);
    
    #region Служебные приватные методы

    /// <summary>
    /// Фильтрует служебные поля из сущности
    /// </summary>
    private static IDictionary<string, object> FilterServiceFields(IDictionary<string, object> entity)
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
    private static long GetFieldValueFromEntityDto(ProcessedEntityDto dto, string fieldName)
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
    /// Создать тело документа
    /// </summary>
    private async Task<IDictionary<string, object>?> FindEdocAndSetBodyAsync(long eDocId, string filePath, CancellationToken? ct, bool ForceUpdateBody = false)
    {
        ct?.ThrowIfCancellationRequested();

        var eDoc = await _odataClientService.FindEdocAsync(eDocId, ct);

        if (eDoc == null)
        {
            throw new ArgumentException("Не удалось найти документ");
        }

        var extension = Path.GetExtension(filePath).Replace(".", "");

        eDoc.TryGetValue(OdataPropertyNames.Id, out var docIdObj);

        if (docIdObj == null)
        {
            throw new ArgumentException("Не удалось найти Id документа");
        }

        var docId = Convert.ToInt64(docIdObj);

        var version = GetLastVersion(extension, eDoc);
        var targetApp = await _odataClientService.FindAssociatedApplication(extension, ct);

        if (targetApp == null)
        {
            return null;
        }

        if (version == null)
        {
            version = await _odataClientService.CreateNewVersion(docId, "Первоначальная версия", targetApp, ct);
        }

        else if (NeedNewVersion(extension, version) || ForceUpdateBody == true)
        {
            version = await _odataClientService.CreateNewVersion(docId, Path.GetFileName(filePath), targetApp, ct);
        }

        byte[] body;
        try
        {
            body = await _fileService.ReadFileEvenIfOpenAsync(filePath);

            if (body.Length == 0)
            {
                body = await File.ReadAllBytesAsync(filePath);
            }
        }
        catch (Exception ex)
        {
            throw new Exception($"Не удалось прочитать файл: {ex.Message}");
        }

        await _odataClientService.FillBodyAsync(docId, body, version!, ct);

        return eDoc;
    }

    /// <summary>
    /// Проверяет необходимость создания новой версии
    /// </summary>
    /// <param name="extension">расширение файла</param>
    /// <param name="version">верия</param>
    private bool NeedNewVersion(string extension, IDictionary<string, object> version)
    {
        return true;

        // Не удалять!
        //TODO: Добавить логический оператор для выбра, нужно ли перезатирать текущую версию

        // if (!version.TryGetValue(PropertyNames.AssociatedApplication, out var application))
        // { return true; }

        // if (application is IDictionary<string, object> currentApp && currentApp.TryGetValue(PropertyNames.Extension, out var currentExtension))
        // { return currentExtension.ToString() != extension; }

        // return true;

    }

    /// <summary>
    /// Получает последнюю версию документа
    /// </summary>
    /// <param name="extension">расширение файла</param>
    /// <param name="eDoc">документ</param>
    /// <returns>последняя версия</returns>
    private IDictionary<string, object>? GetLastVersion(string extension, IDictionary<string, object> eDoc)
    {
        if (eDoc.TryGetValue(OdataPropertyNames.Versions, out var versions))
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
                        Number = version[OdataPropertyNames.Number] as int? ?? 0 // Преобразование "Number" в int
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
    /// Получает путь к файлу из EntityDto
    /// </summary>
    /// <param name="dto">Построенная сущность</param>
    /// <returns>строка с путем для файла</returns>
    private static string GetFilePathFromEntityDto(ProcessedEntityDto dto)
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

    #endregion
}
