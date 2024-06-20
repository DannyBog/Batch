@echo off

SETLOCAL

set /p machine="Enter a computer name (or IP): "

for /f "tokens=2 delims=:" %%g in ('nltest /server:%machine% /dsgetdc:%USERDNSDOMAIN% 2^>nul') do (
	if not defined dc (
		set dc=%%g
	) else (
		if not defined address (set address=%%g)
	)
)

if defined dc (
	echo %dc:~3% (%address:~3%^)
) else (
	echo %machine% is offline :(
)

pause

ENDLOCAL