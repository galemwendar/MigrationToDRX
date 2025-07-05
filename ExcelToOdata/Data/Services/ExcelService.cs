using System.Data;
using ClosedXML.Excel;
namespace ExcelToOdata.Data.Services;

public class ExcelService
{

    public List<Dictionary<string, object>> ReadExcelClosedXml(Stream stream)
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

    // public DataSet ReadExcelToDataTable(Stream stream)
    // {
    //     var encoding = Encoding.GetEncoding("UTF-8");
    //     using (var reader = ExcelReaderFactory.CreateReader(stream, new ExcelReaderConfiguration
    //     {
    //         FallbackEncoding = encoding
    //     }))
    //     {
    //         var result = reader.AsDataSet(new ExcelDataSetConfiguration()
    //         {
    //             ConfigureDataTable = (_) => new ExcelDataTableConfiguration()
    //             {
    //                 UseHeaderRow = true
    //             }
    //         });

    //         return result;
    //     }
    // }

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