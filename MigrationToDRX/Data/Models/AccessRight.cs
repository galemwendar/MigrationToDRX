namespace MigrationToDRX.Data.Models;

public sealed class AccessRight
{
    /// <summary>
    /// Уникальный идентификатор права доступа в DirectumRX
    /// </summary>
    public string Id { get; set; }

    /// <summary>
    /// Наименование права доступа
    /// </summary>
    public string Name { get; set; }

    private AccessRight(string id, string name)
    {
        Id = id;
        Name = name;
    }

    /// <summary>
    /// Право доступа "Просмотр"
    /// </summary>
    public static readonly AccessRight Read = new("676a7c2d-f883-4528-b190-84fa0e3cc0f3", "Просмотр");

    /// <summary>
    /// Право доступа "Изменение"
    /// </summary>
    public static readonly AccessRight Write = new("179af257-a60f-44b8-97b5-1d5bbd06716b", "Изменение");

    /// <summary>
    /// Право доступа "Полный доступ"
    /// </summary>
    public static readonly AccessRight Full = new("6eb00eea-b585-43ce-8a0a-a294146e0825", "Полный доступ");

    /// <summary>
    /// Право доступа "Доступ запрещен"
    /// </summary>
    public static readonly AccessRight Forbid = new("ce594290-7152-4a45-a1eb-805dddb1b80e", "Доступ запрещен");

    /// <summary>
    /// Все права доступа
    /// </summary>
    public static IEnumerable<AccessRight> All => new[] { Read, Write, Full, Forbid };

    /// <summary>
    /// Поиск права доступа по идентификатору или наименованию
    /// </summary>
    /// <param name="input">ввод пользователя</param>
    /// <returns>Возвраает право доступа или null</returns>
    public static AccessRight? Find(string? input)
    {
        if (string.IsNullOrWhiteSpace(input))
        {
            return null;
        }

        var normilizedInput = input.Trim();

        if (All.Select(x => x.Id.Trim()).Contains(normilizedInput, StringComparer.OrdinalIgnoreCase))
        {
            return All.FirstOrDefault(x =>string.Equals(x.Id.Trim(), normilizedInput, StringComparison.OrdinalIgnoreCase));
        }

        if (All.Select(x => x.Name.Trim()).Contains(normilizedInput, StringComparer.OrdinalIgnoreCase))
        {
            return All.FirstOrDefault(x => string.Equals(x.Name.Trim(), normilizedInput, StringComparison.OrdinalIgnoreCase));
        }

        return null;
    }

    /// <summary>
    /// Преобразование права доступа в строку
    /// </summary>
    /// <returns></returns>
    public override string ToString() => Name;
    
}
