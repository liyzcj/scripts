@echo off
set /p ip="请输入IP地址段，格式如："192.168.1" >>> "
for /L %%i in (1,1,254) do (
Ping.exe -n 1 -l 16 -w 100 %ip%.%%i>>ipscan.txt
if not errorlevel 1 (echo %ip%.%%i 可以ping通)
)
pause