using System;

namespace MigrationToDRX.Data.Services;

/// <summary>
/// Сервис для работы с файлами
/// </summary>
public class FileService
{
    /// <summary>
    /// Максимальный размер файла в байтах
    /// </summary>
    private readonly long maxFileSizeInBytes = 2L * 1024 * 1024 * 1024; // 2 Gb

    /// <summary>
    /// Проверяет, что файл существует
    /// </summary>
    /// <param name="filePath">Путь к файлу</param>
    /// <returns>Возвращает true, если файл существует, иначе false</returns>
    public bool IsFileExists(string filePath)
    {
        return System.IO.File.Exists(filePath);
    }

    /// <summary>
    /// Проверяет, что файл меньше максимального размера
    /// </summary>
    /// <param name="filePath">Путь к файлу</param>
    /// <returns>Возвращает true, если файл меньше максимального размера, иначе false</returns>
    public bool IsLessThenTwoGb(string filePath)
    {
        var fileInfo = new System.IO.FileInfo(filePath);
        return fileInfo.Length < maxFileSizeInBytes;
    }

}
