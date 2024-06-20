@echo off

SETLOCAL EnableDelayedExpansion

:menu
cls

echo ============== Adapters ==============
echo --------------------------------------

set /a index=1
set "config="
for /f "skip=2 tokens=3*" %%g in ('netsh interface show interface') do (
	set /a index-=1
	set adapters[!index!]=%%h
	set /a index+=1

	for /f "skip=2 tokens=3,5" %%i in ('netsh interface ip show address "%%h"') do (
		set line=%%i

		if !line!==Yes (
			call set "config=%%config%%, DHCP"
		) else if !line!==No (
			call set "config=%%config%%, Static"
		) else if not "!line:/=!"=="!line!" (
			set line=%%j
			call set "config=%%config%%, !line:~0,-1!"
		) else if not "!line:.=!"=="!line!" (
			call set "config=%%config%%, !line!"
		)
	)

	echo !index!. %%h (!config:~2!^)
	set /a index+=1
	set "config="
)

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

set "input="
set /p input="Choose an adapter: " & cls
if not defined input (goto menu)
if /i %input%==Q (exit)

set /a index=%input% - 1
call set adapter=%%adapters[%index%]%%

echo ============== Settings ==============
echo --------------------------------------

set "config="
for /f "skip=2 tokens=3,5" %%g in ('netsh interface ip show address "%adapter%"') do (
	set line=%%g

	if !line!==Yes (
		call set "dhcp=%%config%%, DHCP"
	) else if !line!==No (
		call set "dhcp=%%config%%, Static"
	) else if not "!line:/=!"=="!line!" (
		set line=%%h
		call set "config=%%config%%, !line:~0,-1!"
	) else if not "!line:.=!"=="!line!" (
		call set "config=%%config%%, !line!"
	)
)

set "dns="
for /f "skip=2 tokens=1,5" %%g in ('netsh interface ip show dnsservers "%adapter%"') do (
	set line=%%g

	if not defined dns (
		set line=%%h
		if not "!line:.=!"=="!line!" (call set "dns=%%dns%%, !line!")
	) else if not "!line:.=!"=="!line!" (
		call set "dns=%%dns%%, !line!"
	)
)

echo 1. IP (%config:~2%^)
if defined dns (
	echo 2. DNS (%dns:~2%^)
) else (
	echo 2. DNS (%dns%^)
)
echo 3. DHCP (%dhcp:~2%^)

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

choice /n /c 123q /m "Select the setting you would like to modify: "

if "%errorlevel%"=="1" (cls & goto ip)
if "%errorlevel%"=="2" (cls & goto dns)
if "%errorlevel%"=="3" (cls & goto dhcp)
if "%errorlevel%"=="4" (exit)

:ip
set /p "ip=Enter a new IP address: "
set /p "mask=Enter a new Subnet mask: "
set /p "gateway=Enter a new Default gateway: "
netsh interface ipv4 set address name="%adapter%" static %ip% %mask% %gateway%
timeout 10 > NUL
curl http://www.msftncsi.com/ncsi.txt
goto menu

:dns
set /a index=1
set /p "dns=Enter a new DNS server: "
netsh interface ipv4 set dnsservers "%adapter%" static %dns% primary
choice /m "Would you like to add another DNS server?" & cls
if !errorlevel!==1 (
	:while
		set /a index+=1
		set /p "dns=Enter a new DNS server: "
		netsh interface ipv4 add dnsservers "%adapter%" !dns! index=!index!
		choice /m "Would you like to add another DNS server?" & cls
	if !errorlevel!==1 (goto while)
)
timeout 10 > NUL
curl http://www.msftncsi.com/ncsi.txt
goto menu

:dhcp
netsh interface ip set address "%adapter%" dhcp
netsh interface ip set dns "%adapter%" dhcp
timeout 10 > NUL
goto menu

ENDLOCAL