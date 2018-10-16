@echo off

title Proxy Auto change
::Find the value of proxyenable from regedit


call :check
REM :input
REM set /p a=请输入o--打开proxy，c--关闭proxy:
REM if %a%==o (
REM echo opening proxy...
REM reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "ProxyEnable" /t REG_DWORD /d 1 /f
REM call :check
REM ) else (
REM if %a%==c (
echo closing proxy...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "ProxyEnable" /t REG_DWORD /d 0 /f
call :check
REM ) else (
REM goto input
REM )
REM )
:: cleanup dns
ipconfig /flushdns
:: restart ie
start "" "C:\Program Files\Internet Explorer\iexplore.exe" 

:: wait 1 second
@ping 127.0.0.1 -n 2 >nul

:: kill the program
taskkill /f /im iexplore.exe  

pause

:check
for /f "tokens=3" %%i in ('
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "ProxyEnable"
') do set val=%%i

if %val%==0x1 echo ######Current state: OPEN######
if %val%==0x0 echo ######Current state: CLOSE#####
goto :EOF



