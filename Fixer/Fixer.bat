@echo off

SETLOCAL

title Fixer ^|Danny Bog^| - 1.0v

:menu
cls

echo =============== FIXER ===============
echo -------------------------------------
echo 1.  Connect to PC
echo 2.  Connect to user
echo 3.  Miscellaneous
echo -------------------------------------
echo ==========PRESS 'Q' TO QUIT==========
echo(

choice /n /c 123q /m "Select a number: "

if "%errorlevel%"=="1" goto pc_connect
if "%errorlevel%"=="2" goto user_connect
if "%errorlevel%"=="3" goto misc
if "%errorlevel%"=="4" goto quit

:pc_connect
cls

set input=
set /p input="Enter a computer name (or IP): "
set computer_name=?
set ip=?
if defined input (
	(echo %input% | findstr /c:".">nul) && (
		SETLOCAL EnableDelayedExpansion
		for /f "tokens=2" %%g in ('nslookup %input% 2^>nul ^| findstr "Name:"') do (set computer_name=%%g)
		set computer_name=!computer_name:~0,-12!
		set ip=%input%
		SETLOCAL DisableDelayedExpansion
	) || (
		for /f "skip=1 tokens=2" %%g in ('nslookup %input% 2^>nul ^| findstr "Address:"') do (set ip=%%g)
		set computer_name=%input%
	)
)

:main_sel1
cls

echo =============== FIXER =============== (PC: %computer_name%, %ip%^)
echo -------------------------------------
echo 1.  Ping
echo 2.  Remote connect
echo 3.  Tasks
echo 4.  Services
echo 5.  Restart PC
echo 6.  Log out
echo -------------------------------------
echo ==========PRESS 'Q' TO QUIT==========
echo(

choice /n /c 123456q /m "Select a number: "

if "%errorlevel%"=="1" goto pc_sel1
if "%errorlevel%"=="2" goto pc_sel2
if "%errorlevel%"=="3" goto pc_sel3
if "%errorlevel%"=="4" goto pc_sel4
if "%errorlevel%"=="5" goto pc_sel5
if "%errorlevel%"=="6" goto menu
if "%errorlevel%"=="7" goto quit

:pc_sel1
cls

echo =============== FIXER =============== (PC: %computer_name%, %ip%^)
echo -------------------------------------
echo 1.  Ping
echo 2.  Ping (Continuous)
echo 3.  Back
echo -------------------------------------
echo ==========PRESS 'Q' TO QUIT==========
echo(

choice /n /c 123q /m "Select a number: "

if "%errorlevel%"=="1" goto pc_ping_sel1
if "%errorlevel%"=="2" goto pc_ping_sel2
if "%errorlevel%"=="3" goto pc_ping_sel3
if "%errorlevel%"=="4" goto quit

:pc_ping_sel1
cls
ping -a %computer_name%
pause
goto pc_sel1

:pc_ping_sel2
cls
ping -a %computer_name% -t
pause
goto pc_sel1

:pc_ping_sel3
goto main_sel1

:pc_sel2
cls

echo =============== FIXER =============== (PC: %computer_name%, %ip%^)
echo -------------------------------------
echo 1.  Connect via hostname
echo 2.  Connect via IP address
echo 3.  Back
echo -------------------------------------
echo ==========PRESS 'Q' TO QUIT==========
echo(

set connect=
choice /n /c 123q /m "Select a number: "

if "%errorlevel%"=="1" (set connect=%computer_name%) & (goto pc_connect_type)
if "%errorlevel%"=="2" (set connect=%ip%) & (goto pc_connect_type)
if "%errorlevel%"=="3" goto main_sel1
if "%errorlevel%"=="4" goto quit

:pc_connect_type
cls

echo =============== FIXER =============== (PC: %computer_name%, %ip%^)
echo -------------------------------------
echo 1.  Shadow session
echo 2.  CmRc
echo 3.  C$
echo 4.  Back
echo -------------------------------------
echo ==========PRESS 'Q' TO QUIT==========
echo(

choice /n /c 1234q /m "Select a number: "

if "%errorlevel%"=="1" goto pc_connect_type_sel1
if "%errorlevel%"=="2" goto pc_connect_type_sel2
if "%errorlevel%"=="3" goto pc_connect_type_sel3
if "%errorlevel%"=="4" goto main_sel1
if "%errorlevel%"=="5" goto quit

:pc_connect_type_sel1
pushd Utils
call "Shadow session.bat" %connect%
popd
goto pc_connect_type

:pc_connect_type_sel2
pushd Utils
start /b "" "CmRc\CmRcViewer.exe" %connect%
popd
goto pc_connect_type

:pc_connect_type_sel3
start \\%connect%\c$
goto pc_connect_type

:pc_sel3
cls

echo =============== FIXER =============== (PC: %computer_name%, %ip%^)
echo -------------------------------------
echo 1.  List tasks
echo 2.  Find task
echo 3.  Kill task
echo 4.  Run task
echo 5.  Back
echo -------------------------------------
echo ==========PRESS 'Q' TO QUIT==========
echo(

choice /n /c 12345q /m "Select a number: "

if "%errorlevel%"=="1" goto pc_task_sel1
if "%errorlevel%"=="2" goto pc_task_sel2
if "%errorlevel%"=="3" goto pc_task_sel3
if "%errorlevel%"=="4" goto pc_task_sel4
if "%errorlevel%"=="5" goto main_sel1
if "%errorlevel%"=="6" goto quit

:pc_task_sel1
cls
pushd Utils
call "List tasks.bat"
popd
goto pc_sel3

:pc_task_sel2
cls
pushd Utils
call "Find task.bat"
popd
goto pc_sel3

:pc_task_sel3
cls
pushd Utils
call "Kill task.bat"
popd
goto pc_sel3

:pc_task_sel4
cls
pushd Utils
call "Run task.bat"
popd
goto pc_sel3

:pc_sel4
cls

echo =============== FIXER =============== (PC: %computer_name%, %ip%^)
echo -------------------------------------
echo 1.  List services
echo 2.  Find service
echo 3.  Restart service
echo 4.  Back
echo -------------------------------------
echo ==========PRESS 'Q' TO QUIT==========
echo(

choice /n /c 1234q /m "Select a number: "

if "%errorlevel%"=="1" goto pc_srv_sel1
if "%errorlevel%"=="2" goto pc_srv_sel2
if "%errorlevel%"=="3" goto pc_srv_sel3
if "%errorlevel%"=="4" goto main_sel1
if "%errorlevel%"=="5" goto quit

:pc_srv_sel1
cls
pushd Utils
call "List services.bat"
popd
goto pc_sel4

:pc_srv_sel2
cls
pushd Utils
call "Find service.bat"
popd
goto pc_sel4

:pc_srv_sel3
cls
pushd Utils
call "Restart service (Admin).bat"
popd
goto pc_sel4

:pc_sel5
cls
pushd Utils
call "Restart PC.bat"
popd
goto main_sel1

:user_connect
cls

set input=
set /p input="Enter username (or phone number): "
set user_name=?
set phone_number=?
if defined input (
	if /i "%input:~0,1%"=="0" (
		for /f "skip=1 tokens=1-2" %%g in ('dsquery * -filter "(&(objectCategory=person)(objectClass=User)(mobile=*))" -attr sAMAccountName mobile -limit 0') do (
			if "%input%"=="%%h" set user_name=%%g
		)
		set phone_number=%input%
	) else (
		for /f "skip=1 tokens=1-2" %%g in ('dsquery * -filter "(&(objectCategory=person)(objectClass=User)(mobile=*))" -attr sAMAccountName mobile -limit 0') do (
			if "%input%"=="%%g" set phone_number=%%h
		)
		set user_name=%input%
	)
)

:main_sel2
cls

echo =============== FIXER =============== (User: %user_name%, %phone_number%^)
echo -------------------------------------
echo 1.  User login history
echo 2.  RDS
echo 3.  Log out
echo -------------------------------------
echo ==========PRESS 'Q' TO QUIT==========
echo(

choice /n /c 123q /m "Select a number: "

if "%errorlevel%"=="1" goto user_sel1
if "%errorlevel%"=="2" goto user_sel2
if "%errorlevel%"=="3" goto user_sel3
if "%errorlevel%"=="4" goto quit

:user_sel1
cls
pushd Utils
call "Login history.bat"
popd
goto main_sel2

:user_sel2
cls

echo =============== FIXER =============== (User: %user_name%, %phone_number%^)
echo -------------------------------------
echo 1.  Find user
echo 2.  Kill session
echo 3.  Shadow session
echo 4.  Back
echo -------------------------------------
echo ==========PRESS 'Q' TO QUIT==========
echo(

choice /n /c 1234q /m "Select a number: "

if "%errorlevel%"=="1" goto user_rds_sel1
if "%errorlevel%"=="2" goto user_rds_sel2
if "%errorlevel%"=="3" goto user_rds_sel3
if "%errorlevel%"=="4" goto user_rds_sel4
if "%errorlevel%"=="5" goto quit

:user_sel3
goto menu

:user_rds_sel1
cls
pushd Utils
call "RDS find user.bat"
popd
goto user_sel2

:user_rds_sel2
cls
pushd Utils
call "RDS kill session.bat"
popd
goto user_sel2

:user_rds_sel3
pushd Utils
call "RDS shadow session.bat"
popd
goto user_sel2

:user_rds_sel4
goto main_sel2

:misc
cls

echo =============== FIXER ===============
echo -------------------------------------
echo 1.  Ping subnet
echo 2.  Check toner levels
echo 3.  List locked users
echo 4.  Unlock all users
echo 5.  Export certificate
echo 6.  Create .bat file
echo 7.  Back
echo -------------------------------------
echo ==========PRESS 'Q' TO QUIT==========
echo(

choice /n /c 123456789q /m "Select a number: "

if "%errorlevel%"=="1" goto misc_sel1
if "%errorlevel%"=="2" goto misc_sel2
if "%errorlevel%"=="3" goto misc_sel3
if "%errorlevel%"=="4" goto misc_sel4
if "%errorlevel%"=="5" goto misc_sel5
if "%errorlevel%"=="6" goto misc_sel6
if "%errorlevel%"=="7" goto misc_sel7
if "%errorlevel%"=="10" goto quit

:misc_sel1
cls
pushd Utils
call "Subnet ping.bat"
popd
goto misc

:misc_sel2
cls
pushd Utils
call "Check toner levels.bat"
popd
goto misc

:misc_sel3
cls
pushd Utils
call "List locked users.bat"
popd
goto misc

:misc_sel4
cls
pushd Utils
call "Unlock all users.bat"
popd
goto misc

:misc_sel5
cls
pushd Utils
call "Export certificate.bat"
popd
goto misc

:misc_sel6
cls
pushd Utils
call "Create bat.bat"
popd
goto misc

:misc_sel7
goto menu

:quit
cls

echo ==============THANK YOU==============
echo -------------------------------------
echo ======PRESS ANY KEY TO CONTINUE======

pause>nul

ENDLOCAL

exit
