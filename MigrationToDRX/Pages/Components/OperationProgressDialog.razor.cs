using System;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Radzen;

namespace MigrationToDRX.Pages.Components;

public partial class OperationProgressDialog : ComponentBase
{

    [Parameter]
    public int Total { get; set; }

    [Parameter]
    public EventCallback Cancel { get; set; }

    [Parameter]
    public Action<Action<int>>? RegisterProgressHandler { get; set; }

    protected string Unit => $" / {Total}";

    private int progress { get; set; }

    protected override void OnInitialized()
    {
        RegisterProgressHandler?.Invoke(UpdateProgress);
    }

    private void UpdateProgress(int value)
    {
        progress = value;
        InvokeAsync(StateHasChanged);
    }

    private async Task OnCancelClicked(MouseEventArgs args)
    {
        if (Cancel.HasDelegate)
        {
            await Cancel.InvokeAsync();
        }
    }
}
