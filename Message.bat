@echo off

SETLOCAL

set /p machine="Enter a computer name (or IP): "

for /f "tokens=3-4" %%g in ('quser /server:%machine%') do (
	if %%h==Active (msg %%g /server:%machine% /time:999999)
)

ENDLOCAL