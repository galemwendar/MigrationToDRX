using System;
using MigrationToDRX.Data.Enums;

namespace MigrationToDRX.Data.Models.Dto;

/// <summary>
/// Дто для передачи данных на сервер
/// </summary>
public class ProcessedEntityDto
{
    public IDictionary<string, object>? Entity { get; set; }

    public string? EntitySet { get; set; }

    public OdataScenario Scenario { get; set; }

    public bool IsCollection { get; set; }

    public SearchEntityBy SearchEntityBy { get; set; }
}
