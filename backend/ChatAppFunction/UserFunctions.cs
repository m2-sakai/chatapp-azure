using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net;

namespace ChatAppFunction
{
    public class UserFunctions
    {
        private readonly CosmosClient _cosmosClient;
        private readonly Container _container;
        private readonly ILogger<UserFunctions> _logger;

        public UserFunctions(CosmosClient cosmosClient, ILogger<UserFunctions> logger)
        {
            _cosmosClient = cosmosClient;
            var database = _cosmosClient.GetDatabase("COSMOS_DATABASE");
            _container = database.GetContainer("COSMOS_CONTAINER"); ;
            _logger = logger;
        }

        [Function("GetUser")]
        public async Task<HttpResponseData> GetUser([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
        {
            string userId = req.Query["userId"];

            if (userId == null)
            {
                var httpResponse = req.CreateResponse(HttpStatusCode.NotFound);
                await httpResponse.WriteStringAsync("UserId is missing");
                return httpResponse;
            }

            try
            {
                ItemResponse<User> response = await _container.ReadItemAsync<User>(userId, new PartitionKey(userId));

                var httpResponse = req.CreateResponse(HttpStatusCode.OK);
                await httpResponse.WriteAsJsonAsync(response.Resource);
                return httpResponse;
            }
            catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
            {
                var httpResponse = req.CreateResponse(HttpStatusCode.NotFound);
                await httpResponse.WriteStringAsync("User not found");
                return httpResponse;
            }
        }

        [Function("InsertUser")]
        public async Task<HttpResponseData> InsertUser([HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req)
        {
            try
            {
                string requestBody;
                using (StreamReader reader = new StreamReader(req.Body))
                {
                    requestBody = await reader.ReadToEndAsync();
                }

                var user = JsonConvert.DeserializeObject<User>(requestBody);

                if (user == null || string.IsNullOrWhiteSpace(user.Id) || string.IsNullOrWhiteSpace(user.Email))
                {
                    var badResponse = req.CreateResponse(HttpStatusCode.BadRequest);
                    await badResponse.WriteStringAsync("Invalid user data.");
                    return badResponse;
                }

                ItemResponse<User> response = await _container.CreateItemAsync(user, new PartitionKey(user.Id));
                var successResponse = req.CreateResponse(HttpStatusCode.Created);
                await successResponse.WriteAsJsonAsync(response.Resource);
                return successResponse;
            }
            catch (JsonException ex)
            {
                _logger.LogError(ex, "JSON Deserialization Error");
                var errorResponse = req.CreateResponse(HttpStatusCode.BadRequest);
                await errorResponse.WriteStringAsync("Invalid JSON format.");
                return errorResponse;
            }
            catch (CosmosException ex)
            {
                _logger.LogError(ex, $"Cosmos DB Error: {ex.StatusCode}");
                var errorResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
                await errorResponse.WriteStringAsync($"Error inserting into Cosmos DB: {ex.Message}");
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

    public class User
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
    }
}