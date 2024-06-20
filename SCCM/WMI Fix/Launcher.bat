@echo off

SETLOCAL

set /p computer_name="Enter a computer name (or IP): "
copy WMI.bat \\%computer_name%\C$
..\psexec -d -s \\%computer_name% \\%computer_name%\C$\WMI.bat
pause

ENDLOCAL