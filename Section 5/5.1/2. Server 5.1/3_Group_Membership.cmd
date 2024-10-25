echo %date% %time% >> F:\AGSDeploy\Logs\Permissions.log 
echo Current Membership of localgroup administrators >> F:\AGSDeploy\Logs\Permissions.log 
net localgroup administrators >> F:\AGSDeploy\Logs\Permissions.log
echo Assigning Service Accounts to localadmins >> F:\AGSDeploy\Logs\Permissions.log 
net localgroup administrators domain\GISPortal /add
net localgroup administrators domain\GISBackup /add
net localgroup administrators domain\GISServer /add
net localgroup administrators domain\GISDataStore /add 
echo Updated Membership of localgroup administrators >> F:\AGSDeploy\Logs\Permissions.log 
net localgroup administrators >> F:\AGSDeploy\Logs\Permissions.log
echo %date% %time% >> F:\AGSDeploy\Logs\Permissions.log 
