@echo off

set "string=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~`!@#$^&()_-+={[}];',."
set "result="
for /l %%i in (1,1,%1) do (call :add)
SETLOCAL EnableDelayedExpansion
echo %result%
ENDLOCAL
goto :eof

:add
set /a x=%random% %% 84
set result=%result%!string:~%x%,1!
goto :eof