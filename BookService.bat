@echo off
rem 更新前请把文件放到对应位置
rem 更新服务请运行对应的服务批处理，如预定服务运行bookservice.bat

setlocal enabledelayedexpansion

set path=%path%;%SystemDrive%\tools\bin
set webdir=d:\webs\bookservice
set servicename=bookservice
set sharedir=\\192.168.35.107\emserver\tools\bin


if exist "%SystemDrive%\tools\bin" goto ERROR_mkdir
goto NOERROR_mkdir

:ERROR_mkdir
echo.
echo Directory is exists.>nul
echo.
goto END

:NOERROR_mkdir
echo mkdir dir
echo .
mkdir %SystemDrive%\tools\bin
:END

xcopy /y /v \\192.168.35.107\emserver\tools\bin\xcopy_update.bat %SystemDrive%\tools\bin

call %SystemDrive%\tools\bin\xcopy_update.bat %webdir% %servicename% %sharedir%

endlocal

exit
