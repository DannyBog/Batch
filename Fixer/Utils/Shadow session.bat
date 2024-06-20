@echo off

SETLOCAL

REM set /p computer_name="Enter computer name: "

for /f "tokens=2-3" %%g in ('quser /server:%1') do (
	if %%g==console start /b mstsc /v:%1 /shadow:%%h /control
) 2>nul

ENDLOCAL