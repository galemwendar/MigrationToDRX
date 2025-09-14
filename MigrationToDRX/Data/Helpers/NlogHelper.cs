using System;
using NLog;
using NLog.Web;

namespace MigrationToDRX.Data.Helpers;

/// <summary>
/// Класс для работы с NLog
/// </summary>
public static class NlogHelper
{
    /// <summary>
    /// Создать папку для логов
    /// </summary>
    public static void EnsureLogDirectoryExists()
    {
        var logFolder = Path.Combine(AppContext.BaseDirectory, "logs");
        if (!Directory.Exists(logFolder))
        {
            Directory.CreateDirectory(logFolder);
        }
    }
}
