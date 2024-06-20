@echo off

SETLOCAL

set /p computer_name="Enter a computer name: "
set /p dc_name="Enter a DC name: "

for /f "skip=3 tokens=*" %%g in ('nltest /server:%computer_name% /sc_reset:%USERDNSDOMAIN%\%dc_name% 2^>nul') do (
	set success=%%g
)

if defined success (
	echo %success%
) else (
	echo The command completed unsuccessfully
)

pause

ENDLOCAL