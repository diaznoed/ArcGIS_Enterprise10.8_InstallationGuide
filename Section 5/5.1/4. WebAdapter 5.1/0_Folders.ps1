# PowerShell Script for Section 5.1 - Pre-Install Preparatory Steps

# Parameters - Fill these out before running the script
$portalAdminUserName = "domain\GISPortal"
$backupUserName = "domain\GISBackup"
$serverUserName = "domain\GISServer"
$dataStoreUserName = "domain\GISDataStore"
$fileServerPath = "\\fileshare\Software\Enterprise\V10-8-1\AGSDeploy\Software\ArcGISDataStore"
$destinationPath = "F:\AGSDeploy\Software"

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

# Establish Folder Structure
$folderStructureScript = @"
echo Establishing Folder Structure for GeoState Deployment >> F:\AGSDeploy\Logs\Folders.log
md F:\AGSDeploy\Software\Patches 
md F:\AGSDeploy\License
md F:\AGSDeploy\Configs
md F:\AGSDeploy\Certs
md F:\AGSDeploy\Logs
md F:\ArcGIS
echo Done >> F:\AGSDeploy\Logs\Folders.log
echo List of newly established folder structure >> F:\AGSDeploy\Logs\Folders.log
dir F:\AGSDeploy /s /b >> F:\AGSDeploy\Logs\Folders.log
dir F:\ArcGIS /s /b >> F:\AGSDeploy\Logs\Folders.log
"@
$folderStructureScriptPath = "F:\InstallScripts\5.1\1_Folder_Creation.cmd"
$folderStructureScript | Out-File -FilePath $folderStructureScriptPath -Encoding ASCII

# Assign Folder Privileges
$assignPrivilegesScript = @"
echo %date% %time% >> F:\AGSDeploy\Logs\Permissions.log 
echo Current Permissions for Service Account >> F:\AGSDeploy\Logs\Permissions.log
icacls "F:\AGSDeploy" >> F:\AGSDeploy\Logs\Permissions.log
icacls "F:\ArcGIS" >> F:\AGSDeploy\Logs\Permissions.log
echo Assigning Permissions for Service Account >> F:\AGSDeploy\Logs\Permissions.log 
icacls "F:\AGSDeploy" /grant "$portalAdminUserName":(OI)(CI)F /Q /C /T
icacls "F:\AGSDeploy" /grant "$backupUserName":(OI)(CI)F /Q /C /T
icacls "F:\AGSDeploy" /grant "$serverUserName":(OI)(CI)F /Q /C /T
icacls "F:\AGSDeploy" /grant "$dataStoreUserName":(OI)(CI)F /Q /C /T
icacls "F:\ArcGIS" /grant "$portalAdminUserName":(OI)(CI)F /Q /C /T
icacls "F:\ArcGIS" /grant "$backupUserName":(OI)(CI)F /Q /C /T
icacls "F:\ArcGIS" /grant "$serverUserName":(OI)(CI)F /Q /C /T
icacls "F:\ArcGIS" /grant "$dataStoreUserName":(OI)(CI)F /Q /C /T
echo Updated Permissions for Service Account >> F:\AGSDeploy\Logs\Permissions.log 
icacls "F:\AGSDeploy" >> F:\AGSDeploy\Logs\Permissions.log
icacls "F:\ArcGIS" >> F:\AGSDeploy\Logs\Permissions.log
echo %date% %time% >> F:\AGSDeploy\Logs\Permissions.log 
"@
$assignPrivilegesScriptPath = "F:\InstallScripts\5.1\2_Folder_Privileges.cmd"
$assignPrivilegesScript | Out-File -FilePath $assignPrivilegesScriptPath -Encoding ASCII

# Assign Local Administrator Group Membership
$assignLocalAdminsScript = @"
echo %date% %time% >> F:\AGSDeploy\Logs\Permissions.log 
echo Current Membership of localgroup administrators >> F:\AGSDeploy\Logs\Permissions.log 
net localgroup administrators >> F:\AGSDeploy\Logs\Permissions.log
echo Assigning Service Accounts to localadmins >> F:\AGSDeploy\Logs\Permissions.log 
net localgroup administrators $portalAdminUserName /add
net localgroup administrators $backupUserName /add
net localgroup administrators $serverUserName /add
net localgroup administrators $dataStoreUserName /add 
echo Updated Membership of localgroup administrators >> F:\AGSDeploy\Logs\Permissions.log 
net localgroup administrators >> F:\AGSDeploy\Logs\Permissions.log
echo %date% %time% >> F:\AGSDeploy\Logs\Permissions.log 
"@
$assignLocalAdminsScriptPath = "F:\InstallScripts\5.1\3_Group_Membership.cmd"
$assignLocalAdminsScript | Out-File -FilePath $assignLocalAdminsScriptPath -Encoding ASCII

# Copy Installation Files
$copyFilesScript = @"
:: Copy Installation Files
xcopy "$fileServerPath\*" "$destinationPath\" /s /e
"@
$copyFilesScriptPath = "F:\InstallScripts\5.1\4_Copy_Installation.cmd"
$copyFilesScript | Out-File -FilePath $copyFilesScriptPath -Encoding ASCII

# Run scripts sequentially
Run-CmdScript -scriptPath $folderStructureScriptPath
Run-CmdScript -scriptPath $assignPrivilegesScriptPath
Run-CmdScript -scriptPath $assignLocalAdminsScriptPath
Run-CmdScript -scriptPath $copyFilesScriptPath
