@echo off
setlocal enabledelayedexpansion

set path=%path%;%Systemdrive%\tools\bin
cd /d c:\emserver\tools\bin\bookservice

if exist zfile.md5 del /q /f zfile.md5
for /r %%i in (*) do (
set s=%%i 
set s=!s:%~dp0=! 
md5sum !s! >> zfile.md5)

md5sum -c zfile.md5
pause