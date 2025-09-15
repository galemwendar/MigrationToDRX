using System;

namespace MigrationToDRX.Data.Helpers;

/// <summary>
/// Вспомогательный класс для работы с типами Edm
/// </summary>
public static class EdmTypeHelper
{
    /// <summary>
    /// Конвертация строки в значение соответствующего Edm типа
    /// </summary>
    /// <param name="value">Строковое значение</param>
    /// <param name="edmType">Тип Edm</param>
    /// <returns>Конвертированное значение или null, если конвертация не удалась</returns>
    public static object? ConvertEdmValue(string? value, string edmType)
    {
        if (string.IsNullOrEmpty(value))
            return null;

        return edmType switch
        {
            "Edm.String" => value,
            "Edm.Int32" => int.TryParse(value, out var i) ? i : null,
            "Edm.Int64" => long.TryParse(value, out var l) ? l : null,
            "Edm.Decimal" => decimal.TryParse(value, out var d) ? d : null,
            "Edm.Double" => double.TryParse(value, out var dbl) ? dbl : null,
            "Edm.Boolean" => bool.TryParse(value, out var b) ? b : null,
            "Edm.DateTimeOffset" => DateTimeOffset.TryParse(value, out var dt) ? dt : null,
            "Edm.Guid" => Guid.TryParse(value, out var g) ? g : null,
            _ => value // fallback для неизвестного типа
        };
    }

    /// <summary>
    /// Конвертация строки в значение, используемое в Edm для свойства Status
    /// </summary>
    /// <param name="status">Строковое значение</param>
    /// <returns>Конвертированное значение или null, если конвертация не удалась</returns>
    public static string? ConvertStatusToEdm(string status)
    {
        return status switch
        {
            "Действующая" => "Active",
            "Действующий" => "Active",
            "Закрытая" => "Close",
            "Закрытый" => "Close",
            _ => null
        };
    }

    /// <summary>
    /// Конвертация строки в значение, используемое в Edm для свойства NumberingType
    /// </summary>
    /// <param name="numberingType">Строковое значение</param>
    /// <returns>Конвертированное значение или null, если конвертация не удалась</returns>
    public static string? ConvertNumberingTypeToEdm(string numberingType)
    {
        return numberingType switch
        {
            "Не нумеруемый" => "NotNumerable",
            "Нумеруемый" => "Numerable",
            "Регистрируемый" => "Registrable",
            _ => null
        };
    }
    
    /// <summary>
    /// Конвертация строки в значение, используемое в Edm для свойства DocumentFlow
    /// </summary>
    /// <param name="documentFlow">Строковое значение</param>
    /// <returns>Конвертированное значение или null, если конвертация не удалась</returns>
    public static string? ConvertDocumentFlowToEdm(string documentFlow)
    {
        return documentFlow switch
        {
            "Внутренний" => "Inner",
            "Входящий" => "Incoming",
            "Исходящий" => "Outgoing",
            "Договоры" => "Contracts",
            _ => null
        };
    }
}
