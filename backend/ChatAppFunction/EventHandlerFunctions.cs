using Azure.Core;
using Azure.Messaging.WebPubSub;
using ChatAppFunction.Model;
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
        private readonly WebPubSubServiceClient _webPubSubServiceClient;
        private readonly ILogger<EventHandlerFunctions> _logger;

        public EventHandlerFunctions(CosmosClient cosmosClient, WebPubSubServiceClient webPubSubServiceClient, ILogger<EventHandlerFunctions> logger)
        {
            _cosmosClient = cosmosClient;
            var database = _cosmosClient.GetDatabase(Environment.GetEnvironmentVariable("COSMOS_DATABASE"));
            _container = database.GetContainer(Environment.GetEnvironmentVariable("COSMOS_CHAT_CONTAINER"));
            _webPubSubServiceClient = webPubSubServiceClient;
            _logger = logger;
        }

        [Function("SaveChatMessage")]
        public async Task<HttpResponseData> SaveChatMessage([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "chat")] HttpRequestData req)
        {
            _logger.LogInformation("Processing SaveChatMessage Functions.");

            var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            _logger.LogInformation($"{requestBody}");

            var data = JsonConvert.DeserializeObject<ChatMessage>(requestBody);

            if (data == null || string.IsNullOrEmpty(data.Id) || string.IsNullOrEmpty(data.Content) || string.IsNullOrEmpty(data.SenderEmail))
            {
                var badRequestResponse = req.CreateResponse(System.Net.HttpStatusCode.BadRequest);
                await badRequestResponse.WriteStringAsync("Invalid input");
                return badRequestResponse;
            }

            try
            {
                await _container.CreateItemAsync(data, new PartitionKey(data.SenderEmail));
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

        [Function("PublishSaveMessage")]
        [WebPubSubOutput(Hub = "chatroom")]
        public SendToAllAction PublishSaveMessage([WebPubSubTrigger("chatroom", WebPubSubEventType.User, "message")] UserEventRequest request)
        {
            _logger.LogInformation("Processing MessageEventHandler Functions.");
            _logger.LogInformation($"{request.Data.ToString()}");

            return new SendToAllAction
            {
                Data = BinaryData.FromString($"[{request.ConnectionContext.UserId}] {request.Data.ToString()}"),
                DataType = request.DataType
            };
        }
    }
}
