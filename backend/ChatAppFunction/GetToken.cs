using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace ChatAppFunction
{
    public class GetToken
    {
        private readonly ILogger<GetToken> _logger;

        public GetToken(ILogger<GetToken> logger)
        {
            _logger = logger;
        }

        [Function("GetToken")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            return new OkObjectResult("Welcome to Azure Functions! GetToken");
        }
    }
}
