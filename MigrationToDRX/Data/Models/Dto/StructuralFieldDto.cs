using System;

namespace MigrationToDRX.Data.Models.Dto;

/// <summary>
/// Свойство сущности
/// </summary>
public class StructuralFieldDto
{
        /// <summary>
        /// Название свойства сущности
        /// </summary>
        public string? Name { get; set; }

        /// <summary>
        /// Тип свойства сущности
        /// </summary>
        public string? Type { get; set; }

        /// <summary>
        /// Может ли свойство быть пустым
        /// </summary>
        public bool Nullable { get; set; }

        /// <summary>
        /// Краткое описание свойства
        /// </summary>
        public string? Summary => $"{Name} ({Type}) {(Nullable ? "Nullable" : "Not Nullable")}";
}
