@echo off

SETLOCAL

REM set /p computer_name="Enter a computer name: "
set /p task_name="Enter a task name: "

tasklist /s %computer_name% | findstr /i %task_name%

pause

ENDLOCAL