@echo off

setlocal enabledelayedexpansion

rem ���ļ������ C ��,�Ե�ǰʱ������

set time_hh=%time:~0,2%
if /i %time_hh% LSS 10 (set time_hh=0%time:~1,1%)
set output_file=%SystemDrive%\%date:~,4%%date:~5,2%%date:~8,2%_%time_hh%%time:~3,2%%time:~6,2%

%windir%\system32\regsvr32 /s %windir%\system32\scrrun.dll
%windir%\system32\regsvr32 /s %windir%\system32\wshom.ocx
%windir%\system32\cscript /H:cscript >nul


rem wmic os get caption > %output_file%.txt
echo ############################################################################################# > %output_file%.txt
echo ������Ϣ�ֱ�Ϊ ������,ϵͳ���ͣ�������ַ: >> %output_file%.txt
echo . >> %output_file%.txt
systeminfo | findstr  /i /m "�� /m "�����ڴ����� >> %output_file%.txt
systeminfo | findstr /i [0-9][0-9][0-9]\.[0-9][0-9][0-9]*$  >> %output_file%.txt
echo ############################################################################################# >> %output_file%.txt
echo ������ϢΪ��վ����Ϣ: >> %output_file%.txt
echo . >> %output_file%.txt
cscript.exe %windir%\system32\iisweb.vbs /query >> %output_file%.txt

echo ############################################################################################# >> %output_file%.txt
echo ������ϢΪ ����0.0.0.0�˿���Ϣ: >> %output_file%.txt%
echo . >> %output_file%.txt
for /F "usebackq skip=4 tokens=2,5" %%i in (`"netstat -ano -p TCP | findstr 0.0.0.0"`) do ( 
call :Assoc1 %%i TCP %%j 
echo !TCP_Port! !TCP_Proc_Name! >> %output_file%.txt 
) 

ECHO UDPЭ��: 
for /F "usebackq skip=4 tokens=2,4" %%i in (`"netstat -ano -p UDP | findstr 0.0.0.0"`) do ( 
call :Assoc1 %%i UDP %%j
echo !UDP_Port! !UDP_Proc_Name! >> %output_file%.txt
) 
echo OK && start %output_file%.txt
rem pause>nul 

:Assoc1 
::��%1(��һ�����������зָ���ڶ�����������%%e���ڱ������У�%1��Ϊ�����%%i(��ʽΪ��IP:�˿ں�) 
for /F "tokens=2 delims=:" %%e in ("%1") do ( 
set %2_Port=%%e
)
:: ��ѯPID����%3(����������)�Ľ��̣����������������?_Proc_Name,?����UDP����TCP�� 
for /F "skip=1 usebackq delims=, tokens=1" %%a in (`"Tasklist /FI "PID eq %3" /FO CSV"`) do ( 
::%%~a��ʾȥ��%%a��������ţ���Ϊ��������Ľ�����������������ġ� 
set %2_Proc_Name=%%~a
)

endlocal


