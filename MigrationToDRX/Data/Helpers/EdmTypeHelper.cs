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
}
