using Azure.Identity;
using Azure.Messaging.WebPubSub;
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
            var endpoint = Environment.GetEnvironmentVariable("COSMOS_ENDPOINT");
            return new CosmosClient(endpoint, new DefaultAzureCredential());
        });

        services.AddSingleton((s) =>
        {
            var endpoint = Environment.GetEnvironmentVariable("WEBPUBSUB_ENDPOINT");
            var hubName = Environment.GetEnvironmentVariable("WEBPUBSUB_HUB");
            return new WebPubSubServiceClient(new Uri(endpoint), hubName, new DefaultAzureCredential());
        });
    })
    .Build();

host.Run();
