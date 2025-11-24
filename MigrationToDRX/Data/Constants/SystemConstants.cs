using System;

namespace MigrationToDRX.Data.Constants;

/// <summary>
/// Системные константы
/// </summary>
public class SystemConstants
{   
    /// <summary>
    /// Максимальный размер файла Excel
    /// </summary>
    public const int MaxExcelFileSize = 100 * 1024 * 1024; // 100Mb
    
    /// <summary>
    /// Строка для наименования колонки
    /// </summary>
    public const string IdColumnResult = "Идентификатор сущности";
}
