@echo off

set randomfile=%random%%random%

set filename=c:\windows\temp\app%randomfile%.txt

for /f "tokens=15" %%i in ('ipconfig ^| find /i "ip address"') do set ip=%%i
rem echo %ip%

%windir%\system32\cscript /H:cscript >nul

%windir%\system32\iisweb /query | findstr "app" > %filename%

for /f "tokens=1" %%i in (%filename%) do %windir%\system32\iisweb /stop %%i


:: svn checkout svn://192.168.1.2/svn/update1 c:\website
:: cd /d c:\website && svn update --force

for /f "tokens=1" %%i in (%filename%) do %windir%\system32\iisweb /start %%i

