param (
    [Parameter(Mandatory = $true)] 
    [string] $Url,
    [int] 
    $Delay = 10,
    
    [int] 
    $Count = 99999,
    
    [int] 
    $TimeoutValue = 99999
)

$ErrorActionPreference = "Stop"

$previous = {}
$previousVersion = Get-Date
$message = "Starting"
For ($i = 0; $i -lt $Count; $i++) {
    $progressTime = (Get-Date) - $previousVersion
    Write-Progress -Activity $message -Status "$Delay ms" -SecondsRemaining  $progressTime.TotalSeconds

    $startTime = Get-Date
    try {
        $response = Invoke-RestMethod -Method GET -Uri $Url -DisableKeepAlive -TimeoutSec 1
        if ($response.content -ne $previous.content) {
            "$($startTime): $($startTime - $previousVersion)"
            $response
            $previous = $response
            $previousVersion = Get-Date
            $message = "Online"
        }
    }
    catch {
        if ([string]::IsNullOrWhiteSpace($previous.content) -eq $false) {
            "$($startTime): $($startTime - $previousVersion) -> Offline"

            $previous = {}
            $previousVersion = Get-Date
            $message = "Offline"
        }
    }

    if ([Console]::KeyAvailable) {
        $pressedKey = [Console]::ReadKey($true)
        $change = $Delay * 0.1
        if ($change -lt 1) {
            $change = 1
        }
        switch ($pressedKey.Key) {
            UpArrow {
                $Delay += $change
            }
            DownArrow {
                $Delay -= $change
                if (0 -gt $Delay) {
                    $Delay = 0
                }
            }
            Default {}
        }
    }

    Start-Sleep -Milliseconds $Delay
}
