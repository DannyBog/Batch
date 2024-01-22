@echo off

SETLOCAL

REM set /p computer_name="Enter a computer name: "

sc \\%computer_name% query

pause

ENDLOCAL