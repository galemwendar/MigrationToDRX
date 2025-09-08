using System.Data;
using System.Runtime.InteropServices;
using System.Text;
using ClosedXML.Excel;
using ExcelDataReader;
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
        var rows = worksheet.RowsUsed();

        var headers = rows.First().Cells().Select(c => c.Value.ToString()).ToList();

        foreach (var row in rows.Skip(1))
        {
            var dict = new Dictionary<string, object>();
            var cells = row.Cells().ToList();
            for (int i = 0; i < headers.Count && i < cells.Count; i++)
            {
                dict[headers[i]] = cells[i].Value;
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

    // public void WriteExcrlFile(DataTable dataTable, string entitySetName)
    // {
    //     // Создайте новый Excel-файл и сохраните в него данные с помощью EPPlus
    //     using (ExcelPackage excelPackage = new ExcelPackage())
    //     {
    //         // Добавьте рабочую книгу
    //         var worksheet = excelPackage.Workbook.Worksheets.Add(entitySetName);

    //         // Запишите данные из dataTable в Excel-файл
    //         worksheet.Cells["A1"].LoadFromDataTable(dataTable, true);

    //         // Укажите путь для сохранения нового файла
    //         string newFilePath = $"{entitySetName}_{DateTime.Now.ToShortDateString}.xlsx";

    //         // Сохраните новый Excel-файл
    //         File.WriteAllBytes(newFilePath, excelPackage.GetAsByteArray());
    //     }
    // }
}