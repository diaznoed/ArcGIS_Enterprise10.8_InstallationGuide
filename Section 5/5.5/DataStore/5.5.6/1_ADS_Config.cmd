:: Configure ArcGIS Data Store
:: Verify connectivity
"C:\Program Files\Internet Explorer\iexplore.exe" https://localhost:6443/arcgis/manager

:: Execute Data Store configuration
F:\Program Files\ArcGIS\DataStore\tools\configuredatastore.bat https://localhost:6443 serverAdmin password F:\arcgisdatastore --stores relational

:: Enable PITR setting
F:\Program Files\ArcGIS\DataStore\tools\changedbproperties.bat --store relational --pitr enable




