Param (
    [Parameter(HelpMessage = "Target resource group")] 
    [string] $ResourceGroupName = "rg-bicep-slots",

    [Parameter(HelpMessage = "Target app service")] 
    [string] $AppName = "contoso00000000020",

    [Parameter(HelpMessage = "Deployment source slot name")] 
    [string] $Slot = "staging",
    
    [Parameter(HelpMessage = "Deployment version")] 
    [string] $TargetVersion
)

$ErrorActionPreference = "Stop"

$slotApp = Get-AzWebAppSlot -ResourceGroupName $ResourceGroupName -Name $AppName -Slot $Slot
$url = "https://$($slotApp.HostNames[0])/release.txt"

# Reset source slot status
Switch-AzWebAppSlot `
    -ResourceGroupName $ResourceGroupName `
    -Name $AppName `
    -SourceSlotName $Slot `
    -SwapWithPreviewAction ResetSlotSwap `
    -Verbose

# Apply configuration changes
Switch-AzWebAppSlot `
    -ResourceGroupName $ResourceGroupName `
    -Name $AppName `
    -SourceSlotName $Slot `
    -DestinationSlotName Production `
    -SwapWithPreviewAction ApplySlotConfig `
    -Verbose

if ($TargetVersion.Length -gt 0) {
    # Wait for release to match the expected version
    while ($true) {
        $response = Invoke-WebRequest -Method GET -Uri $url -DisableKeepAlive
        if ($response.StatusCode -ne 200) {
            Write-Output "Waiting for slot to start"
        }
        else {
            if ($TargetVersion -eq $response.Content.Trim()) {
                Write-Output "Target version found. Continue swap operation."
                break
            }
            else {
                Write-Output "Waiting for target version."
            }
        }
        Start-Sleep -Seconds 1
    }
}

# Complete the swap
Switch-AzWebAppSlot `
    -ResourceGroupName $ResourceGroupName `
    -Name $AppName `
    -SourceSlotName $Slot `
    -DestinationSlotName Production `
    -SwapWithPreviewAction CompleteSlotSwap `
    -Verbose
