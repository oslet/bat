@echo off
rem zabbix install
rem check osarch
if /i "%processor_architecture%"=="x86" (c:\zabbix_agent\bin\win32\zabbix_agentd -c c:\zabbix_agent\conf\zabbix_agentd.conf -i) else (c:\zabbix_agent\bin\win64\zabbix_agentd -c c:\zabbix_agent\conf\zabbix_agentd.conf -i)

rem server point to 
echo 192.168.122.235 zabbixserver >> %windir%\system32\drivers\etc\hosts

rem service start
net start "zabbix agent"
