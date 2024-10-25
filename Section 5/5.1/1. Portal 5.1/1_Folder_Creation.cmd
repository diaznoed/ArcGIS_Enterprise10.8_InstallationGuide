echo Establishing Folder Structure for Deployment >> F:\AGSDeploy\Logs\Folders.log
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
