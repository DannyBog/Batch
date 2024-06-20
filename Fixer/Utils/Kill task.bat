@echo off

SETLOCAL

REM set /p computer_name="Enter a computer name: "
set /p process="Enter a process to kill: "

taskkill /s %computer_name% /IM %process%

ENDLOCAL