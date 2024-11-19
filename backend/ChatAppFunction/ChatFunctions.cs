using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace ChatAppFunction
{
    public class ChatFunctions
    {
        private readonly ILogger<ChatFunctions> _logger;

        public ChatFunctions(ILogger<ChatFunctions> logger)
        {
            _logger = logger;
        }

        [Function("GetChats")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            return new OkObjectResult("Welcome to Azure Functions! GetChats");
        }
    }
}
