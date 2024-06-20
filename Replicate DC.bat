@echo off

SETLOCAL EnableDelayedExpansion

:menu
cls

echo =============== Dst DC ===============
echo --------------------------------------

set /a index=1
for /f "skip=1 tokens=1 delims=. " %%g in ('nltest /dclist:%USERDNSDOMAIN% ^| findstr /c:.') do (
	set /a index-=1
	set dcs[!index!]=%%g
	set /a index+=1
	echo !index!. %%g
	set /a index+=1
)

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

set "input="
set /p input="Choose an index: " & cls
if not defined input (goto menu)
if /i %input%==Q (exit)

for /f %%g in ('dsquery partition -part %USERDOMAIN%') do (set dn=%%g)
set dn=%dn:"=%

echo =========== Naming Context ===========
echo --------------------------------------

echo 1. Active Directory
echo 2. DNS

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

choice /n /c 12q /m "Select the naming context you would like to replicate: "

if "%errorlevel%"=="1" (cls & goto active_directory)
if "%errorlevel%"=="2" (cls & goto dns)
if "%errorlevel%"=="3" (exit)

:active_directory
echo =============== Src DC ===============
echo --------------------------------------

set /a index=%input% - 1
call set dst_dc=%%dcs[%index%]%%

set /a index=1
for /f "skip=9 delims=" %%g in ('repadmin /showrepl %dst_dc% "%dn%"') do (
	for /f "tokens=2 delims=\" %%h in ('echo %%g') do ( 
		for /f "tokens=1 delims= " %%i in ('echo %%h') do (
			set /a index-=1
			set dcs[!index!]=%%i
		)
	)

	for /f "tokens=2 delims=@" %%h in ('echo %%g') do (
		for /f "tokens=1,2 delims= " %%i in ('echo %%h') do (
			call set dc=%%dcs[!index!]%%
			set /a index+=1
			echo !index!. !dc! (%%i %%j^)
			set /a index+=1
		)
	)
)

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

set "input="
set /p input="Choose an index: " & cls
if not defined input (goto menu)
if /i %input%==Q (exit)

set /a index=%input% - 1
call set src_dc=%%dcs[%index%]%%

repadmin /replicate %dst_dc% %src_dc% %dn%
pause & goto menu

:dns
echo =============== Src DC ===============
echo --------------------------------------

set /a index=%input% - 1
call set dst_dc=%%dcs[%index%]%%

set /a index=1
for /f "skip=9 delims=" %%g in ('repadmin /showrepl %dst_dc% "DC=DomainDnsZones,%dn%"') do (
	for /f "tokens=2 delims=\" %%h in ('echo %%g') do ( 
		for /f "tokens=1 delims= " %%i in ('echo %%h') do (
			set /a index-=1
			set dcs[!index!]=%%i
		)
	)

	for /f "tokens=2 delims=@" %%h in ('echo %%g') do (
		for /f "tokens=1,2 delims= " %%i in ('echo %%h') do (
			call set dc=%%dcs[!index!]%%
			set /a index+=1
			echo !index!. !dc! (%%i %%j^)
			set /a index+=1
		)
	)
)

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

set "input="
set /p input="Choose an index: " & cls
if not defined input (goto menu)
if /i %input%==Q (exit)

set /a index=%input% - 1
call set src_dc=%%dcs[%index%]%%

repadmin /replicate %dst_dc% %src_dc% DC=DomainDnsZones,%dn%
dnscmd %dst_dc% /zoneupdatefromds %USERDNSDOMAIN%
for /f "tokens=1" %%g in ('dnscmd %dst_dc% /enumzones /domaindirectorypartition /reverse ^| findstr /c:-') do (
	dnscmd %dst_dc% /zoneupdatefromds %%g
)
pause & goto menu

ENDLOCAL