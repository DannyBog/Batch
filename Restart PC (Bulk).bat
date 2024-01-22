@echo off

SETLOCAL

for %%g in ("%~dp0*.txt") do (set text_file=%%g)

for /f "usebackq" %%g in ("%text_file%") do (
	echo Restarting %%g
	shutdown /m \\%%g /r /f /t 0
)

pause

ENDLOCAL