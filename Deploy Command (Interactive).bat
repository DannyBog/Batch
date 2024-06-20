@echo off

SETLOCAL

set /p machine="Enter a computer name (or IP): "
set /p command="Enter a command: "

for /f "tokens=3-4" %%g in ('quser /server:%machine%') do (
	if %%h==Active (..\psexec -i %%g -d -s \\%machine% %command%)
)

ENDLOCAL