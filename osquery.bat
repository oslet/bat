@echo off

setlocal enabledelayedexpansion

rem 此文件存放在 C 盘,以当前时间命名

set time_hh=%time:~0,2%
if /i %time_hh% LSS 10 (set time_hh=0%time:~1,1%)
set output_file=%SystemDrive%\%date:~,4%%date:~5,2%%date:~8,2%_%time_hh%%time:~3,2%%time:~6,2%

%windir%\system32\regsvr32 /s %windir%\system32\scrrun.dll
%windir%\system32\regsvr32 /s %windir%\system32\wshom.ocx
%windir%\system32\cscript /H:cscript >nul


rem wmic os get caption > %output_file%.txt
echo ############################################################################################# > %output_file%.txt
echo 以下信息分别为 主机名,系统类型，网卡地址: >> %output_file%.txt
echo . >> %output_file%.txt
systeminfo | findstr  /i /m "名 /m "物理内存总量 >> %output_file%.txt
systeminfo | findstr /i [0-9][0-9][0-9]\.[0-9][0-9][0-9]*$  >> %output_file%.txt
echo ############################################################################################# >> %output_file%.txt
echo 以下信息为各站点信息: >> %output_file%.txt
echo . >> %output_file%.txt
cscript.exe %windir%\system32\iisweb.vbs /query >> %output_file%.txt

echo ############################################################################################# >> %output_file%.txt
echo 以下信息为 监听0.0.0.0端口信息: >> %output_file%.txt%
echo . >> %output_file%.txt
for /F "usebackq skip=4 tokens=2,5" %%i in (`"netstat -ano -p TCP | findstr 0.0.0.0"`) do ( 
call :Assoc1 %%i TCP %%j 
echo !TCP_Port! !TCP_Proc_Name! >> %output_file%.txt 
) 

ECHO UDP协议: 
for /F "usebackq skip=4 tokens=2,4" %%i in (`"netstat -ano -p UDP | findstr 0.0.0.0"`) do ( 
call :Assoc1 %%i UDP %%j
echo !UDP_Port! !UDP_Proc_Name! >> %output_file%.txt
) 
echo OK && start %output_file%.txt
rem pause>nul 

:Assoc1 
::对%1(第一个参数）进行分割，将第二个参数传给%%e。在本程序中，%1即为上面的%%i(形式为：IP:端口号) 
for /F "tokens=2 delims=:" %%e in ("%1") do ( 
set %2_Port=%%e
)
:: 查询PID等于%3(第三个参数)的进程，并将结果传给变量?_Proc_Name,?代表UDP或者TCP； 
for /F "skip=1 usebackq delims=, tokens=1" %%a in (`"Tasklist /FI "PID eq %3" /FO CSV"`) do ( 
::%%~a表示去掉%%a外面的引号，因为上述命令的结果是用括号括起来的。 
set %2_Proc_Name=%%~a
)

endlocal


