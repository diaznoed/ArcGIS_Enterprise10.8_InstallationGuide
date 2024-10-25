# PowerShell Script for Section 5.2 - ArcGIS Enterprise 10.8.1 Installation

# Parameters - Fill these out before running the script
$portalAdminUserName = "domain\GISPortal"
$portalAdminPassword = ""

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

# Script paths
$establishPortsScript = "F:\InstallScripts\5.2\1_PRT_PortRules.cmd"
$installPortalScript = "F:\InstallScripts\5.2\2_PRT_Install.cmd"
$installWebStylesScript = "F:\InstallScripts\5.2\3_PRT_WebStyle_Install.cmd"
$installPatchScript = "F:\InstallScripts\5.2\4_PRT_Patches.cmd"
$checkNTServiceScript = "F:\InstallScripts\5.2\5_PRT_Check.cmd"

# Run scripts sequentially
Run-CmdScript -scriptPath $establishPortsScript
Run-CmdScript -scriptPath $installPortalScript
Run-CmdScript -scriptPath $installWebStylesScript
Run-CmdScript -scriptPath $installPatchScript
Run-CmdScript -scriptPath $checkNTServiceScript