@echo off

SETLOCAL EnableDelayedExpansion

for %%g in (%~dp0*.txt) do (set text_file=%%g)

if defined text_file (
	for /f %%g in (%text_file%) do (psexec -d -s \\%%g C:\Windows\ccmsetup\ccmsetup.exe /uninstall)
) else (
	set /p computer_name="Enter a computer name (or IP): "
	psexec -d -s \\!computer_name! C:\Windows\ccmsetup\ccmsetup.exe /uninstall
)

pause

ENDLOCAL