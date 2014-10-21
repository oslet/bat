@echo off
vcredist_x86.exe /qr
msiexec /i python-2.7.8.msi /quiet /passive /qn

set "str=HKCU\Environment"
for /f "skip=2 tokens=2*" %%a in ('REG QUERY "%str%" /v Path') do set "regstr=%%b"

REM set /p src=请输入路径：
set src=C:\Python27
if "%src%"=="" goto :eof
echo %regstr%|find ";%src%">nul&&echo 已经存在%src%||(
  setlocal enabledelayedexpansion
  set "regstr=!regstr!;%src%"
  reg add "!str!" /v Path /t REG_SZ /f /d "!regstr!
  endlocal
)

set PATH=%PATH%;C:\Python27

REM set salt-master hosts
echo 192.168.122.1 salt >> %windir%\system32\dirvers\etc\hosts 
Salt-Minion-2014.1.10-win32-Setup.exe /S /master=salt /minion-name=192.168.122.38

net start salt-minion




