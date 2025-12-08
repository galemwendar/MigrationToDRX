using System;
using Microsoft.Extensions.Logging;
using MigrationToDRX.Data.Constants;
using NLog;
using Simple.OData.Client;

namespace MigrationToDRX.Data.Services;

/// <summary>
/// Сервис для работы с электронными документами
/// </summary>
public class ODataEDocService
{
    private readonly OdataClientService _odataClientService;
    private readonly FileService _fileService;
    private readonly ODataClient _client;
    private readonly Logger logger = LogManager.GetCurrentClassLogger();
    

    /// <summary>
    /// Конструктор
    /// </summary>
    /// <param name="client"></param>
    public ODataEDocService(OdataClientService odataClientService, FileService fileService)
    {
        _odataClientService = odataClientService;
        _fileService = fileService;
        _client = _odataClientService.GetClient();
    }

    /// <summary>
    /// Создать тело документа
    /// </summary>
    public async Task<IDictionary<string, object>?> FindEdocAndSetBodyAsync(long eDocId, string filePath, CancellationToken ct, bool ForceUpdateBody = false)
    {
        ct.ThrowIfCancellationRequested();

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
    /// Получить электронный документ по идентификатору
    /// </summary>
    /// <param name="eDocId">Идентификатор электронного документа</param>
    /// <returns>Коллекция свойств электронного документа</returns>
    public async Task<IDictionary<string, object>> FindEdocAsync(long eDocId, CancellationToken? ct)
    {
        ct?.ThrowIfCancellationRequested();

        logger.Trace("FindEdocAsync");
        return await _client
            .For("IElectronicDocuments")
            .Key(eDocId)
            .Expand("Versions($expand=AssociatedApplication,Body)")
            .FindEntryAsync();
    }

    /// <summary>
    /// Получить связанное приложение по расширению файла
    /// </summary>
    /// <param name="extension">Расширение файла</param>
    /// <returns>Коллекция свойств приложения</returns>
    public async Task<IDictionary<string, object>?> FindAssociatedApplication(string extension, CancellationToken? ct)
    {
        ct?.ThrowIfCancellationRequested();

        try
        {
            return await _client.For("IAssociatedApplications").Filter($@"Extension eq '{extension}'").FindEntryAsync();
        }
        catch (Exception ex) { logger.Error(ex); return null; }
    }

    /// <summary>
    /// Создать новую версию документа
    /// </summary>
    /// <param name="eDocId">Идентификатор документа</param>
    /// <param name="note">Описание версии</param>
    /// <param name="associatedApp">связанное приложение по расширению файла</param>
    /// <returns>Коллекция свойств версии документа</returns>
    public async Task<IDictionary<string, object>?> CreateNewVersion(long eDocId, string note, IDictionary<string, object> associatedApp, CancellationToken? ct)
    {
        ct?.ThrowIfCancellationRequested();

        try
        {
            return await _client.For("IElectronicDocuments")
                .Key(eDocId)
                .NavigateTo("Versions")
                .Set(new
                {
                    Note = note,
                    Created = DateTime.Now,
                    AssociatedApplication = associatedApp
                })
                .InsertEntryAsync();
        }
        catch (Exception ex)
        {
            logger.Error(ex);
            return null;
        }

    }

    /// <summary>
    /// Заполнить тело документа
    /// </summary>
    /// <param name="eDocId">идентификатор документа</param>
    /// <param name="body">тело документа</param>
    /// <param name="lastVersion">последняя версия документа</param>
    public async Task FillBodyAsync(long eDocId, byte[] body, IDictionary<string, object> lastVersion, CancellationToken? ct)
    {
        ct?.ThrowIfCancellationRequested();

        try
        {
            lastVersion.TryGetValue("Id", out var lastVersionKey);
            if (long.TryParse(lastVersionKey?.ToString(), out long lastVersionId))
            {
                var eDocBody = await _client.For("IElectronicDocuments")
                    .Key(eDocId)
                        .NavigateTo("Versions")
                    .Key(lastVersionId)
                        .NavigateTo("Body")
                    .Set(new { Value = body, })
                    .InsertEntryAsync();
            }
            else
            {
                throw new InvalidOperationException("Не удалось получить идентификатор последней версии документа");
            }
        }
        catch (Exception ex)
        {
            logger.Error(ex);
            return;
        }
    }
}
