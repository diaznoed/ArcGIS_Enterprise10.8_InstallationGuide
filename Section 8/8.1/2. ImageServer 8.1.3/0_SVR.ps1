# PowerShell Script for Section 5.3 - Install ArcGIS Server Software

# Parameters - Fill these out before running the script
$serverAdminUserName = "domain\GisServer"
$serverAdminPassword = ""
$licenseFilePath = "F:\AGSDeploy\License\authorization.ecp"
$sqlClientInstallerPath = "F:\AGSDeploy\Software\msodbcsql.msi"

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
$establishPortsScript = "F:\InstallScripts\Section 8\8.1\2. ImageServer 8.1.3\1_SVR_PortRules.cmd"
$installServerScript = "F:\InstallScripts\Section 8\8.1\2. ImageServer 8.1.3\2_SVR_Install.cmd"
$licenseServerScript = "F:\InstallScripts\Section 8\8.1\2. ImageServer 8.1.3\3_SVR_License.cmd"
$installPatchScript = "F:\InstallScripts\Section 8\8.1\2. ImageServer 8.1.3\4_SVR_Patches.cmd"
$checkServerScript = "F:\InstallScripts\Section 8\8.1\2. ImageServer 8.1.3\5_SVR_Check.cmd"
$installSQLClientScript = "F:\InstallScripts\Section 8\8.1\2. ImageServer 8.1.3\6_SVR_SQL.cmd"

# Run scripts sequentially
Run-CmdScript -scriptPath $establishPortsScript
Run-CmdScript -scriptPath $installServerScript
Run-CmdScript -scriptPath $licenseServerScript
Run-CmdScript -scriptPath $installPatchScript
Run-CmdScript -scriptPath $checkServerScript
Run-CmdScript -scriptPath $installSQLClientScript
