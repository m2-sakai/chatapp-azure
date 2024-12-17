using Azure.Messaging.WebPubSub;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using System.Net;
using ChatAppFunction.Model;

namespace ChatAppFunction
{
    public class TokenFunctions
    {
        private readonly ILogger<TokenFunctions> _logger;
        private readonly WebPubSubServiceClient _webPubSubServiceClient;

        public TokenFunctions(WebPubSubServiceClient webPubSubServiceClient, ILogger<TokenFunctions> logger)
        {
            _webPubSubServiceClient = webPubSubServiceClient;
            _logger = logger;
        }

        [Function("GetToken")]
        public async Task<HttpResponseData> GetToken([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
        {
            _logger.LogInformation("Processing GetToken Functions.");

            var url = await _webPubSubServiceClient.GetClientAccessUriAsync();

            var response = req.CreateResponse(HttpStatusCode.OK);
            var res = new TokenResponse()
            {
                Url = url.ToString()
            };
            await response.WriteAsJsonAsync(res);
            return response;
        }
    }
}
