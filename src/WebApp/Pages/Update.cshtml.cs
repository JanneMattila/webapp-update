using Microsoft.AspNetCore.Mvc.RazorPages;
using System;

namespace WebApp.Pages;

public class UpdateModel : PageModel
{
    public string MachineName { get; set; }
    public DateTime Started { get; set; }
    public TimeSpan Uptime { get; set; }
    public string AppEnvironment { get; set; }
    public string AppEnvironmentSticky { get; set; }

    public void OnGet()
    {
        MachineName = Environment.MachineName;
        Started = Program.Started;
        Uptime = DateTime.UtcNow - Started;
        AppEnvironment = Environment.GetEnvironmentVariable("AppEnvironment");
        AppEnvironmentSticky = Environment.GetEnvironmentVariable("AppEnvironmentSticky");
    }
}
