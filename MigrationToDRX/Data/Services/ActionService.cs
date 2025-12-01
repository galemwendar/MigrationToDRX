using System;
using MigrationToDRX.Data.Helpers;
using MigrationToDRX.Data.Models.Dto;

namespace MigrationToDRX.Data.Services;

/// <summary>
/// Сервис для работы с Odata Actions и Functions
/// </summary>
public class ActionService
{
    /// <summary>
    /// Сервис для работы с OData
    /// </summary>
    private readonly OdataClientService _odataClientService;

    public ActionService(OdataClientService odataClientService)
    {
        _odataClientService = odataClientService;
    }

    /// <summary> 
    /// Выполнить действие на сервере, если действие существует (IsBound = true) и возвращает void
    /// </summary>
    /// <param name="moduleName">Имя модуля</param>
    /// <param name="actionName">Имя действия</param>
    /// <param name="parametres">Параметры действия</param>
    public async Task<OperationResult> ExecuteActionAsync(string moduleName,
        string actionName,
        IDictionary<string, object> parametres,
        CancellationToken ct)
    {
        try
        {
            await _odataClientService.ExecuteVoidBoundActionAsync(moduleName, actionName, parametres, ct);

            return new OperationResult(success: true, operationName: actionName);
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: actionName, errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Выполнить действие на сервере, если действие существует (IsBound = true) 
    /// и возвращает простой тип данных: int, string, bool, double, DateTime и т.д.
    /// </summary>
    /// <param name="moduleName">Имя модуля</param>
    /// <param name="actionName">Имя действия</param>
    /// <param name="dto">Параметры действия</param>
    /// <param name="ct">Токен отмены</param>
    /// <typeparam name="T">Тип ответа</typeparam>
    /// <returns>Результат выполнения операции</returns>
    public async Task<OperationResult> ExecuteActionAsScalarAsync<T>(string moduleName,
        string actionName,
        IDictionary<string, object> parametres,
        CancellationToken ct)
    {
        try
        {
            var entityId = await _odataClientService.ExecuteBoundActionAsScalarAsync<long>(moduleName, actionName, parametres, ct);

            if (entityId == 0)
            {
                return new OperationResult(success: false, operationName: actionName, errorMessage: "Пришел пустой ответ");
            }
            else
            {
                return new OperationResult(success: true, operationName: actionName, entityId: entityId);
            }
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: actionName, errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Выполнить действие на сервере, если действие существует (IsBound = true) 
    /// и возвращает простой тип данных: int, string, bool, double, DateTime и т.д.
    /// </summary>
    /// <param name="moduleName">Имя модуля</param>
    /// <param name="actionName">Имя действия</param>
    /// <param name="dto">Параметры действия</param>
    /// <param name="ct">Токен отмены</param>
    /// <typeparam name="T">Тип ответа</typeparam>
    /// <returns>Результат выполнения операции</returns>
    public async Task<OperationResult> ExecuteActionAsSingleEntityAsync(string moduleName,
        string actionName,
        IDictionary<string, object> parametres,
        CancellationToken ct)
    {
        try
        {
            //TODO: в будущем преобразовывать в нормальную модель T
            var entityId = await _odataClientService.ExecuteBoundActionAsSingleAsync<long>(moduleName, actionName, parametres, ct);

            if (entityId == 0)
            {
                return new OperationResult(success: false, operationName: actionName, errorMessage: "Пришел пустой ответ");
            }
            else
            {
                return new OperationResult(success: true, operationName: actionName, entityId: entityId);
            }
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: actionName, errorMessage: ex.Message);
        }
    }

    /// <summary>
    /// Выполнить действие на сервере, если действие существует (IsBound = true) 
    /// и возвращает простой тип данных: int, string, bool, double, DateTime и т.д.
    /// </summary>
    /// <param name="moduleName">Имя модуля</param>
    /// <param name="actionName">Имя действия</param>
    /// <param name="dto">Параметры действия</param>
    /// <param name="ct">Токен отмены</param>
    /// <typeparam name="T">Тип ответа</typeparam>
    /// <returns>Результат выполнения операции</returns>
    public async Task<OperationResult> ExecuteActionAsListOfEntitiesAsync(string moduleName,
        string actionName,
        IDictionary<string, object> parametres,
        CancellationToken ct)
    {
        try
        {
            //TODO: в будущем преобразовывать в нормальную модель IEnumerable<T>
            var entities = await _odataClientService.ExecuteBoundActionAsEnumerableAsync<long>(moduleName, actionName, parametres, ct);

            if (entities == null || entities.Count() == 0)
            {
                return new OperationResult(success: false, operationName: actionName, errorMessage: "Пришел пустой ответ");
            }
            else
            {
                return new OperationResult(success: true, operationName: actionName, entities: entities);
            }
        }
        catch (Exception ex)
        {
            return new OperationResult(success: false, operationName: actionName, errorMessage: ex.Message);
        }
    }
}
