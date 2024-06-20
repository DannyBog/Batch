@echo off

SETLOCAL EnableDelayedExpansion

for /f "tokens=3" %%g in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer"') do (set wsus=%%g)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d 0 /f
net stop wuauserv 2>nul & net start wuauserv 2>nul

for /f "tokens=2 delims=:" %%g in ('dism /Online /Get-Capabilities ^| findstr Rsat') do (
	set capability=%%g
	set capability=!capability:~1!

	for /f "tokens=1 delims=~" %%h in ('echo !capability!') do (echo %%h:)
	dism /Online /Add-Capability /CapabilityName:!capability!
	echo(
)

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d %wsus% /f
net stop wuauserv 2>nul & net start wuauserv 2>nul

pause

ENDLOCAL