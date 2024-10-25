# PowerShell Script for Section 5.4 - Install ArcGIS Data Store Software

# Parameters - Fill these out before running the script
$dataStoreAdminUserName = "domain\GisDataStore"
$dataStoreAdminPassword = ""
$networkPath = "\\fileshare\Software\Enterprise\V10-8-1\AGSDeploy\Software\ArcGISDataStore"

# Function to run CMD scripts with admin privileges
function Run-CmdScript {
    param (
        [string]$scriptPath
    )

    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = "cmd.exe"
    $processInfo.Arguments = "/c `"$scriptPath`""
    $processInfo.Verb = "runas"
    $processInfo.UseShellExecute = $true

    $process = [System.Diagnostics.Process]::Start($processInfo)
    $process.WaitForExit()
}

# Ensure the PowerShell script runs with highest admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as an administrator!"
    Start-Process powershell.exe "-File $PSCommandPath" -Verb RunAs
    exit
}

# Check network path availability
if (Test-Path -Path $networkPath) {
    Write-Host "Network path is accessible. Proceeding with the installation."

    # Script paths
    $establishPortsScript = "F:\InstallScripts\5.4\1_ADS_PortRules.cmd"
    $installDataStoreScript = "F:\InstallScripts\5.4\2_ADS_Install.cmd"
    $installPatchScript = "F:\InstallScripts\5.4\3_ADS_Patches.cmd"
    $checkNTServiceScript = "F:\InstallScripts\5.4\4_ADS_Check.cmd"

    # Run scripts sequentially
    Run-CmdScript -scriptPath $establishPortsScript
    Run-CmdScript -scriptPath $installDataStoreScript
    Run-CmdScript -scriptPath $installPatchScript
    Run-CmdScript -scriptPath $checkNTServiceScript
} else {
    Write-Error "Network path is not accessible. Please check the network path and try again."
}
