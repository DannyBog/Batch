@echo off

SETLOCAL

for /f "tokens=3" %%g in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer"') do (set wsus=%%g)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d 0 /f
net stop wuauserv 2>nul & net start wuauserv 2>nul

dism /Online /Add-Capability /CapabilityName:NetFX3~~~~
echo(

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d %wsus% /f
net stop wuauserv 2>nul & net start wuauserv 2>nul

pause

ENDLOCAL