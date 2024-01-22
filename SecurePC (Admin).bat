@echo off

SETLOCAL

set /p length="Enter administrator's password length: "

set "string=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~`!@#$%%^&()_-+={[}];',."
set "password="
for /l %%i in (1,1,%length%) do (call :add)
SETLOCAL EnableDelayedExpansion
echo The new password is: %password%
pause
net user administrator %password% /active:yes 1>nul
ENDLOCAL
goto :account

:add
set /a x=%random% %% 85
set password=%password%!string:~%x%,1!
goto :eof


:account
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f 1>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v DisablePrivacyExperience /t REG_DWORD /d 1 /f 1>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f 1>nul

set "username=User"
net user %username% /add > nul 2>&1
for /f %%g in ('wmic useraccount where name^="%username%" get sid ^| findstr ^S\-d*') do (set sid=%%g)
echo(
echo Remember it!
echo Press any key to continue . . .
runas /user:%username% "cmd.exe /c start /min cmd.exe" 1>nul


:policies
REM =====Ctrl+Alt+Del=====

REM Disable "Lock" option
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLockWorkstation /t REG_DWORD /d 1 /f 1>nul

REM Disable "Switch user" option
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v hideFastUserSwitching /t REG_DWORD /d 1 /f 1>nul

REM Disable "Sign out" option
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLogoff /t REG_DWORD /d 1 /f 1>nul

REM Disable "Change Password" option
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableChangePassword /t REG_DWORD /d 1 /f 1>nul

REM Disable "Task Manager" option
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f 1>nul


REM =====File Explorer=====

REM Hide drives
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v Nodrives /t REG_DWORD /d 67108863 /f 1>nul

REM Disable drives
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewOnDrive /t REG_DWORD /d 67108863 /f 1>nul

REM right-click Context Menus
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewContextMenu /t REG_DWORD /d 1 /f 1>nul

REM Disable Windows hotkeys
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoWinKeys /t REG_DWORD /d 1 /f 1>nul


REM =====Desktop=====

REM Hide & disable desktop icons
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDesktop /t REG_DWORD /d 1 /f 1>nul


REM =====Removable Storage=====

REM Disable removable storage
reg add "HKU\%sid%\SOFTWARE\Policies\Microsoft\Windows\removablestorageDevices" /v deny_all /t REG_DWORD /d 1 /f 1>nul


REM =====Start Menu & Taskbar=====

REM Hide Cortana button
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCortanaButton /t REG_DWORD /d 0 /f 1>nul

REM Hide search box
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f 1>nul

REM Hide Task View button
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f 1>nul

REM Disable Shut down/Restart/Sleep/Hibernate options
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoClose /t REG_DWORD /d 1 /f 1>nul

REM Disable taskbar's context menus
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoTrayContextMenu /t REG_DWORD /d 1 /f 1>nul

REM Remove Action Center
reg add "HKU\%sid%\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f 1>nul

REM Remove Start Menu's programs
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoStartMenuMorePrograms /t REG_DWORD /d 1 /f 1>nul

REM Remove System Tray Icons
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoTrayItemsDisplay /t REG_DWORD /d 1 /f 1>nul

REM Remove taskbar's pinned programs
reg add "HKU\%sid%\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v TaskbarNoPinnedList /t REG_DWORD /d 1 /f 1>nul

REM Turn off News and interests
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f 1>nul


REM =====Tools=====

REM Disable Control Panel & PC settings
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoControlPanel /t REG_DWORD /d 1 /f 1>nul

REM Disable CMD
reg add "HKU\%sid%\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableCMD /t REG_DWORD /d 1 /f 1>nul

REM Disable Registry
reg add "HKU\%sid%\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f 1>nul

REM Disable Powershell
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v DisallowRun /t REG_DWORD /d 1 /f 1>nul
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v 1 /t REG_SZ /d "powershell.exe" /f 1>nul
reg add "HKU\%sid%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v 2 /t REG_SZ /d "powershell_ise.exe" /f 1>nul


shutdown /r /f /t 0


ENDLOCAL