using System;
using System.ComponentModel;
using Microsoft.AspNetCore.Components;
using MigrationToDRX.Data.Models.ViewModels;
using MigrationToDRX.Data.Services;
using Radzen;

namespace MigrationToDRX.Pages.Components;

public partial class ConnectionComponent : ComponentBase
{
    /// <summary>
    /// Модель отображения сущности региона со страной
    /// </summary>
    public ConnectionViewModel Model { get; set; } = new ConnectionViewModel();

    [Inject]
    private OdataClientService? OdataClientService { get; set; }

    [Inject]
    private NotificationService? NotificationService { get; set; }

    [Inject]
    private NavigationManager? NavigationManager { get; set; }

    private async Task SubmitAsync()
    {
       var sucsess = OdataClientService != null && await OdataClientService.SetConnection(Model.Url!, Model.UserName!, Model.Password!);

        if (sucsess)
        {
            //NavigationManager?.NavigateTo("/mainpage"); import
            
            NavigationManager?.NavigateTo("/main"); 
        }
        else
        {
            NotificationService?.Notify(new NotificationMessage
            {
                Severity = NotificationSeverity.Error,
                Summary = "Ошибка",
                Detail = "Не удалось подключиться к серверу, проверьте введенные данные и попробуйте еще раз",
                Duration = 20000
            });
        }
    }
}
