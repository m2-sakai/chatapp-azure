using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace ChatAppFunction
{
    public class GetUser
    {
        private readonly ILogger<GetUser> _logger;

        public GetUser(ILogger<GetUser> logger)
        {
            _logger = logger;
        }

        [Function("GetUser")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            return new OkObjectResult("Welcome to Azure Functions! GetUser");
        }
    }
}
