@echo off

set localdir=c:\tools\vbs
set randomfile=app%random%.txt

rem xcopy \\shareserver\tools\vbs\apppools.vbs c:\tools\vbs
rem mkdir c:\tools\vbs

cd %localdir%
cscript.exe %localdir%\apppools.vbs > %randomfile%
for /F "skip=3 tokens=3* delims=/" %%i in (%randomfile%) do cscript.exe %windir%\system32\iisapp.vbs /a %%i /r

del /f /q %randomfile%



