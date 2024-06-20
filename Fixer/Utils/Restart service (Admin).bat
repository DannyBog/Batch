@echo off

SETLOCAL

REM set /p computer_name="Enter a computer name: "
set /p service_name="Enter a service name: "

sc \\%computer_name% stop %service_name% & sc \\%computer_name% start %service_name%

pause

ENDLOCAL