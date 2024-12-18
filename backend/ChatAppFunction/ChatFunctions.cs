using Microsoft.AspNetCore.Http;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using System.Net;
using ChatAppFunction.Model;
using Azure.Messaging.WebPubSub;
using Azure.Core;
using Newtonsoft.Json;

namespace ChatAppFunction
{
    public class ChatFunctions
    {
        private readonly CosmosClient _cosmosClient;
        private readonly Container _container;
        private readonly WebPubSubServiceClient _webPubSubServiceClient;
        private readonly ILogger<ChatFunctions> _logger;

        public ChatFunctions(CosmosClient cosmosClient, WebPubSubServiceClient webPubSubServiceClient, ILogger<ChatFunctions> logger)
        {
            _cosmosClient = cosmosClient;
            var database = _cosmosClient.GetDatabase(Environment.GetEnvironmentVariable("COSMOS_DATABASE"));
            _container = database.GetContainer(Environment.GetEnvironmentVariable("COSMOS_CHAT_CONTAINER"));
            _webPubSubServiceClient = webPubSubServiceClient;
            _logger = logger;
        }

        [Function("GetChats")]
        public async Task<HttpResponseData> GetChats([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "chats")] HttpRequestData req)
        {
            _logger.LogInformation("Processing GetChats Functions.");

            var query = new QueryDefinition("SELECT * FROM c");
            var iterator = _container.GetItemQueryIterator<ChatMessage>(query);
            var chats = new List<ChatMessage>();

            while (iterator.HasMoreResults)
            {
                foreach (var chat in await iterator.ReadNextAsync())
                {
                    chats.Add(chat);
                }
            }

            var response = req.CreateResponse(HttpStatusCode.OK);
            await response.WriteAsJsonAsync(chats);
            return response;
        }
    }
}
