@echo off

SETLOCAL

set /p computer_name="Enter a computer name: "

echo(

set dir=C:\ProgramData\Microsoft\Network\Downloader
echo Deleting %dir%...
rmdir /s /q \\%computer_name%\C$\ProgramData\Microsoft\Network\Downloader

echo(

sc \\%computer_name% start BITS

echo(

pause

ENDLOCAL