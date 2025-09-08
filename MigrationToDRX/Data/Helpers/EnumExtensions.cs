using System;
using System.ComponentModel.DataAnnotations;
using System.Reflection;

namespace MigrationToDRX.Data.Helpers;

/// <summary>
/// Расширения для работы с Enum
/// </summary>
public static class EnumExtensions
{
    /// <summary>
    /// Получает имя перечисления для значения Enum
    /// </summary>
    /// <param name="value">Значение Enum</param>
    /// <returns>Имя перечисления</returns>
    public static string GetDisplayName(this Enum value)
    {
        var member = value.GetType().GetMember(value.ToString()).FirstOrDefault();
        if (member != null)
        {
            var displayAttr = member.GetCustomAttribute<DisplayAttribute>();
            if (displayAttr != null)
                return displayAttr.Name ?? value.ToString();
        }
        return value.ToString();
    }
}
