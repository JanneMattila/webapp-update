using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;

namespace WebApp.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UpdateController : ControllerBase
{
    private readonly ILogger<UpdateController> _logger;

    public UpdateController(ILogger<UpdateController> logger)
    {
        _logger = logger;
    }

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var content = "No content";
        const string exampleFile = "example.txt";

        if (System.IO.File.Exists(exampleFile))
        {
            content = await System.IO.File.ReadAllTextAsync(exampleFile);
        }
        return new OkObjectResult(new
        {
            MachineName = Environment.MachineName,
            Started = Program.Started,
            Uptime = DateTime.UtcNow - Program.Started,
            AppEnvironment = Environment.GetEnvironmentVariable("AppEnvironment"),
            AppEnvironmentSticky = Environment.GetEnvironmentVariable("AppEnvironmentSticky"),
            Content = content
        });
    }
}
