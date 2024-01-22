@echo off

SETLOCAL EnableDelayedExpansion

for %%g in ("%~dp0*.txt") do (set text_file=%%g)
set /p dir="Enter the directory path: "

if defined text_file (
	for /f "usebackq" %%g in ("%text_file%") do (
		echo Deleting \\%%g\C$\%dir%...

		if exist \\%%g\C$\%dir% (
			takeown /f \\%%g\C$\%dir% /r /a /d y 1>nul
			icacls \\%%g\C$\%dir% /reset /t /q
			rmdir /s /q \\%%g\C$\%dir%
		) else (
			echo \\%%g\C$\%dir% does not exist on %%g
		)

		echo(
	)
) else (
	set /p machine="Enter a computer name (or IP): "

	if exist \\!machine!\C$\%dir% (
		takeown /f \\!machine!\C$\%dir% /r /a /d y 1>nul
		icacls \\!machine!\C$\%dir% /reset /t /q
		rmdir /s /q \\!machine!\C$\%dir%
	) else (
		echo \\!machine!\C$\%dir% does not exist on !machine!
	)
)

pause

ENDLOCAL