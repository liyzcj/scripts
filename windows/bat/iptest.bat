@echo off

title Auto Test IP
::Test network through ping command

set segment=10.19.244

for /l %%i in (11,1,103) do (
	ping %segment%.%%i -n "1" | find /i "TTL=" > nul && echo Testing %segment%.%%i	Pass || echo Testing %segment%.%%i		Error
	)
pause


