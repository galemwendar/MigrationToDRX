using System;
using MigrationToDRX.Data.Enums;

namespace MigrationToDRX.Data.Models.Dto;

/// <summary>
/// Дто для передачи данных на сервер
/// </summary>
public class ProcessedEntityDto
{
    public IDictionary<string, object>? Entity { get; set; }

    public EdmxEntityDto? Edmx { get; set; }

    public OdataOperation Scenario { get; set; }

    public bool IsCollection { get; set; }

    public IDictionary<string, string>? SearchCriterias { get; set; }
}
