using System;
using MigrationToDRX.Data.Enums;

namespace MigrationToDRX.Data.Models.Dto;

/// <summary>
/// Базовый класс для отображения Enum в DropDown
/// </summary>
public class EnumItem<TEnum> where TEnum : struct, Enum
{
    /// <summary>
    /// Значение enum
    /// </summary>
    public TEnum Value { get; set; }

    /// <summary>
    /// Отображаемое имя enum в DropDown
    /// </summary>
    public string DisplayName { get; set; } = "";
}
