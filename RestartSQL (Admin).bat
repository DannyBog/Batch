@echo off

SETLOCAL

for /f "tokens=2 delims=:" %%g in ('sc query ^| findstr MSSQL') do (
	if not defined edition (set edition=%%g)
)

set edition=%edition:~1%

:menu
cls

echo ============= User Modes =============
echo --------------------------------------

echo 1. Single User
echo 2. Multi User

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

choice /n /c 12q /m "Select a user mode to start the SQL server in: "

if "%errorlevel%"=="1" (goto sql_single)
if "%errorlevel%"=="2" (goto sql_multi)
if "%errorlevel%"=="3" (exit)

cls

:sql_single
if %edition%==MSSQLSERVER (
	net stop SQLSERVERAGENT /y
	net stop %edition% /y && net start %edition% /m /y
) else (
	net stop %edition% /y && net start %edition% /m /y
)

pause
goto menu

:sql_multi
if %edition%==MSSQLSERVER (
	net stop %edition% /y && net start %edition% /y
	net start SQLSERVERAGENT /y
) else (
	net stop %edition% /y && net start %edition% /y	
)

pause
goto menu

ENDLOCAL