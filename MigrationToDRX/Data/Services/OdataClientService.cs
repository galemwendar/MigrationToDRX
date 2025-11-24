using System.Text;
using Microsoft.OData.Edm;
using MigrationToDRX.Data.Models.Dto;
using NLog;
using Simple.OData.Client;

namespace MigrationToDRX.Data.Services;

public class OdataClientService
{
    private ODataClient? _client;
    private IEdmModel? _metadata = null;

    private IEdmEntityContainer? _container = null;

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
        var settings = new ODataClientSettings(new Uri(url));
        settings.IgnoreResourceNotFoundException = true;
        settings.OnTrace = (x, y) =>
        {
            logger.Trace(string.Format(x, y));
        };
        settings.RequestTimeout = new TimeSpan(0, 0, 600);
        settings.BeforeRequest += delegate (HttpRequestMessage message)
        {
            var authHeaderValue = Convert.ToBase64String(Encoding.UTF8.GetBytes(string.Format("{0}:{1}", userName, password)));
            message.Headers.Add("Authorization", "Basic " + authHeaderValue);
        };
        settings.AfterResponse += httpResonse => { _ = httpResonse; };

        try
        {
            _client = new ODataClient(settings);
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
        {
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");
        }

        return _client;
    }


    /// <summary>
    /// Получить все коллекции сущностей
    /// </summary>
    /// <returns>Коллекция сущностей</returns>
    public List<IEdmEntitySet> GetEntitySets()
    {
        return _container.EntitySets().Where(s => s.Name.StartsWith("I")).ToList();
    }

