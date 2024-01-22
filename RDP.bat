@echo off

SETLOCAL

set /p machine="Enter a computer name (or IP): "
set /p user="Enter a username: "
set /p password="Enter a password: "

cmdkey /generic:%machine% /user:%user% /pass:%password%
mstsc /v:%machine% /w:1280 /h:720
cmdkey /delete:%machine%

ENDLOCAL