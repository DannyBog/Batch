@echo off

SETLOCAL EnableDelayedExpansion

set /p subnet="Enter a subnet: "

for /l %%g in (1, 1, 254) do (
	set /a num=1
	for /f "tokens=*" %%h in ('ping -a -n 1 -w 1 %subnet%.%%g') do (
		set line!num!=%%h
		set /a num+=1
	)

	for /f "tokens=2-3" %%h in ("!line1!") do (
		(echo "!line2!" | findstr /c:"Reply from %subnet%.%%g">nul) && (
			(echo %%i | findstr /r ^[^.]>nul) && (
				set computer_name=%%h
				set computer_name=!computer_name:~0,-12!
				echo !line2! (!computer_name!^)
			) || (
				echo !line2!
			)
		)
	)
) 2>nul

pause

ENDLOCAL