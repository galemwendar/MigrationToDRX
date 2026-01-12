using System.Text;
using System.Text.Json;

namespace MigrationToDRX.Data.Services.Settings;

public class SettingService
{
    private readonly string _fileName;
    private FileService _fileService = new();

    public SettingService()
    {
        // Получаем путь к папке с исполняемым файлом
        var executablePath = AppDomain.CurrentDomain.BaseDirectory;
        _fileName = Path.Combine(executablePath, "Settings.json");
    }

    /// <summary>
    /// Получить данные
    /// </summary>
    /// <returns></returns>
    public async Task<List<SettingStage>> GetSettingStages()
    {
        if (!_fileService.IsFileExists(_fileName))
        {
            var emptyList = new List<SettingStage>();
            await UpdateStages(emptyList);
            return emptyList;
        }

        var data = await _fileService.ReadFileEvenIfOpenAsync(_fileName);
        return JsonSerializer.Deserialize<List<SettingStage>>(data) ?? new();
    }

    /// <summary>
    /// Обновить настройки этапов в конфигурационном файлы
    /// </summary>
    /// <param name="stages"></param>
    /// <returns></returns>
    public async Task UpdateStages(List<SettingStage> stages)
    {
        var options = new JsonSerializerOptions
        {
            WriteIndented = true, // Форматирование с отступами
            Encoder = System.Text.Encodings.Web.JavaScriptEncoder.UnsafeRelaxedJsonEscaping // Не экранировать кириллицу
        };

        var json = JsonSerializer.Serialize(stages, options);
        var byteData = Encoding.UTF8.GetBytes(json);
        await _fileService.WriteToFile(_fileName, byteData);
    }
}
