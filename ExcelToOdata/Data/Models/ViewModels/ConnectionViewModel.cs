using System;

namespace ExcelToOdata.Data.Models.ViewModels;

/// <summary>
/// Модель для подключения к Odata серверу
/// </summary>
public class ConnectionViewModel
{
    /// <summary>
    /// Адрес Odata сервера
    /// </summary>
    public string? Url { get; set; }

    /// <summary>
    /// Имя пользователя
    /// </summary>
    public string? UserName { get; set; }

    /// <summary>
    /// Пароль
    /// </summary>
    public string? Password { get; set; }

}
