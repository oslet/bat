@echo off

set randomfile=%random%%random%

set filename=c:\windows\temp\app%randomfile%.txt

for /f "tokens=15" %%i in ('ipconfig ^| find /i "ip address"') do set ip=%%i
rem echo %ip%

%windir%\system32\cscript /H:cscript >nul

%windir%\system32\iisweb /query | findstr "app" > %filename%

for /f "tokens=1" %%i in (%filename%) do %windir%\system32\iisweb /stop %%i


xcopy /y /e /v 

for /f "tokens=1" %%i in (%filename%) do %windir%\system32\iisweb /start %%i

cscript.exe %SystemDrive%\inetpub\adminscripts\adsutil.vbs enum_all /p w3svc/apppools | findstr app* > c:\app.txt
for /f "tokens=3* delims=[,],/" %%i in (c:\app.txt) do cscript.exe %windir%\system32\iisapp.vbs /a %%i /r
