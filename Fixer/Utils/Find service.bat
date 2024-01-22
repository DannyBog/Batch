@echo off

SETLOCAL

REM set /p computer_name="Enter a computer name: "
set /p service_name="Enter a service name: "

for /f "tokens=1,2,4" %%g in ('sc \\%computer_name% query %service_name% ^| findstr STATE') do (
	echo %%g %%h %%i
)

pause

ENDLOCAL