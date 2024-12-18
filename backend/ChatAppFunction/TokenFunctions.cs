using Azure.Messaging.WebPubSub;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using System.Net;
using ChatAppFunction.Model;
using System.Web;
using System;

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
        public async Task<HttpResponseData> GetToken([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "token")] HttpRequestData req)
        {
            _logger.LogInformation("Processing GetToken Functions.");

            var url = await _webPubSubServiceClient.GetClientAccessUriAsync();
            var query = HttpUtility.ParseQueryString(url.Query);
            string accessToken = query["access_token"];

            var response = req.CreateResponse(HttpStatusCode.OK);
            var res = new TokenResponse()
            {
                AccessToken = accessToken
            };
            await response.WriteAsJsonAsync(res);
            return response;
        }
    }
}
