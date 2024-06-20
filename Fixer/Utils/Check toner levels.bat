@echo off

SETLOCAL EnableDelayedExpansion

set /p printer="Enter a printer IP: "

for /f "delims=;" %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.25.3.2.1.3.0 -op:1.3.6.1.2.1.25.3.2.1.3.1 -q') do (set printer_name=%%g)
echo %printer_name%:

set /a num=1
for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.12.1.1.4.1.0 -op:1.3.6.1.2.1.43.12.1.1.4.1.4 -q') do (
	set color!num!=%%g
	set /a num+=1
)

set type=color
for /l %%g in (1, 1, 4) do (if not defined color%%g (set type=black))

if %type% == color (
	set /a num=1
	(echo %printer_name% | findstr /i /c:"Lexmark CX725">nul) && (
		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.9.1.1 -op:1.3.6.1.2.1.43.11.1.1.9.1.2 -q') do (
			set toner!num!=%%g
			set /a num+=1
		)

		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.9.1.3 -op:1.3.6.1.2.1.43.11.1.1.9.1.4 -q') do (
			set toner!num!=%%g
			set /a num+=1
		)

		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.9.1.6 -op:1.3.6.1.2.1.43.11.1.1.9.1.7 -q') do (
			set toner!num!=%%g
			set /a num+=1
		)

		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.9.1.8 -op:1.3.6.1.2.1.43.11.1.1.9.1.9 -q') do (
			set toner!num!=%%g
			set /a num+=1
		)
	) || (
		REM (BROTHER, EPSON, LEXMARK C792, SAMSUNG)
		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.9.1.0 -op:1.3.6.1.2.1.43.11.1.1.9.1.4 -q') do (
			set toner!num!=%%g
			set /a num+=1
		)
	)

	set /a num=1
	(echo %printer_name% | findstr /i /c:"Lexmark CX725">nul) && (
		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.8.1.1 -op:1.3.6.1.2.1.43.11.1.1.8.1.2 -q') do (
			set capacity!num!=%%g
			set /a num+=1
		)

		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.8.1.3 -op:1.3.6.1.2.1.43.11.1.1.8.1.4 -q') do (
			set capacity!num!=%%g
			set /a num+=1
		)

		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.8.1.6 -op:1.3.6.1.2.1.43.11.1.1.8.1.7 -q') do (
			set capacity!num!=%%g
			set /a num+=1
		)

		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.8.1.8 -op:1.3.6.1.2.1.43.11.1.1.8.1.9 -q') do (
			set capacity!num!=%%g
			set /a num+=1
		)
	) || (
		REM (BROTHER, EPSON, LEXMARK C792, SAMSUNG)
		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.8.1.0 -op:1.3.6.1.2.1.43.11.1.1.8.1.4 -q') do (
			set capacity!num!=%%g
			set /a num+=1
		)
	)

	for /l %%g in (1, 1, 4) do (if !toner%%g! LSS 0 (set toner%%g=0))

	chcp 437>nul
	((echo !printer_name! | findstr /i "Samsung">nul) || (echo !printer_name! | findstr /i /c:"Lexmark C792">nul) || (echo !printer_name! | findstr /i /c:"Lexmark X792">nul)) && (
		for /f %%g in ('powershell ((!toner4! / !capacity4!^) * 100^)') do (set black=%%g)
		for /f %%g in ('powershell ((!toner1! / !capacity1!^) * 100^)') do (set cyan=%%g)
		for /f %%g in ('powershell ((!toner2! / !capacity2!^) * 100^)') do (set magenta=%%g)
		for /f %%g in ('powershell ((!toner3! / !capacity3!^) * 100^)') do (set yellow=%%g)
	) || (
		REM (BROTHER, EPSON, Lexmark CX725)
		for /f %%g in ('powershell ((!toner1! / !capacity1!^) * 100^)') do (set black=%%g)
		for /f %%g in ('powershell ((!toner2! / !capacity2!^) * 100^)') do (set cyan=%%g)
		for /f %%g in ('powershell ((!toner3! / !capacity3!^) * 100^)') do (set magenta=%%g)
		for /f %%g in ('powershell ((!toner4! / !capacity4!^) * 100^)') do (set yellow=%%g)
	)

	echo Black: !black!%%
	echo Cyan: !cyan!%%
	echo Magenta: !magenta!%%
	echo Yellow: !yellow!%%
) else (
	((echo !printer_name! | findstr /i "Brother">nul) || (echo !printer_name! | findstr /i /c:"Lexmark MX622ade">nul)) && (
		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.9.1.1 -op:1.3.6.1.2.1.43.11.1.1.9.1.2 -q') do (set toner=%%g)
		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.8.1.1 -op:1.3.6.1.2.1.43.11.1.1.8.1.2 -q') do (set capacity=%%g)
	) || (
		REM (SAMSUNG)
		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.9.1.0 -op:1.3.6.1.2.1.43.11.1.1.9.1.1 -q') do (set toner=%%g)
		for /f %%g in ('snmpwalk -r:%printer% -os:1.3.6.1.2.1.43.11.1.1.8.1.0 -op:1.3.6.1.2.1.43.11.1.1.8.1.1 -q') do (set capacity=%%g)
	)

	if !toner! LSS 0 (set toner=0)

	chcp 437>nul
	for /f %%g in ('powershell ((!toner! / !capacity!^) * 100^)') do (set black=%%g)

	echo Black: !black!%%
)

pause

ENDLOCAL
