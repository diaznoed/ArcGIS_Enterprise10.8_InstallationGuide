echo %date% %time% >> F:\AGSDeploy\Logs\Permissions.log 
echo Current Permissions for Service Account >> F:\AGSDeploy\Logs\Permissions.log
icacls "F:\AGSDeploy" >> F:\AGSDeploy\Logs\Permissions.log
icacls "F:\ArcGIS" >> F:\AGSDeploy\Logs\Permissions.log
echo Assigning Permissions for Service Account >> F:\AGSDeploy\Logs\Permissions.log 
icacls "F:\AGSDeploy" /grant "domain\Portal":(OI)(CI)F /Q /C /T
icacls "F:\AGSDeploy" /grant "domain\Backup":(OI)(CI)F /Q /C /T
icacls "F:\AGSDeploy" /grant "domain\GISServer":(OI)(CI)F /Q /C /T
icacls "F:\AGSDeploy" /grant "domain\GISDataStore":(OI)(CI)F /Q /C /T
icacls "F:\ArcGIS" /grant "domain\GISPortal":(OI)(CI)F /Q /C /T
icacls "F:\ArcGIS" /grant "domain\GISBackup":(OI)(CI)F /Q /C /T
icacls "F:\ArcGIS" /grant "domain\GISServer":(OI)(CI)F /Q /C /T
icacls "F:\ArcGIS" /grant "domain\DataStore":(OI)(CI)F /Q /C /T
echo Updated Permissions for Service Account >> F:\AGSDeploy\Logs\Permissions.log 
icacls "F:\AGSDeploy" >> F:\AGSDeploy\Logs\Permissions.log
icacls "F:\ArcGIS" >> F:\AGSDeploy\Logs\Permissions.log
echo %date% %time% >> F:\AGSDeploy\Logs\Permissions.log 
