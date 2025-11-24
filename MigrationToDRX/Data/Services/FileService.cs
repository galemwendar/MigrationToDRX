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

    /// <summary>
    /// Читает файл даже если он открыт
    /// </summary>
    public async Task<byte[]> ReadFileEvenIfOpenAsync(string path, CancellationToken ct = default)
    {
        ct.ThrowIfCancellationRequested();

        using var stream = new FileStream(
            path,
            FileMode.Open,
            FileAccess.Read,
            FileShare.ReadWrite,
            bufferSize: 81920,  // стандартный буфер .NET
            useAsync: true       // важно для асинхронного чтения
        );

        var buffer = new byte[stream.Length];
        int offset = 0;

        while (offset < buffer.Length)
        {
            int bytesRead = await stream.ReadAsync(buffer.AsMemory(offset, buffer.Length - offset), ct);
            if (bytesRead == 0) break; // конец файла
            offset += bytesRead;
        }

        return buffer;
    }

    /// <summary>
    /// Получает файл и конвертирует его в Base64
    /// </summary>
    /// <param name="filePath">Путь к файлу</param>
    /// <returns>Строка в формате Base64</returns>
    /// <exception cref="FileNotFoundException">Если файл не найден</exception>
    /// <exception cref="IOException">При ошибке чтения файла</exception>
    public async Task<string> GetFileAsBase64Async(string filePath)
    {
        if (string.IsNullOrWhiteSpace(filePath))
            throw new ArgumentException("Путь к файлу не может быть пустым", nameof(filePath));

        if (!IsFileExists(filePath))
            throw new FileNotFoundException($"Файл не найден: {filePath}");

        if (!IsLessThenTwoGb(filePath))
            throw new InvalidOperationException($"Размер файла превышает максимально допустимый (2 GB): {filePath}");

        try
        {
            byte[] fileBytes = await ReadFileEvenIfOpenAsync(filePath);
            return Convert.ToBase64String(fileBytes);
        }
        catch (Exception ex)
        {
            throw new IOException($"Ошибка при чтении файла {filePath}", ex);
        }
    }
}
