using ChatAppFunction.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace ChatAppFunction
{
    public class EventHandlerFunctions
    {
        private readonly CosmosClient _cosmosClient;
        private readonly Container _container;
        private readonly ILogger<EventHandlerFunctions> _logger;

        public EventHandlerFunctions(CosmosClient cosmosClient, ILogger<EventHandlerFunctions> logger)
        {
            _cosmosClient = cosmosClient;
            var database = _cosmosClient.GetDatabase(Environment.GetEnvironmentVariable("COSMOS_DATABASE"));
            _container = database.GetContainer(Environment.GetEnvironmentVariable("COSMOS_CHAT_CONTAINER"));
            _logger = logger;
        }

        [Function("SaveChatMessage")]
        public async Task<HttpResponseData> SaveChatMessage([HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req)
        {
            _logger.LogInformation("Processing SaveChatMessage Functions.");

            var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            var data = JsonConvert.DeserializeObject<ChatMessage>(requestBody);

            if (data == null || string.IsNullOrEmpty(data.Id) || string.IsNullOrEmpty(data.Content) || string.IsNullOrEmpty(data.SenderId))
            {
                var badRequestResponse = req.CreateResponse(System.Net.HttpStatusCode.BadRequest);
                await badRequestResponse.WriteStringAsync("Invalid input");
                return badRequestResponse;
            }

            data.Timestamp = DateTime.Now.ToString("o");

            try
            {
                await _container.CreateItemAsync(data, new PartitionKey(data.SenderId));
                var okResponse = req.CreateResponse(System.Net.HttpStatusCode.OK);
                await okResponse.WriteStringAsync("Message stored successfully");
                return okResponse;
            }
            catch (CosmosException ex)
            {
                _logger.LogError($"Error storing message: {ex.Message}");

                var errorResponse = req.CreateResponse(System.Net.HttpStatusCode.InternalServerError);
                await errorResponse.WriteStringAsync("Error storing message");
                return errorResponse;
            }
        }
    }
}
