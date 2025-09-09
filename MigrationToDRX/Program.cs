using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using MigrationToDRX.Data;
using MigrationToDRX.Data.Services;
using Radzen;
using Radzen.Blazor;
using Microsoft.AspNetCore.Http.Features;

var builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<FormOptions>(options =>
{
    options.MultipartBodyLengthLimit = 100 * 1024 * 1024; // 100 МБ
});

// Чтение настроек Kestrel из конфигурации
var kestrelConfig = builder.Configuration.GetSection("Kestrel:Endpoints");
var httpUrl = kestrelConfig["Http:Url"];
var httpsUrl = kestrelConfig["Https:Url"];


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

var app = builder.Build();

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


app.Run();
