@echo off

SETLOCAL EnableDelayedExpansion

for %%g in ("%~dp0*.txt") do (set text_file=%%g)
set /p file="Enter the file path: "

if defined text_file (
	for /f "usebackq" %%g in ("%text_file%") do (
		echo Deleting \\%%g\C$\%file%...

		if exist \\%%g\C$\%file% (
			takeown /f \\%%g\C$\%file% /a 1>nul
			icacls \\%%g\C$\%file% /reset /q
			del \\%%g\C$\%file%
		) else (
			echo \\%%g\C$\%file% does not exist on %%g
		)

		echo(
	)
) else (
	set /p machine="Enter a computer name (or IP): "

	set file="\\!machine!\C$\Program Files (x86)\Trend Micro\OfficeScan Client\CCSF\system_config.cfg"
	if exist \\!machine!\C$\%file% (
		takeown /f \\!machine!\C$\%file% /a 1>nul
		icacls \\!machine!\C$\%file% /reset /q
		del \\!machine!\C$\%file%
	) else (
		echo \\!machine!\C$\%file% does not exist on !machine!
	)
)

pause

ENDLOCAL