using Azure.Identity;

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddEnvironmentVariables();

var keyVaultName = builder.Configuration.GetValue<string>("keyVaultName");
var keyVaultUri = $"https://{keyVaultName}.vault.azure.net/";

builder.Configuration.AddAzureKeyVault(new Uri(keyVaultUri), new DefaultAzureCredential());

var app = builder.Build();

var secretName = builder.Configuration.GetValue<string>("secretName");
app.MapGet("/", (IConfiguration config) => $"Life, the Universe and everything = {config.GetValue<string>(secretName)}");

app.Run();
