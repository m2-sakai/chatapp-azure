using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var host = new HostBuilder()
    .ConfigureFunctionsWebApplication()
    .ConfigureServices(services =>
    {
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();

        services.AddSingleton((s) =>
        {
            var connectionString = Environment.GetEnvironmentVariable("COSMOS_CONNECTION_STRING");
            return new CosmosClient(connectionString);
        });
    })
    .Build();

host.Run();
