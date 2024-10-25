# Parameters - Fill these out before running the script
$setupPath = "F:\AGSDeploy\Software\Software\WebAdaptorIIS\Setup.exe"
$patchPath = "F:\AGSDeploy\Software\Software\Patches\ArcGIS-1081-WAI-S-Patch.msp"
$certPath = "F:\AGSDeploy\Software\Cert\s1cfagisprt99.pfx"
$certPassword = ""
$certHash = ""
$websiteID = 1 # Update this to the correct WEBSITE_ID
$port = 80 # Update this to the correct PORT if necessary
$vdirectoryName = "portal"
$webAdaptorName = "portal"
$appcmdPath = "C:\Windows\System32\inetsrv\appcmd.exe"
$logFilePath = "F:\AGSDeploy\Logs\WebAdaptor_Install.log"
$configToolPath = "C:\Program Files (x86)\Common Files\ArcGIS\WebAdaptor\IIS\<current version>\Tools\ConfigureWebAdaptor.exe"
$webAdaptorURL = "https://webadaptorhost.domain.com/webadaptorname/webadaptor"
$serverMachineName = "server.domain.com"
$adminUsername = "siteadmin"
$adminPassword = "secret"
$adminAccessEnabled = "false"

# Paths to CMD scripts
$folderCreationScript = "F:\InstallScripts\5.1\1_Folder_Creation.cmd"
$folderPrivilegesScript = "F:\InstallScripts\5.1\2_Folder_Privileges.cmd"
$groupMembershipScript = "F:\InstallScripts\5.1\3_Group_Membership.cmd"
$copyInstallationScript = "F:\InstallScripts\5.1\4_Copy_Installation.cmd"

# Function to log messages
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Write-Host $logMessage
    Add-Content -Path $logFilePath -Value $logMessage
}

# Ensure log directory exists
$logDirectory = [System.IO.Path]::GetDirectoryName($logFilePath)
if (-not (Test-Path $logDirectory)) {
    New-Item -Path $logDirectory -ItemType Directory -Force
}

# Function to run CMD scripts with admin privileges
function Run-CmdScript {
    param (
        [string]$scriptPath
    )

    Log-Message "Running CMD script: $scriptPath"
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = "cmd.exe"
    $processInfo.Arguments = "/c `"$scriptPath`""
    $processInfo.Verb = "runas"
    $processInfo.UseShellExecute = $true

    $process = [System.Diagnostics.Process]::Start($processInfo)
    $process.WaitForExit()
    Log-Message "Finished running CMD script: $scriptPath"
}

# Function to run appcmd.exe with admin privileges
function Run-AppCmd {
    param (
        [string]$arguments
    )

    Log-Message "Running appcmd.exe with arguments: $arguments"
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $appcmdPath
    $processInfo.Arguments = $arguments
    $processInfo.Verb = "runas"
    $processInfo.UseShellExecute = $true

    $process = [System.Diagnostics.Process]::Start($processInfo)
    $process.WaitForExit()
    Log-Message "Finished running appcmd.exe with arguments: $arguments"
    return $process.ExitCode
}

# Ensure the PowerShell script runs with highest admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Log-Message "This script must be run as an administrator!"
    Start-Process powershell.exe "-File $PSCommandPath" -Verb RunAs
    exit
}

# Verify appcmd.exe path
if (-Not (Test-Path $appcmdPath)) {
    Log-Message "appcmd.exe not found at $appcmdPath. Please verify the path and try again."
    exit 1
}

# Run scripts sequentially
Run-CmdScript -scriptPath $folderCreationScript
Run-CmdScript -scriptPath $folderPrivilegesScript
Run-CmdScript -scriptPath $groupMembershipScript
Run-CmdScript -scriptPath $copyInstallationScript

# Install the Web Adapter
Log-Message "Starting Web Adaptor installation..."
Start-Process -FilePath "$setupPath" -ArgumentList "/quiet WEBSITE_ID=$websiteID PORT=$port VDIRNAME=$vdirectoryName CONFIGUREIIS=TRUE" -Wait -NoNewWindow
Log-Message "Finished Web Adaptor installation."

# Apply the Patch
Log-Message "Applying Web Adaptor patch..."
Start-Process -FilePath "msiexec.exe" -ArgumentList "/p `"$patchPath`" /quiet" -Wait -NoNewWindow
Log-Message "Finished applying Web Adaptor patch."

# Configure IIS
Log-Message "Configuring IIS..."
$exitCode = Run-AppCmd "list site /name:`"$websiteName`""
if ($exitCode -ne 0) {
    Log-Message "The specified website does not exist. Please check the website name and try again."
    exit 1
}
Log-Message "IIS configuration completed."

# Ensure IIS is running
Log-Message "Starting IIS..."
iisreset /start
Log-Message "IIS started."

# Bind the SSL certificate to port 443 with AES256-SHA256 encryption
Log-Message "Binding SSL certificate..."
netsh http add sslcert ipport=0.0.0.0:443 certhash=$certHash appid="{00112233-4455-6677-8899-AABBCCDDEEFF}" certstorename=MY
if ($LASTEXITCODE -ne 0) {
    Log-Message "Failed to bind SSL certificate. Please check the certificate hash and try again."
    exit 1
}
Log-Message "SSL certificate bound successfully."

# Configure the Web Adaptor for Portal for ArcGIS using command line utility
Log-Message "Configuring Web Adaptor for Portal for ArcGIS using command line utility..."
Start-Process -FilePath "$configToolPath" -ArgumentList "/m server /w $webAdaptorURL /g $serverMachineName /u $adminUsername /p $adminPassword /a $adminAccessEnabled" -Wait -NoNewWindow
if ($LASTEXITCODE -ne 0) {
    Log-Message "Failed to configure Web Adaptor for Portal for ArcGIS. Please check the parameters and try again."
    exit 1
}
Log-Message "Web Adaptor for Portal for ArcGIS configured successfully."

Log-Message "Web Adaptor for Portal for ArcGIS installation and configuration completed."
