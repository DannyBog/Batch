@echo off

SETLOCAL

set /p boot_name="Enter a name for your boot entry: "
set /p boot_drive="Enter the drive letter of your boot entry: "

for /f "tokens=2 delims={}" %%g in ('bcdedit /copy {current} /d "%boot_name%"') do (set GUID=%%g)

bcdedit /set {%GUID%} device partition=%boot_drive%:
bcdedit /set {%GUID%} osdevice partition=%boot_drive%:

ENDLOCAL