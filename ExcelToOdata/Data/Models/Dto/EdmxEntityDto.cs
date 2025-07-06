using System;
using Microsoft.Data.Edm;

namespace ExcelToOdata.Data.Models.Dto;

/// <summary>
/// Структура сущности
/// </summary>
public class EdmxEntityDto
{
    /// <summary>
    /// Название сущности
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// Полное имя типа (Namespace + Name)
    /// </summary>
    public string? FullName { get; set; }

    /// <summary>
    /// Имя базового типа, если есть
    /// </summary>
    public string? BaseType { get; set; }

    /// <summary>
    /// Является ли тип абстрактным
    /// </summary>
    public bool IsAbstract { get; set; }

    /// <summary>
    /// Поддерживает ли тип open properties
    /// </summary>
    public bool IsOpen { get; set; }

    /// <summary>
    /// Имя EntitySet, к которому относится сущность
    /// </summary>
    public string? EntitySetName { get; set; }

    /// <summary>
    /// Названия свойств, входящих в ключ сущности
    /// </summary>
    public List<string> Keys { get; set; } = new();

    /// <summary>
    /// Коллекция структурных (простых) свойств сущности
    /// </summary>
    public List<StructuralFieldDto> StructuralProperties { get; set; } = new();

    /// <summary>
    /// Коллекция навигационных свойств сущности
    /// </summary>
    public List<NavigationPropertyDto> NavigationProperties { get; set; } = new();
}
