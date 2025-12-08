using System;
using MigrationToDRX.Data.Constants;
using MigrationToDRX.Data.Enums;
using MigrationToDRX.Data.Helpers;
using MigrationToDRX.Data.Models.Dto;

namespace MigrationToDRX.Data.Services;

public class OperationService
{
    private readonly ActionService _actionService;

    private readonly EntityService _entityService;

    private readonly OdataClientService _odataClientService;

    private readonly ODataEDocService _odataEdocService;

    public OperationService(ActionService actionService, EntityService entityService, OdataClientService odataClientService, ODataEDocService odataEdocService)
    {
        _actionService = actionService;
        _entityService = entityService;
        _odataClientService = odataClientService;
        _odataEdocService = odataEdocService;
    }

    /// <summary>
    /// Обработка сценария работы с сущностями
    /// </summary>
    /// <returns>Результат выполнения</returns>
    /// <exception cref="ArgumentException"></exception>
    public async Task<OperationResult> ExecuteOperation(ProcessedEntityDto dto, CancellationToken ct)
    {
        ct.ThrowIfCancellationRequested();
        return dto.Operation switch
        {
            OdataOperation.CreateEntity => await CreateEntityAsync(dto, ct),
            OdataOperation.UpdateEntity => await UpdateEntityAsync(dto, ct),
            OdataOperation.CreateDocumentWithVersion => await CreateDocumentWithVersionAsync(dto, ct),
            OdataOperation.AddVersionToExistedDocument => await AddVersionToExistedDocumentAsync(dto, ct),
            OdataOperation.AddEntityToCollection => await AddEntityToCollectionAsync(dto, ct),
            OdataOperation.UpdateEntityInCollection => await UpdateEntityInCollectionAsync(dto, ct),
            OdataOperation.GrantAccessRightsToDocument => await GrantAccessRightsToDocumentAsync(dto, ct),
            OdataOperation.GrantAccessRightsToFolder => await GrantAccessRightsToFolderAsync(dto, ct),
            OdataOperation.AddDocumentToFolder => await AddDocumentToFolderAsync(dto, ct),
            OdataOperation.StartTask => await StartTaskAsync(dto, ct),
            OdataOperation.CompleteAssignment => await CompleteAssignmentAsync(dto, ct),
            OdataOperation.ImportSignatureToDocument => await ImportSignatureToDocumentAsync(dto, ct),
            OdataOperation.CreateChildFolder => await CreateChildFolderAsync(dto, ct),
            OdataOperation.AddChildFolder => await AddChildFolderAsync(dto, ct),
            OdataOperation.CreateVersionFromTemplate => await CreateVersionFromTemplateAsync(dto, ct),
            OdataOperation.AddRelations => await AddRelationsAsync(dto, ct),
            OdataOperation.RenameVersionNote => await RenameVersionNoteAsync(dto, ct),
            OdataOperation.ImportCertificate => await ImportCertificateAsync(dto, ct),

            _ => throw new ArgumentException("Не удалось обработать сценарий")
        };
    }

