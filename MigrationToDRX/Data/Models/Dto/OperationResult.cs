namespace MigrationToDRX.Data.Models.Dto;
/// <summary>
/// Результат выполнения операции
/// </summary>
public class OperationResult
{
    public bool Success { get; set; }
    public int EntityId { get; set; }
    public string Message { get; set; } = string.Empty;
    public List<EntityFieldDto> EntityFields { get; set; } = new();
    public DateTime Timestamp { get; set; } = DateTime.Now;
    public string Stamp {get; set; } = string.Empty;
}