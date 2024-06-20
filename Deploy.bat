@echo off

SETLOCAL EnableDelayedExpansion

set /p application="Enter an application name: "
set /p setup="Enter the application's setup script name: "

for %%g in (%~dp0*.txt) do (set text_file=%%g)

if defined text_file (
	for /f %%g in (%text_file%) do (
		echo ========== %%g ==========

		echo(

		echo Copying:
		xcopy ".\%application%" "\\%%g\C$\%application%" /E /H /I

		echo(

		..\psexec -d -s \\%%g "C:\%application%\%setup%"

		echo(
	)
) else (
	set /p machine="Enter a computer name (or IP): "

	echo(

	echo Copying:
	xcopy ".\%application%" "\\!machine!\C$\%application%" /E /H /I

	echo(

	..\psexec -d -s \\!machine! "C:\%application%\%setup%"

	echo(
)

pause

ENDLOCAL