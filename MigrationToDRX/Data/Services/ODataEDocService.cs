using System;
using Microsoft.Extensions.Logging;
using NLog;
using Simple.OData.Client;

namespace MigrationToDRX.Data.Services;

/// <summary>
/// Сервис для работы с электронными документами
/// </summary>
public class ODataEDocService
{
    private readonly ODataClient _client;
    private readonly OdataClientService _service;
    private readonly Logger logger = LogManager.GetCurrentClassLogger();

    /// <summary>
    /// Конструктор
    /// </summary>
    /// <param name="client"></param>
    public ODataEDocService(OdataClientService service)
    {
        _service = service;
        _client = _service.GetClient();
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
