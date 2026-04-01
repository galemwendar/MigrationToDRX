using System.Text;
using System.Text.Json;

namespace MigrationToDRX.Data.Services.Settings;

public class SettingService
{
    private readonly string _fileName;
    private FileService _fileService = new();

    private static readonly JsonSerializerOptions _jsonOptions = new()
    {
        WriteIndented = true,
        Encoder = System.Text.Encodings.Web.JavaScriptEncoder.UnsafeRelaxedJsonEscaping
    };

    public SettingService()
    {
        var executablePath = AppDomain.CurrentDomain.BaseDirectory;
        _fileName = Path.Combine(executablePath, "Settings.json");
    }

    /// <summary>
    /// Получить все настройки приложения
    /// </summary>
    public async Task<ApplicationSettings> GetSettings()
    {
        if (!_fileService.IsFileExists(_fileName))
        {
            var empty = new ApplicationSettings { Stages = new List<SettingStage>(), MigrationId = 0};
            await UpdateSettings(empty);
            return empty;
        }

        var data = await _fileService.ReadFileEvenIfOpenAsync(_fileName);
        return JsonSerializer.Deserialize<ApplicationSettings>(data, _jsonOptions)
               ?? new ApplicationSettings { Stages = new List<SettingStage>(), MigrationId = 0};
    }

    /// <summary>
    /// Сохранить все настройки приложения
    /// </summary>
    public async Task UpdateSettings(ApplicationSettings settings)
    {
        var json = JsonSerializer.Serialize(settings, _jsonOptions);
        var byteData = Encoding.UTF8.GetBytes(json);
        await _fileService.WriteToFile(_fileName, byteData);
    }

    /// <summary>
    /// Получить список этапов (обёртка для обратной совместимости)
    /// </summary>
    public async Task<List<SettingStage>> GetSettingStages()
    {
        var settings = await GetSettings();
        return settings.Stages?.ToList() ?? new();
    }

    /// <summary>
    /// Обновить список этапов, сохранив остальные настройки
    /// </summary>
    public async Task UpdateStages(List<SettingStage> stages)
    {
        var settings = await GetSettings();
        settings.Stages = stages;
        await UpdateSettings(settings);
    }
}
