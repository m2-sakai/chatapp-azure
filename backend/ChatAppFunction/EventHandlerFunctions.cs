using Azure.Core;
using Azure.Messaging.WebPubSub;
using ChatAppFunction.Model;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net;

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

        [Function("PublishSaveMessage")]
        [WebPubSubOutput(Hub = "chatroom")]
        public async Task<UserEventResponse> PublishSaveMessage([WebPubSubTrigger("chatroom", WebPubSubEventType.User, "message")] UserEventRequest request)
        {
            _logger.LogInformation("Processing MessageEventHandler Functions.");
            _logger.LogInformation(request.Data.ToString());

            var message = JsonConvert.DeserializeObject<ChatMessage>(request.Data.ToString());

            try
            {
                // DBにチャットメッセージを保存
                await _container.CreateItemAsync(message, new PartitionKey(message.SenderEmail));

                // ブロードキャスト
                await _webPubSubServiceClient.SendToAllAsync(RequestContent.Create(message), ContentType.ApplicationJson);
            }
            catch (JsonException ex)
            {
                _logger.LogError(ex, "JSON Deserialization Error");
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error storing message: {ex.Message}");
            }

            return new UserEventResponse
            {
            };
        }

        // テスト用ブロードキャスト用Functions
        [Function("PostChat")]
        public async Task<HttpResponseData> PostChats([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "chat")] HttpRequestData req)
        {
            _logger.LogInformation("Processing PostChat Functions.");

            try
            {
                string requestBody;
                using (StreamReader reader = new StreamReader(req.Body))
                {
                    requestBody = await reader.ReadToEndAsync();
                }

                var message = JsonConvert.DeserializeObject<ChatMessage>(requestBody);

                await _webPubSubServiceClient.SendToAllAsync(RequestContent.Create(message), ContentType.ApplicationJson);

                var successResponse = req.CreateResponse(HttpStatusCode.Created);
                return successResponse;
            }
            catch (JsonException ex)
            {
                _logger.LogError(ex, "JSON Deserialization Error");
                var errorResponse = req.CreateResponse(HttpStatusCode.BadRequest);
                await errorResponse.WriteStringAsync("Invalid JSON format.");
                return errorResponse;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error");
                var errorResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
                await errorResponse.WriteStringAsync("An unexpected error occurred.");
                return errorResponse;
            }
        }
    }
}
