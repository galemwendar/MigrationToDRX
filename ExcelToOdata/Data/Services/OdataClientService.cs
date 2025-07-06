using System;
using System.Text;
using ExcelToOdata.Data.Models;
using ExcelToOdata.Data.Models.Dto;
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

    private IEdmEntityContainer? _container = null;

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
            _container = _metadata.EntityContainer;

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

    /// <summary>
    /// Получить текущий ODataClient
    /// </summary>
    /// <returns>ODataClient</returns>
    /// <exception cref="InvalidOperationException"> Если клиент не инициализирован </exception>
    public ODataClient GetClient()
    {
        if (_client == null)
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");

        return _client;
    }


    /// <summary>
    /// Получить все коллекции сущностей
    /// </summary>
    /// <returns>IEnumerable<IEdmEntitySet></returns>
    public List<IEdmEntitySet> GetEntitySets()
    {
        return _container.EntitySets().ToList();
    }

    /// <summary>
    /// Получить схему выбранного типа сущности
    /// </summary>
    /// <param name="entitySet">выбранная коллекция сущностей</param>
    /// <returns>dto с описанием структуры сущности</returns>
    public EdmxEntityDto GetEdmxEntityDto(string typeOrEntitySetName)
    {
        var entitySet = _container!.FindEntitySet(typeOrEntitySetName);

        var entityType = entitySet?.EntityType()
            ?? _metadata!.FindDeclaredType(typeOrEntitySetName) as IEdmEntityType;

        if (entityType == null)
            return new EdmxEntityDto();

        var keys = entityType.Key().Select(k => k.Name).ToList();

        return new EdmxEntityDto()
        {

            Name = entityType.Name,
            FullName = entityType.FullName(),
            BaseType = entityType.BaseType?.FullTypeName(),
            EntitySetName = typeOrEntitySetName,
            IsAbstract = entityType.IsAbstract,
            IsOpen = entityType.IsOpen,
            Keys = keys,

            StructuralProperties = entityType.StructuralProperties().Select(p => new StructuralFieldDto
            {
                Name = p.Name,
                Type = p.Type.FullName(),
                Nullable = p.Type.IsNullable
            }).ToList(),

            NavigationProperties = entityType.NavigationProperties().Select(p => new NavigationPropertyDto
            {
                Name = p.Name,
                Type = p.Type.FullName(),
                IsCollection = p.Type.IsCollection(),
                Nullable = p.Type.IsNullable
            }).ToList(),
        };
    }

    /// <summary>
    /// Получить список свойств свойства-коллекции
    /// </summary>
    /// <param name="prop">Свойство-коллекция</param>
    /// <returns>Структура сущности с заполненным именем и списком свойств</returns>
    public EdmxEntityDto GetChildEntities(NavigationPropertyDto prop)
    {
        if (prop.IsCollection == false)
        {
            throw new Exception("Свойство не является коллекцией");
        }

        if (string.IsNullOrWhiteSpace(prop.Type))
        {
            throw new Exception("Не указан тип свойства");
        }

        var propertyDeclaredType = string.Empty;

        const string prefix = "Collection(";
        const string suffix = ")";

        if (prop.Type.StartsWith(prefix) && prop.Type.EndsWith(suffix))
        {
            propertyDeclaredType = prop.Type.Substring(prefix.Length, prop.Type.Length - prefix.Length - suffix.Length);
        }

        var edmType = _metadata!.FindDeclaredType(propertyDeclaredType);

        var structuredType = edmType as IEdmStructuredType;

        return new EdmxEntityDto()
        {
            Name = structuredType?.FullTypeName(),
            StructuralProperties = structuredType?
            .DeclaredProperties?
            .Select(p => new StructuralFieldDto
            {
                Name = p.Name,
                Type = p.Type.FullName(),
                Nullable = p.Type.IsNullable
            }).ToList() ?? new()
        };
    }
}
