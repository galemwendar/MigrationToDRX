using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using MigrationToDRX.Data;
using MigrationToDRX.Data.Services;
using Radzen;
using Radzen.Blazor;
using Microsoft.AspNetCore.Http.Features;
using System.Diagnostics;
using NLog;
using NLog.Web;
using MigrationToDRX.Data.Helpers;


try
{
    System.Console.WriteLine("Starting...");
    var builder = WebApplication.CreateBuilder(args);
    System.Console.WriteLine("Configuring...");
    builder.Services.Configure<FormOptions>(options =>
    {
        options.MultipartBodyLengthLimit = 100 * 1024 * 1024; // 100 МБ
    });
    System.Console.WriteLine("Configuring services...");
    // Чтение настроек Kestrel из конфигурации
    var kestrelConfig = builder.Configuration.GetSection("Kestrel:Endpoints");
    builder.Logging.ClearProviders();
    builder.Logging.SetMinimumLevel(Microsoft.Extensions.Logging.LogLevel.Trace);
    builder.Host.UseNLog();
    var httpUrl = kestrelConfig["Http:Url"];
    //var httpsUrl = kestrelConfig["Https:Url"];


    // Add services to the container.
    builder.Services.AddRazorPages();
    builder.Services.AddServerSideBlazor();
    builder.Services.AddScoped<OdataClientService>();
    builder.Services.AddScoped<ODataEDocService>();
    builder.Services.AddScoped<EntityService>();
    builder.Services.AddScoped<EntityBuilderService>();
    builder.Services.AddScoped<ExcelService>();
    builder.Services.AddScoped<NotificationService>();
    builder.Services.AddScoped<DialogService>();
    builder.Services.AddScoped<ContextMenuService>();
    builder.Services.AddScoped<TooltipService>();
    builder.Services.AddScoped<FileService>();
    builder.Services.AddScoped<ActionService>();
    builder.Services.AddScoped<OperationService>();
    System.Console.WriteLine("Adding services...");
    var app = builder.Build();
    System.Console.WriteLine("Building...");
    // Configure the HTTP request pipeline.
    if (!app.Environment.IsDevelopment())
    {
        app.UseExceptionHandler("/Error");
    }

    //app.UseHttpsRedirection();

    app.UseStaticFiles();

    app.UseRouting();

    app.MapBlazorHub();
    app.MapFallbackToPage("/_Host");


    var urls = !string.IsNullOrEmpty(httpUrl) ? new[] { httpUrl } : new[] { "http://localhost:5000" };
    System.Console.WriteLine($"URL: {string.Join(", ", urls)}");
    builder.WebHost.UseUrls(urls);

    foreach (var url in urls)
    {
        Process.Start(new ProcessStartInfo
        {
            FileName = url,
            UseShellExecute = true
        });
    }

    Console.WriteLine("Starting web app on: " + string.Join(", ", urls));
    app.Run();
}
catch (Exception ex)
{
    System.Console.WriteLine(ex.Message);
    Console.ReadLine();
}
