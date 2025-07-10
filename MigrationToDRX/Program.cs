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

// Add services to the container.
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddScoped<OdataClientService>();
builder.Services.AddScoped<ODataEDocService>();
builder.Services.AddScoped<ExcelService>();
builder.Services.AddScoped<NotificationService>();
builder.Services.AddScoped<DialogService>();
builder.Services.AddScoped<ContextMenuService>();
builder.Services.AddScoped<TooltipService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
 //   app.UseHsts();
}

//app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();
