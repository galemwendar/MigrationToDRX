namespace MigrationToDRX.Data.Services.Settings;

public class ApplicationSettings
{
    public List<SettingStage> Stages { get; set; } = new();
    public int MigrationId { get; set; }
}
