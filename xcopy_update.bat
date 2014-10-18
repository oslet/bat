@echo off

rem 批处理更新之前，备份指定目录文件，然后从共享路径复制文件到指定目录
rem 程序调用需三个参数,一是本地程序路径,二是更新的服务名称,三是共享复制的路径
rem 第二个参数与站点名称相同或者包含部份字符串，以用于更新时启停站点
rem exclude.list文件用于排除不作备份的文件列表

setlocal enabledelayedexpansion

set path=%path%;%SystemDrive%\tools\bin
set website=%1
set updateservice=%2
set shareserver=%3
set webname=%windir%\temp\%2%.txt
set poolname=%windir%\temp\pool%random%.txt
set checksum=%windir%\temp\checksum
set sumserver=\\192.168.122.38\sumserver\%2

set time_hh=%time:~0,2%
if /i %time_hh% LSS 10 (set time_hh=0%time:~1,1%)
set backupdir=%SystemDrive%\backup_dir\%updateservice%\%date:~,4%%date:~5,2%%date:~8,2%_%time_hh%%time:~3,2%%time:~6,2%



if "%website%"=="" (
  echo Usage: %0 c:\website bookservice \\10.20.14.49\iso\bookservice
  exit
)

if "%updateservice"=="" (
  echo 缺少参数
  exit
)

if "%shareserver%"=="" (
  echo 缺少参数
  exit
)



if exist "%backupdir%" goto ERROR_mkdir
goto NOERROR_mkdir

:ERROR_mkdir
echo.
echo Directory is exists.>nul
echo.
goto END

:NOERROR_mkdir
echo mkdir dir
echo .
mkdir %backupdir%\%2
:END


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



for /f "tokens=15" %%i in ('ipconfig ^| find /i "ip address"') do set ipaddr=%%i
rem nt>6.0 for /f "tokens=16" %%i in ('ipconfig ^| find /i "ipv4"') do set ip=%%i


rem cp getapppools.vbs to localdir
xcopy /y /v %shareserver%\getapppools.vbs %SystemDrive%\tools\bin

rem cp exclude.list to localdir
xcopy /y /v %shareserver%\exclude.list %SystemDrive%\tools\bin

%windir%\system32\regsvr32 /s %windir%\system32\wshom.ocx
%windir%\system32\cscript /H:cscript >nul

%windir%\system32\iisweb /query | findstr %updateservice% > %webname%
for /f "tokens=1" %%i in (%webname%) do %windir%\system32\iisweb /stop %%i

xcopy /y /v /exclude:%SystemDriver%\tools\bin\exclude.list %website% %backupdir%
xcopy /y /e /v /exclude:%SystemDriver%\tools\bin\exclude.list %shareserver%\%updateservice% %website%


cscript.exe  %SystemDrive%\tools\bin\getapppools.vbs |findstr /i %2 > %poolname%
for /F "tokens=3* delims=/" %%i in (%poolname%) do cscript.exe %windir%\system32\iisapp.vbs /a %%i /r

for /f "tokens=1" %%i in (%webname%) do %windir%\system32\iisweb /start %%i

cd %1
md5sum -c zfile.md5 > %checksum%_%ipaddr%.txt
xcopy /y /v %checksum%_%ipaddr%.txt %sumserver%

endlocal

exit