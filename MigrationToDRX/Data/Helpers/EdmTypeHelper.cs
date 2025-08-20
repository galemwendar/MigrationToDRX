using System;

namespace MigrationToDRX.Data.Helpers;

/// <summary>
/// Вспомогательный класс для работы с типами Edm
/// </summary>
public static class EdmTypeHelper
{
    /// <summary>
    /// Простые типы данных Odata
    /// </summary>
    public static Dictionary<string, Type> StructuralTypes = new Dictionary<string, Type>()
    {
        ["String"] = typeof(string),
        ["Int32"] = typeof(int),
        ["Boolean"] = typeof(bool),
        ["DateTimeOffset"] = typeof(DateTimeOffset),
        ["Guid"] = typeof(Guid),
        ["Double"] = typeof(double),
        ["Binary"] = typeof(byte[])
    };

    /// <summary>
    /// Значения статусов в DirectumRX
    /// </summary>
    public static Dictionary<string, string> StatusValues = new Dictionary<string, string>()
    {
        ["Действующая"] = "Active",
        ["Закрытая"] = "Close"
    };

    public static string SearchCryteria = "Name";

    public static string MainEntityId = "MainId";

    public static bool SearchByName = true;

    public static string UpdateEntityId = "UpdateEntityId";
}
