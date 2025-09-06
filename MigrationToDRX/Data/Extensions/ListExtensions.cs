using System;

namespace MigrationToDRX.Data.Extensions;

/// <summary>
/// Расширения для списков
/// </summary>
public static class ListExtensions
{
    /// <summary>
    /// Добавляет элемент в начало списка
    /// </summary>
    public static void AddFirst<T>(this List<T> list, T item)
    {
        list.Insert(0, item);
    }

    /// <summary>
    /// Добавляет несколько элементов в начало списка
    /// </summary>
    public static void AddFirstRange<T>(this List<T> list, IEnumerable<T> items)
    {
        list.InsertRange(0, items);
    }
}
