@echo off

SETLOCAL

set /p input="Enter a computer name (or IP): "

if defined input (
	(echo %input% | findstr /c:".">nul) && (
		SETLOCAL EnableDelayedExpansion
		for /f "tokens=2" %%g in ('nslookup %input% 2^>nul ^| findstr "Name:"') do (set computer_name=%%g)
		if defined computer_name (
			set computer_name=!computer_name:~0,-12!
			set ip=(%input%^)
		)
		SETLOCAL DisableDelayedExpansion
	) || (
		for /f "skip=1 tokens=2" %%g in ('nslookup %input% 2^>nul ^| findstr "Address:"') do (set ip=(%%g^))
		if defined ip (set computer_name=%input%)
	)
)

cls
title %computer_name% %ip%

if defined computer_name (
	SETLOCAL EnableDelayedExpansion
	set "header=Image Name                     PID Session Name        Session#    Mem Usage"
	set separator="========================= ======== ================ =========== ============"
	set separator=!separator:"=!

	echo !header!
	echo !separator!
	:while
		tasklist /s:%computer_name% | findstr /c:"ccmsetup.exe" /c:"CcmExec.exe" /c:"CmRcService.exe"
		echo !separator!
		timeout 5 > NUL
	goto while
	SETLOCAL DisableDelayedExpansion
) else (
	echo The machine is offline :(
)

pause

ENDLOCAL