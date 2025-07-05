using System;
using System.Data;
using System.Dynamic;
using ExcelToOdata.Data.Models;
using ExcelToOdata.Data.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.OData.Edm;
using Radzen;

namespace ExcelToOdata.Pages;

public partial class MainPage
{
    List<ExpandoObject> items = new();
    List<string> columns = new();

        // Сопоставления ExcelКолонка -> EntitySetСвойство
    Dictionary<string, string> columnMapping = new();

    private bool IsConnected => OdataClientService?.IsConnected ?? false;

    [Inject]
    private OdataClientService? OdataClientService { get; set; }

    [Inject]
    private NotificationService? NotificationService { get; set; }

    [Inject]
    private ExcelService? ExcelService { get; set; }

    private List<string> ExcelHeaders { get; set; } = new();
    private List<EdmxField> EdmxFields { get; set; } = new();
    private string? SelectedEntitySetName { get; set; }
    private Dictionary<string, string> FieldMap { get; set; } = new();
    private List<IEdmEntitySet> EntitySets { get; set; } = new();
    private List<EdmxField> EntityProperties = new();

    protected override async Task OnInitializedAsync()
    {
        if (OdataClientService != null && OdataClientService.IsConnected)
        {
            EntitySets = await OdataClientService.GetEntitySetsAsync();
        }

        await base.OnInitializedAsync();
    }

    private async Task OnSelectChanged()
    {
        if (!string.IsNullOrWhiteSpace(SelectedEntitySetName))
        {
            EntityProperties = await OdataClientService!.GetPropertiesOfEntitySetAsync(SelectedEntitySetName);
        }

        StateHasChanged();
    }

    private async Task OnFileUpload(UploadChangeEventArgs args)
    {
        var file = args.Files.FirstOrDefault();
        if (file != null)
        {
            using var stream = new MemoryStream();
            await file.OpenReadStream().CopyToAsync(stream);
            stream.Position = 0;

            var dictList = ExcelService!.ReadExcelClosedXml(stream);

            columns = dictList.FirstOrDefault()?.Keys.ToList() ?? new();
            items = dictList.Select(dict =>
            {
                var expando = new ExpandoObject();
                var expandoDict = (IDictionary<string, object>)expando!;
                foreach (var kv in dict)
                    expandoDict[kv.Key] = kv.Value;
                return expando;
            }).ToList();

            // Инициализация словаря с пустыми значениями
            foreach (var col in columns)
            {
                if (!columnMapping.ContainsKey(col))
                    columnMapping[col] = null;
            }
        }
    }
}
