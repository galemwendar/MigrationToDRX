using System;
using System.Runtime.InteropServices;

namespace MigrationToDRX.Data.Services;

/// <summary>
/// Сервис отвечающий за работу с системными данными
/// </summary>
public static class SystemService
{
    /// <summary>
    /// Получение операционной системы
    /// </summary>
    /// <returns>Операционная система</returns>
    /// <exception cref="Exception">Не удалось определить операционную систему</exception>
    public static OSPlatform GetOSPlatform()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            return OSPlatform.Windows;
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        {
            return OSPlatform.Linux;
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
        {
            return OSPlatform.OSX;
        }

        throw new Exception("Неизвестная операционная система");
    }
}
