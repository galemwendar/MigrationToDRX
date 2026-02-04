using MigrationToDRX.Data.Services.Settings;

namespace MigrationToDRX.Data.Models.Dto;

public enum StageStatus
{
    Pending,
    Ready,
    InProgress,
    Running,
    Completed,
    Processed,
    Error,
}

public class ProcessStageDto
{
    public SettingStage settings { get; set; }
    public int ProcessedRows { get; set; }
    public StageStatus Status { get; set; }
    public bool ProcessedSuccess { get; set; }
}
