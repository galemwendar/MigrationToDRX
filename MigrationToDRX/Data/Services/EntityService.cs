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

    public EntityService(OdataClientService odataClientService,
        FileService fileService,
        EntityBuilderService entityBuilderService)
    {
        _odataClientService = odataClientService;
        _fileService = fileService;
        _entityBuilderService = entityBuilderService;
    }

    /// <summary> 
    /// Создает сущность на основе строки Excel файла
    /// </summary>
    /// <param name="dto"></param>
    /// <returns>Готовая сущность для вставки в OData</returns>
    public async Task<IDictionary<string, object>> BuildEntity(ProcessedEntityDto dto, CancellationToken ct)
    {
        return await _entityBuilderService.BuildEntityFromRow(dto, ct);
    }

    /// <summary>
    /// Проверяет сущность на основе Excel файла
    /// </summary>
    public async Task<ValidationResult> ValidateEntity(ProcessedEntityDto dto, CancellationToken ct)
    {
        try
        {
            var entity = await BuildEntity(dto, ct);

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
    /// Проверяет путь к файлу из сущности
    /// </summary>
    public bool ValidateFilePath(string filePath)
    {
        return string.IsNullOrWhiteSpace(filePath) == false && _fileService.IsFileExists(filePath) && _fileService.IsLessThenTwoGb(filePath);

    }

    public async Task<IDictionary<string, object>> ReplaceFileContentInEntity(ProcessedEntityDto dto, IDictionary<string, object> entity, string odataProperyName, CancellationToken ct)
    {
        var pathToFile = EntityHelper.GetFilePathFromEntityDto(dto);
        var fileContent = await _fileService.GetFileAsBase64Async(pathToFile);
        
        entity.Remove(OdataPropertyNames.Path);
        entity.Add(odataProperyName, fileContent);

        return entity;
    }
}