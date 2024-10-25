:: Establish Ports Rules and Open Ports
echo %date% %time% > F:\AGSDeploy\Logs\Ports.log
echo Existing listening Ports on VM >> F:\AGSDeploy\Logs\Ports.log
netstat -an |findstr /i "listening" >> F:\AGSDeploy\Logs\Ports.log 
echo Adding in direction Ports >> F:\AGSDeploy\Logs\Ports.log
netsh advfirewall firewall add rule name="WHITELIST TCP IN" dir=in action=allow protocol=TCP localport=2443,9876,29080,4369,9220,6443
netsh advfirewall firewall show rule name="WHITELIST TCP IN" >> F:\AGSDeploy\Logs\Ports.log
echo Adding out direction Ports >> F:\AGSDeploy\Logs\Ports.log
netsh advfirewall firewall add rule name="WHITELIST TCP OUT" dir=out action=allow protocol=TCP localport=2443,9876,29080,4369,9220,6443
netsh advfirewall firewall show rule name="WHITELIST TCP OUT" >> F:\AGSDeploy\Logs\Ports.log
echo %date% %time% >> F:\AGSDeploy\Logs\Ports.log
echo Added listening Ports on VM >> F:\AGSDeploy\Logs\Ports.log
netstat -an |findstr /i "listening" >> F:\AGSDeploy\Logs\Ports.log



