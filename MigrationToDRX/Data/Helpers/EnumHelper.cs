using System;
using MigrationToDRX.Data.Models.Dto;

namespace MigrationToDRX.Data.Helpers;

/// <summary>
/// Статический класс для работы с Enum
/// </summary>
public static class EnumHelper
{
    /// <summary>
    /// Получает список элементов enum с DisplayName
    /// </summary>
    public static List<EnumItem<TEnum>> GetItems<TEnum>() where TEnum : struct, Enum
    {
        return Enum.GetValues(typeof(TEnum))
            .Cast<TEnum>()
            .Select(value => new EnumItem<TEnum>
            {
                Value = value,
                DisplayName = value.GetDisplayName()
            })
            .ToList();
    }
}