    /// <summary>
    /// Создает сущность в OData и возвращает результат выполнения операции
    /// </summary>
    private async Task<OperationResult> CreateEntityAsync(ProcessedEntityDto dto, CancellationToken ct)
    {
        try
        {
            var entity = await _entityService.BuildEntity(dto, ct);
            var entityToSave = EntityHelper.FilterServiceFields(entity);

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
    private async Task<OperationResult> UpdateEntityAsync(ProcessedEntityDto dto, CancellationToken ct)
    {
        try
        {
            var entity = await _entityService.BuildEntity(dto, ct);
            var entityToSave = EntityHelper.FilterServiceFields(entity);

            var entityId = EntityHelper.GetFieldValueFromEntityDto(dto, OdataPropertyNames.MainId);

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
    private async Task<OperationResult> CreateDocumentWithVersionAsync(ProcessedEntityDto dto, CancellationToken ct)
    {
        try
        {
            // ищем excel-ключ для PathPropertyName
            string filePath = EntityHelper.GetFilePathFromEntityDto(dto);

            if (_entityService.ValidateFilePath(filePath) == false)
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
                var updatedEntity = await _odataEdocService.FindEdocAndSetBodyAsync(eDocId, filePath, ct);
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
    private async Task<OperationResult> AddVersionToExistedDocumentAsync(ProcessedEntityDto dto, CancellationToken ct)
    {
        // перед созданем документа убедимся, что файл найден и не слишком большой
        var filePath = EntityHelper.GetFilePathFromEntityDto(dto);


        if (_entityService.ValidateFilePath(filePath) == false)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Файл не найден или слишком большой");
        }
        // находим сущность и заполняем тело документа
        var eDocId = EntityHelper.GetFieldValueFromEntityDto(dto, OdataPropertyNames.MainId);

        if (eDocId == 0)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: "Не удалось найти Id сущности");
        }

        var updatedEntity = await _odataEdocService.FindEdocAndSetBodyAsync(eDocId, filePath, ct);

        return new OperationResult(success: true, operationName: dto.Operation.GetDisplayName(), entityId: eDocId, entity: updatedEntity);
    }

    /// <summary>
    /// Создает свойство - коллекцию в Odata
    /// </summary>
    /// <exception cref="ArgumentException"></exception>
    private async Task<OperationResult> AddEntityToCollectionAsync(ProcessedEntityDto dto, CancellationToken ct)
    {
        try
        {
            if (dto.ChildEntitySetName == null)
            {
                throw new ArgumentException("Не указан тип свойства - коллекции");
            }

            var entity = await _entityService.BuildEntity(dto, ct);
            var entityToSave = EntityHelper.FilterServiceFields(entity);

            var mainId = EntityHelper.GetFieldValueFromEntityDto(dto, OdataPropertyNames.MainId);

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
    private async Task<OperationResult> UpdateEntityInCollectionAsync(ProcessedEntityDto dto, CancellationToken ct)
    {
        try
        {
            var entity = await _entityService.BuildEntity(dto, ct);
            var entityToSave = EntityHelper.FilterServiceFields(entity);

            var mainEntityId = EntityHelper.GetFieldValueFromEntityDto(dto, OdataPropertyNames.MainId);

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
    /// Переименовать примечание версии документа.
    /// </summary>
    private async Task<OperationResult> RenameVersionNoteAsync(ProcessedEntityDto dto, CancellationToken ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.ExcelMigrator, OdataActionNames.RenameVersionNoteAction, dto, ct);

    /// <summary>
    /// Выдать права на папку
    /// </summary>
    private async Task<OperationResult> GrantAccessRightsToFolderAsync(ProcessedEntityDto dto, CancellationToken ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.GrantAccessRightsToFolderAction, dto, ct);

    /// <summary>
    /// Стартовать задачу
    /// </summary>
    private async Task<OperationResult> StartTaskAsync(ProcessedEntityDto dto, CancellationToken ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.StartTaskAction, dto, ct);

    /// <summary>
    /// Выдать права на документ
    /// </summary>
    private async Task<OperationResult> GrantAccessRightsToDocumentAsync(ProcessedEntityDto dto, CancellationToken ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.GrantAccessRightsToDocumentAction, dto, ct);

    /// <summary>
    /// Добавить документ в папку
    /// </summary>
    private async Task<OperationResult> AddDocumentToFolderAsync(ProcessedEntityDto dto, CancellationToken ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.AddDocumentToFolderAction, dto, ct);

    /// <summary>
    /// Выполнить задание
    /// </summary>
    private async Task<OperationResult> CompleteAssignmentAsync(ProcessedEntityDto dto, CancellationToken ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.CompleteAssignmentAction, dto, ct);

    /// <summary>
    /// Импортировать подпись на документ
    /// </summary>
    /// <returns></returns>
    private async Task<OperationResult> ImportSignatureToDocumentAsync(ProcessedEntityDto dto, CancellationToken ct)
    {
        try
        {
            var parametres = await _entityService.BuildEntity(dto, ct);
            parametres = await _entityService.ReplaceFileContentInEntity(dto, parametres, OdataPropertyNames.Signature, ct);
            return await _actionService.ExecuteActionAsync(OdataNameSpaces.ExcelMigrator, OdataActionNames.ImportSignatureToDocumentAction, parametres, ct);
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Создать версию из шаблона.
    /// </summary>
    private async Task<OperationResult> CreateVersionFromTemplateAsync(ProcessedEntityDto dto, CancellationToken ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.CreateVersionFromTemplateAction, dto, ct);

    /// <summary>
    /// Создать связь между документами.
    /// </summary>
    private async Task<OperationResult> AddRelationsAsync(ProcessedEntityDto dto, CancellationToken ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.AddRelationsAction, dto, ct);

    /// <summary>
    /// Создать папку в родительской папке.
    /// </summary>
    /// <param name="dto"></param>
    /// <param name="ct"></param>
    /// <returns></returns>
    private async Task<OperationResult> CreateChildFolderAsync(ProcessedEntityDto dto, CancellationToken ct)
    {
        ct.ThrowIfCancellationRequested();

        var parametres = await _entityService.BuildEntity(dto, ct);
        return await _actionService.ExecuteActionAsScalarAsync<long>(OdataNameSpaces.Docflow, OdataActionNames.CreateChildFolderAction, parametres, ct);
    }

    /// <summary>
    /// Добавить папку в родительскую папку.
    /// </summary>
    private async Task<OperationResult> AddChildFolderAsync(ProcessedEntityDto dto, CancellationToken ct)
        => await ExecuteSimpleActionAsync(OdataNameSpaces.Docflow, OdataActionNames.AddChildFolderAction, dto, ct);

    /// <summary>
    /// Импортировать сертификат пользователя
    /// </summary>
    /// <returns></returns>
    private async Task<OperationResult> ImportCertificateAsync(ProcessedEntityDto dto, CancellationToken ct)
    {
        try
        {
            var parametres = await _entityService.BuildEntity(dto, ct);
            parametres = await _entityService.ReplaceFileContentInEntity(dto, parametres, OdataPropertyNames.Certificate, ct);
            return await _actionService.ExecuteActionAsScalarAsync<long>(OdataNameSpaces.ExcelMigrator, OdataActionNames.ImportCertificateAction, parametres, ct);
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }

    /// <summary> 
    /// Выполнить действие на сервере, если действие существует (IsBound = true) и возвращает void
    /// </summary>
    /// <param name="moduleName">Имя модуля</param>
    /// <param name="actionName">Имя действия</param>
    /// <param name="parametres">Параметры действия</param>
    private async Task<OperationResult> ExecuteSimpleActionAsync(string moduleName,
        string actionName,
        ProcessedEntityDto dto,
        CancellationToken ct)
    {
        try
        {
            var parametres = await _entityService.BuildEntity(dto, ct);
            return await _actionService.ExecuteActionAsync(moduleName, actionName, parametres, ct);
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: dto.Operation.GetDisplayName(), errorMessage: ex.Message);
        }
    }
}