@echo off

SETLOCAL

REM set /p computer_name="Enter a computer name: "
set /p process="Enter a process to run: "

psexec -i -d -s \\%computer_name% %process%

ENDLOCAL