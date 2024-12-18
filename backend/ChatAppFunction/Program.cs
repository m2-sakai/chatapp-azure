using Azure.Identity;
using Azure.Messaging.WebPubSub;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

var host = new HostBuilder()
    .ConfigureFunctionsWebApplication()
    .ConfigureServices(services =>
    {
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();

        services.AddSingleton((s) =>
        {
            var isConnectMsi = Boolean.Parse(Environment.GetEnvironmentVariable("COSMOS_CONNECT_MSI"));
            if (isConnectMsi)
            {
                var endpoint = Environment.GetEnvironmentVariable("COSMOS_ENDPOINT");
                return new CosmosClient(endpoint, new DefaultAzureCredential());

            } else
            {
                var connectionString = Environment.GetEnvironmentVariable("COSMOS_CONNECTION_STRING");
                return new CosmosClient(connectionString);
            }
        });

        services.AddSingleton((s) =>
        {
            var isConnectMsi = Boolean.Parse(Environment.GetEnvironmentVariable("WEBPUBSUB_CONNECT_MSI"));
            var endpoint = Environment.GetEnvironmentVariable("WEBPUBSUB_ENDPOINT");
            var hubName = Environment.GetEnvironmentVariable("WEBPUBSUB_HUB");
            if (isConnectMsi)
            {
                return new WebPubSubServiceClient(new Uri(endpoint), hubName, new DefaultAzureCredential());
            }
            else
            {
                var accessKey = Environment.GetEnvironmentVariable("WEBPUBSUB_ACCESSKEY");
                return new WebPubSubServiceClient(new Uri(endpoint), hubName, new Azure.AzureKeyCredential(accessKey));
            }
        });
    })
    .ConfigureLogging(logging =>
    {
        logging.SetMinimumLevel(LogLevel.Trace);
        logging.Services.Configure<LoggerFilterOptions>(options =>
        {
            var defaultRule = options.Rules.FirstOrDefault(rule => rule.ProviderName == "Microsoft.Extensions.Logging.ApplicationInsights.ApplicationInsightsLoggerProvider");
            if (defaultRule is not null)
            {
                options.Rules.Remove(defaultRule);
            }
        });
    })

    .Build();

host.Run();
