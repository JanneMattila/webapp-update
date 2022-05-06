using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.IO;
using System.Threading.Tasks;

namespace WebApp.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UpdateController : ControllerBase
{
    private readonly ILogger<UpdateController> _logger;
    private readonly IWebHostEnvironment _environment;

    public UpdateController(ILogger<UpdateController> logger, IWebHostEnvironment environment)
    {
        _logger = logger;
        _environment = environment;
    }

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var content = "No content";
        var releaseFile = Path.Join(_environment.WebRootPath, "release.txt");

        if (System.IO.File.Exists(releaseFile))
        {
            content = await System.IO.File.ReadAllTextAsync(releaseFile);
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
