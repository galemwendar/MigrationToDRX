using System.Data;
using System.Runtime.InteropServices;
using System.Text;
using ClosedXML.Excel;
using ExcelDataReader;
using OfficeOpenXml;
namespace MigrationToDRX.Data.Services;

/// <summary>
/// Сервис для чтения Excel файлов
/// </summary>
public class ExcelService
{
    /// <summary>
    /// Чтение Excel файла и преобразование в список словарей
    /// </summary>
    /// <param name="stream">Поток данных Excel файла</param>
    /// <returns>Список словарей, представляющих строки Excel файла</returns>
    public List<Dictionary<string, object>> ReadExcel(Stream stream)
    {
        if (SystemService.GetOSPlatform() == OSPlatform.Windows)
        {
            return ReadExcelWithExcelReader(stream);
        }

        return ReadExcelWithClosedXml(stream);
    }

    /// <summary>
    /// Чтение Excel файла с помощью ClosedXML и преобразование в список словарей
    /// </summary>
    /// <param name="stream">Поток данных Excel файла</param>
    /// <returns>Список словарей, представляющих строки Excel файла</returns>
    private static List<Dictionary<string, object>> ReadExcelWithClosedXml(Stream stream)
    {
        var result = new List<Dictionary<string, object>>();

        using var workbook = new XLWorkbook(stream);
        var worksheet = workbook.Worksheets.First();

        // Берем все строки с данными
        var rows = worksheet.RowsUsed();

        if (!rows.Any())
            return result;

        // Заголовки — из первой строки
        var headers = rows.First().Cells().Select(c => c.GetValue<string>() ?? string.Empty).ToList();

        // Обрабатываем все строки после заголовков
        foreach (var row in rows.Skip(1))
        {
            var dict = new Dictionary<string, object>();

            // Берем ячейки строго по индексам, чтобы не было смещения
            for (int i = 1; i <= headers.Count; i++) // 1-based индекс в XLWorkbook
            {
                var cell = row.Cell(i);
                dict[headers[i - 1]] = cell.IsEmpty() ? string.Empty : cell.GetValue<string>();
            }

            result.Add(dict);
        }

        return result;
    }


    /// <summary>
    /// Чтение Excel файла с помощью ExcelDataReader и преобразование в список словарей
    /// </summary>
    /// <param name="stream">Поток данных Excel файла</param>
    /// <returns>Список словарей, представляющих строки Excel файла</returns>
    private List<Dictionary<string, object>> ReadExcelWithExcelReader(Stream stream)
    {
        var result = new List<Dictionary<string, object>>();
        Encoding.RegisterProvider(System.Text.CodePagesEncodingProvider.Instance);

        using var reader = ExcelReaderFactory.CreateReader(stream, new ExcelReaderConfiguration
        {
            FallbackEncoding = Encoding.UTF8
        });

        var dataSet = reader.AsDataSet(new ExcelDataSetConfiguration
        {
            ConfigureDataTable = _ => new ExcelDataTableConfiguration
            {
                UseHeaderRow = true
            }
        });

        var table = dataSet.Tables[0]; // читаем только первый лист, как и в ClosedXml

        foreach (DataRow row in table.Rows)
        {
            var dict = new Dictionary<string, object>();
            foreach (DataColumn column in table.Columns)
            {
                dict[column.ColumnName] = row[column];
            }
            result.Add(dict);
        }

        return result;
    }

    /// <summary>
    /// Создает Excel-файл из списка словарей с данными
    /// </summary>
    /// <param name="rows"></param>
    /// <param name="columns"></param>
    /// <param name="sheetName"></param>
    /// <returns></returns>
    public byte[] GetExcelBytes(List<Dictionary<string, string>> rows, List<string> columns, string sheetName)
    {
        ExcelPackage.License.SetNonCommercialOrganization("ООО ЦВД"); //This will also set the Company property to the organization name provided in the argument.
        using var excelPackage = new ExcelPackage();
        var worksheet = excelPackage.Workbook.Worksheets.Add(sheetName);

        // Записываем заголовки
        for (int c = 0; c < columns.Count; c++)
        {
            worksheet.Cells[1, c + 1].Value = columns[c];
        }

        // Записываем данные
        for (int r = 0; r < rows.Count; r++)
        {
            for (int c = 0; c < columns.Count; c++)
            {
                rows[r].TryGetValue(columns[c], out var val);
                worksheet.Cells[r + 2, c + 1].Value = val;
            }
        }

        worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();

        return excelPackage.GetAsByteArray(); // Возвращаем массив байт вместо записи на диск
    }
}