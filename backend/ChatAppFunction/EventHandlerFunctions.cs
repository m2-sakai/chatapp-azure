using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace ChatAppFunction
{
    public class EventHandlerFunctions
    {
        private readonly ILogger<EventHandlerFunctions> _logger;

        public EventHandlerFunctions(ILogger<EventHandlerFunctions> logger)
        {
            _logger = logger;
        }

        [Function("EventHandler")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            return new OkObjectResult("Welcome to Azure Functions! EventHandler");
        }
    }
}
