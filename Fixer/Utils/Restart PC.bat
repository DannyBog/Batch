@echo off

SETLOCAL

REM set /p computer_name="Enter a computer name: "

shutdown /m \\%computer_name% /r /f /t 0

ENDLOCAL