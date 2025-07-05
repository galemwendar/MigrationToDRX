using System;
using System.Text;
using ExcelToOdata.Data.Models;
using Microsoft.OData.Edm;
using NLog;
using Simple.OData.Client;

namespace ExcelToOdata.Data.Services;

public class OdataClientService
{
    private ODataClient? _client;
    private HttpResponseMessage? _response = null;
    private ODataClientSettings? _settings = null;
    private IEdmModel? _metadata = null;

    private string? _url;
    private string? _username;
    private string? _password;

    private readonly Logger logger;

    public OdataClientService()
    {
        logger = LogManager.GetCurrentClassLogger();
    }

    /// <summary>
    /// Проверяет, настроено ли соединение с OData-сервисом.
    /// </summary>
    public bool IsConnected => _metadata != null;

    /// <summary>
    /// Устанавливает соединение с OData-сервисом.
    /// </summary>
    /// <param name="url">URL OData-сервиса.</param>
    /// <param name="userName">Имя пользователя для аутентификации.</param>
    /// <param name="password">Пароль для аутентификации.</param>
    /// <returns>Возвращает true, если соединение установлено успешно, иначе false.</returns>
    public async Task<bool> SetConnection(string url, string userName, string password)
    {
        _url = url;
        _username = userName;
        _password = password;


        _settings = new ODataClientSettings(new Uri(_url));
        _settings.IgnoreResourceNotFoundException = true;
        _settings.OnTrace = (x, y) =>
        {
            logger.Trace(string.Format(x, y));
        };
        _settings.RequestTimeout = new TimeSpan(0, 0, 600);
        _settings.BeforeRequest += delegate (HttpRequestMessage message)
        {
            var authHeaderValue = Convert.ToBase64String(Encoding.UTF8.GetBytes(string.Format("{0}:{1}", _username, _password)));
            message.Headers.Add("Authorization", "Basic " + authHeaderValue);
        };
        _settings.AfterResponse += httpResonse => { _response = httpResonse; };

        try
        {
            _client = new ODataClient(_settings);
            _metadata = await _client.GetMetadataAsync<IEdmModel>();

            return _metadata != null;
        }

        catch (WebRequestException ex)
        {
            logger.Error(ex);
            return false;
        }
        catch (Exception ex)
        {
            logger.Error(ex);
            return false;
        }

    }
    
    public async Task<IEnumerable<IEdmEntitySet>> ConfigureAsync(string url, string userName, string password)
    {
        _url = url;
        _username = userName;
        _password = password;


        _settings = new ODataClientSettings(new Uri(_url));
        _settings.IgnoreResourceNotFoundException = true;
        _settings.OnTrace = (x, y) =>
        {
            logger.Trace(string.Format(x, y));
        };
        _settings.RequestTimeout = new TimeSpan(0, 0, 600);
        _settings.BeforeRequest += delegate (HttpRequestMessage message)
        {
            var authHeaderValue = Convert.ToBase64String(Encoding.UTF8.GetBytes(string.Format("{0}:{1}", _username, _password)));
            message.Headers.Add("Authorization", "Basic " + authHeaderValue);
        };
        _settings.AfterResponse += httpResonse => { _response = httpResonse; };

        try
        {
            _client = new ODataClient(_settings);
            var metadata = await _client.GetMetadataAsync<IEdmModel>();
            var container = metadata.EntityContainer;
            return container.EntitySets().ToList();

        }

        catch (WebRequestException ex)
        {
            logger.Error(ex);
            return Enumerable.Empty<IEdmEntitySet>();
        }
        catch (Exception ex)
        {
            logger.Error(ex);
            return Enumerable.Empty<IEdmEntitySet>();
        }
    }

    /// <summary>
    /// Получить текущий ODataClient
    /// </summary>
    /// <returns></returns>
    /// <exception cref="InvalidOperationException"></exception>
    public ODataClient GetClient()
    {
        if (_client == null)
            throw new InvalidOperationException("OData client not initialized. Call SetConnection first.");

        return _client;
    }

    /// <summary>
    /// Получить текущий EntityContainer
    /// </summary>
    /// <returns>экземпляр IEdmEntityContainer</returns>
    public async Task<IEdmEntityContainer> GetEntityContainerAsync()
    {
        var metadata = await _client!.GetMetadataAsync<IEdmModel>();
        return metadata.EntityContainer;
    }

    /// <summary>
    /// Получить все коллекции сущностей
    /// </summary>
    /// <returns>IEnumerable<IEdmEntitySet></returns>
    public async Task<List<IEdmEntitySet>> GetEntitySetsAsync()
    {
        var metadata = await _client!.GetMetadataAsync<IEdmModel>();
        var container = metadata.EntityContainer;
        return container.EntitySets().ToList();
    }

    /// <summary>
    /// Получить схему выбранного типа сущности
    /// </summary>
    /// <param name="entitySet">выбранная коллекция сущностей</param>
    /// <returns>коллекция свойств в виде строки</returns>
    public async Task<List<EdmxField>> GetPropertiesOfEntitySetAsync(string entitySetName)
    {
        var metadata = await _client!.GetMetadataAsync<IEdmModel>();
        var container = metadata.EntityContainer;

        var entitySet = container.FindEntitySet(entitySetName);
        var entityType = entitySet?.EntityType();

        if (entityType == null)
            return new List<EdmxField>();

        return entityType.StructuralProperties()
            .Select(p => new EdmxField
            {
                Name = p.Name,
                Type = p.Type.FullName(),
                Nullable = p.Type.IsNullable
            }).ToList();
    }
}