    /// <summary>
    /// Получить схему выбранного типа сущности по EntitySet
    /// </summary>
    /// <param name="entitySetName">выбранная коллекция сущностей</param>
    /// <returns>dto с описанием структуры сущности</returns>
    public EdmxEntityDto GetEdmxEntityDto(string entitySetName)
    {
        var entitySet = _container!.FindEntitySet(entitySetName);

        var entityType = entitySet?.EntityType()
            ?? _metadata!.FindDeclaredType(entitySetName) as IEdmEntityType;

        if (entityType == null)
            return new EdmxEntityDto();

        var keys = entityType.Key().Select(k => k.Name).ToList();

        return new EdmxEntityDto()
        {

            Name = entityType.Name,
            FullName = entityType.FullName(),
            BaseType = entityType.BaseType?.FullTypeName(),
            EntitySetName = entitySetName,
            IsAbstract = entityType.IsAbstract,
            IsOpen = entityType.IsOpen,
            Keys = keys,

            StructuralProperties = entityType.StructuralProperties().Select(p => new StructuralPropertyDto
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
    /// Получить схему сущности по ее полному типу
    /// </summary>
    /// <param name="fullTypeName"></param>
    /// <returns></returns>
    public EdmxEntityDto GetEdmxEntityDtoByType(string fullTypeName)
    {
        var entityType = _metadata!.FindDeclaredType(fullTypeName) as IEdmEntityType;
        if (entityType == null)
            return new EdmxEntityDto();

        var keys = entityType.Key().Select(k => k.Name).ToList();

        return new EdmxEntityDto
        {
            Name = entityType.Name,
            FullName = entityType.FullName(),
            BaseType = entityType.BaseType?.FullTypeName(),
            EntitySetName = null, // неизвестно, если ищем только по типу
            IsAbstract = entityType.IsAbstract,
            IsOpen = entityType.IsOpen,
            Keys = keys,
            StructuralProperties = entityType.StructuralProperties().Select(p => new StructuralPropertyDto
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
            }).ToList()
        };
    }


    /// <summary>
    /// Получить схему выбранного типа сущности
    /// </summary>
    /// <param name="typeOrEntitySetName">выбранная коллекция сущностей</param>
    /// <returns>dto с описанием структуры сущности</returns>
    public IEdmEntityType? GetEdmxEntityType(string typeOrEntitySetName)
    {
        var entitySet = _container!.FindEntitySet(typeOrEntitySetName);


        var entityType = entitySet?.EntityType()
            ?? _metadata!.FindDeclaredType(typeOrEntitySetName) as IEdmEntityType;

        return entityType;
    }

    /// <summary>
    /// Получить список свойств свойства-коллекции
    /// </summary>
    /// <param name="prop">Свойство-коллекция</param>
    /// <returns>Структура сущности с заполненным именем и списком свойств</returns>
    public EdmxEntityDto GetChildEntities(NavigationPropertyDto prop)
    {
        if (!prop.IsCollection)
        {
            throw new ArgumentException("Свойство не является коллекцией", nameof(prop));
        }

        if (string.IsNullOrWhiteSpace(prop.Type))
        {
            throw new ArgumentException("Не указан тип свойства", nameof(prop));
        }

        var propertyDeclaredType = string.Empty;

        const string prefix = "Collection(";
        const string suffix = ")";

        if (prop.Type.StartsWith(prefix) && prop.Type.EndsWith(suffix))
        {
            propertyDeclaredType = prop.Type.Substring(prefix.Length, prop.Type.Length - prefix.Length - suffix.Length);
        }

        return GetEdmxEntityDtoByType(propertyDeclaredType);
    }

    /// <summary>
    /// Получить сущность из коллекции по фильтру.
    /// </summary>
    /// <param name="entitySetName">коллекция сущности</param>
    /// <param name="propertyName">имя свойства, по которому осуществляется фильтр</param>
    /// <param name="filter">критерий фильтрации</param>
    /// <returns>сущность</returns>
    public async Task<IDictionary<string, object>> GetEntityAsync(string entitySetName, string propertyName, Type filterType, object filter)
    {
        if (_client == null)
        {
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");

        }
        try
        {
            if (filterType == typeof(string))
            {
                filter = $"\'{filter}\'";
            }

            return await _client!
                    .For(entitySetName)
                    .Filter($"{propertyName} eq {filter}")
                    .FindEntryAsync();
        }
        catch (WebRequestException ex)
        {
            throw new ArgumentException(ex.Message + ex.Response);
        }
    }

    /// <summary>
    /// Получить сущность из свойства-коллекции по фильтру.
    /// </summary>
    /// <param name="entitySetName">Главная сущность</param>
    /// <param name="mainKey">Идентификатор главной сущности</param>
    /// <param name="propertyName">Свойство-коллекция</param>
    /// <param name="key">Идентификатор свойства-коллекции</param>
    /// <returns></returns>
    public async Task<IDictionary<string, object>> GetChildEntityAsync(string entitySetName, long mainKey, string propertyName, long key)
    {
        if (_client == null)
        {
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");

        }
        try
        {
            return await _client!
                    .For(entitySetName)
                    .Key(mainKey)
                    .NavigateTo(propertyName)
                    .Key(key)
                    .FindEntryAsync();
        }
        catch (WebRequestException ex)
        {
            throw new ArgumentException(ex.Message + ex.Response);
        }
    }

    /// <summary>
    /// Получить сущность из коллекции по фильтру.
    /// </summary>
    /// <param name="entitySetName">коллекция сущности</param>
    /// <param name="key">ключ, по которому идет фильтр</param>
    /// <returns>сущность</returns>
    public async Task<IDictionary<string, object>> GetEntityAsync(string entitySetName, long key)
    {
        if (_client == null)
        {
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");

        }
        try
        {
            return await _client!
             .For(entitySetName)
             .Key(key)
             .FindEntryAsync();
        }
        catch (WebRequestException ex)
        {
            logger.Error(ex);
            throw new ArgumentNullException(ex.Message + ex.Response);
        }
    }

    /// <summary>
    /// Получить документ по его Id
    /// </summary>
    /// <param name="eDocId">Идентификатор документа</param>
    /// <returns>Документ</returns>
    public async Task<IDictionary<string, object>> FindEdocAsync(long eDocId)
    {
        return await _client!
            .For("IElectronicDocuments")
            .Key(eDocId)
            .Expand("Versions($expand=AssociatedApplication,Body)")
            .FindEntryAsync();
    }

    /// <summary>
    /// Найти приложение по его расширению
    /// </summary>
    /// <param name="extension">Расширение приложения</param>
    /// <returns></returns>
    public async Task<IDictionary<string, object>?> FindAssociatedApplication(string extension)
    {
        try
        {
            return await _client!.For("IAssociatedApplications").Filter($@"Extension eq '{extension}'").FindEntryAsync();
        }
        catch (Exception ex)
        {
            logger.Error(ex);
            return null;
        }
    }

    /// <summary>
    /// Создать новую версию документа
    /// </summary>
    /// <param name="eDocId">Идентификатор документа</param>
    /// <param name="note">Описание версии</param>
    /// <param name="associatedApp">Приложение, связанное с документом</param>
    /// <returns>Сущность созданной версии документа</returns>
    public async Task<IDictionary<string, object>?> CreateNewVersion(long eDocId, string note, IDictionary<string, object> associatedApp)
    {
        try
        {
            return await _client!.For("IElectronicDocuments")
                .Key(eDocId)
                .NavigateTo("Versions")
                .Set(new { Note = note, Created = DateTime.Now, AssociatedApplication = associatedApp })
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
    /// <param name="eDocId">Идентификатор документа</param>
    /// <param name="body">Тело документа</param>
    /// <param name="lastVersion">Последняя версия документа</param>
    /// <returns></returns>
    public async Task FillBodyAsync(long eDocId, byte[] body, IDictionary<string, object> lastVersion)
    {
        try
        {
            lastVersion.TryGetValue("Id", out var lastVersionKey);

            if (lastVersionKey == null)
            {
                return;
            }
            int.TryParse(lastVersionKey.ToString(), out int lastVersionId);

            var eDocBody = await _client!.For("IElectronicDocuments")
                .Key(eDocId)
                .NavigateTo("Versions")
                .Key(lastVersionId)
                .NavigateTo("Body")
                .Set(new { Value = body, })
                .InsertEntryAsync();
        }
        catch (Exception ex)
        {
            logger.Error(ex);
            return;
        }
    }

    /// <summary>
    /// Добавить новую сущность на сервер
    /// </summary>
    /// <param name="entity">сущность</param>
    /// <param name="entitySet">коллекция сущностей</param>
    /// <returns>новая сущность</returns>
    public async Task<IDictionary<string, object>?> InsertEntityAsync(IDictionary<string, object> entity, string entitySet)
    {
        if (_client == null)
        {
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");

        }
        try
        {
            return await _client!.For(entitySet).Set(entity).InsertEntryAsync();
        }

        catch (WebRequestException ex)
        {
            logger.Error(ex);
            return null;
        }
        catch (Exception ex)
        {
            logger.Error(ex);
            return null;
        }
    }

    /// <summary>
    /// Добавить элемент в свойство-коллекцию сущности 
    /// </summary>
    /// <param name="childEntity">Новый элемент свойства-коллекции</param>
    /// <param name="mainId">Сущность, для которой добавляется элемент</param>
    /// <param name="entitySet">Коллекция сущностей</param>
    /// <param name="collectionPropertyName">Имя свойства-коллекции</param>
    /// <returns>Новая сущность</returns>
    public async Task<IDictionary<string, object>> InsertChildEntityAsync(IDictionary<string, object> childEntity,
        long mainId,
        string entitySet,
        string collectionPropertyName)
    {
        if (_client == null)
        {
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");

        }
        try
        {
            return await _client!.For(entitySet).Key(mainId).NavigateTo(collectionPropertyName).Set(childEntity).InsertEntryAsync();
        }

        catch (WebRequestException ex)
        {
            logger.Error(ex);
            return new Dictionary<string, object>();
        }
        catch (Exception ex)
        {
            logger.Error(ex);
            return new Dictionary<string, object>();
        }
    }

    /// <summary>
    /// Обновить сущность
    /// </summary>
    /// <param name="newEntity">Данные для обновления</param>
    /// <param name="entityset">коллекция сущности</param>
    /// <param name="id">ключ сущности</param>
    /// <returns>Обновленная сущность</returns>
    /// <exception cref="Exception"></exception>
    public async Task<IDictionary<string, object>> UpdateEntityAsync(IDictionary<string, object> newEntity, string entityset, long id)
    {
        if (_client == null)
        {
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");

        }
        try
        {
            return await _client.For(entityset).Key(id).Set(newEntity).UpdateEntryAsync();
        }
        catch (WebRequestException ex)
        {
            logger.Error(ex);
            return new Dictionary<string, object>();
        }
        catch (Exception ex)
        {
            logger.Error(ex);
            return new Dictionary<string, object>();
        }
    }

    /// <summary>
    /// Обновить дочернюю сущность
    /// </summary>
    /// <param name="childEntity">Данные для обновления</param>
    /// <param name="entityset">коллекция сущности</param>
    /// <param name="id">ключ сущности</param>
    /// <param name="propertyName">имя свойства - коллекции</param>
    /// <returns></returns>
    /// <exception cref="Exception"></exception>
    public async Task<IDictionary<string, object>> UpdateChildEntityAsync(IDictionary<string, object> childEntity, string entityset, long id, string propertyName, long childEntityId)
    {
        if (_client == null)
        {
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");

        }
        try
        {
            return await _client.For(entityset).Key(id).NavigateTo(propertyName).Key(childEntityId).Set(childEntity).UpdateEntryAsync();
        }
        catch (WebRequestException ex)
        {
            logger.Error(ex);
            return new Dictionary<string, object>();
        }
        catch (Exception ex)
        {
            logger.Error(ex);
            return new Dictionary<string, object>();
        }
    }

    /// <summary>
    /// Получить список сущностей
    /// </summary>
    /// <returns>Список сущностей</returns>
    public async Task<List<string>> GetEntitiesV2Async()
    {
        var metadata = await _client!.GetMetadataAsync<Microsoft.OData.Edm.IEdmModel>();
        return metadata.SchemaElements
            .OfType<Microsoft.OData.Edm.IEdmEntityType>()
            .Select(e => e.Name)
            .OrderBy(x => x)
            .ToList();
    }

    public async Task<IEdmEntityType?> GetEntityType(string? entityName)
    {
        if (string.IsNullOrWhiteSpace(entityName))
        {
            return null;
        }

        var metadata = await _client!.GetMetadataAsync<Microsoft.OData.Edm.IEdmModel>();
        return metadata.SchemaElements
            .OfType<Microsoft.OData.Edm.IEdmEntityType>()
            .FirstOrDefault(t => t.Name == entityName);
    }

    /// <summary>
    /// Получить сущность по ее полному типу
    /// </summary>
    /// <param name="entityType"></param>
    /// <returns>Имя сущности</returns>
    /// <exception cref="InvalidOperationException">Клиент не инициализирован</exception>
    public async Task<string?> GetEntitySetNameByType(string entityType)
    {
        if (_client == null)
        {
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");
        }

        var metadata = await _client.GetMetadataAsync<IEdmModel>();
        var entityContainer = metadata.EntityContainer;

        var entitySets = entityContainer.EntitySets();

        return entitySets.FirstOrDefault(s => s.EntityType().FullTypeName() == entityType)?.Name ?? null;
    }

    /// <summary>
    /// Выполнить действие на сервере, если действие существует (IsBound = true)
    /// </summary>
    /// <param name="actionName">Имя действия</param>
    /// <param name="parameters">Параметры действия</param>
    public async Task ExecuteBoundActionAsync(string entitySetName, string actionName, IDictionary<string, object> parameters)
    {
        if (_client == null)
        {
            throw new InvalidOperationException("Odata клиент не инициализирован. Вызовите метод SetConnection");
        }

        try
        {
            var result = await _client
            .For(entitySetName)
            .Action(actionName)
            .Set(parameters)
            .ExecuteAsScalarAsync<int>();
        }
        catch (WebRequestException ex)
        {
            throw new ArgumentException(ex.Message + ex.Response);
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message, ex);
        }
    }

}
