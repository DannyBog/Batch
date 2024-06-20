@echo off

SETLOCAL EnableDelayedExpansion

set /p machine="Enter a computer name (or IP): "

for /f "skip=1 tokens=1,4 delims=> " %%g in ('quser') do (
	if "%%h"=="Active" (set logged_user=%%g)
)

set flag=1
for /f "tokens=*" %%g in ('reg query "\\%machine%\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /v ProfileImagePath /s') do (
	if defined flag (
		for /f "tokens=7 delims=\" %%h in ('echo %%g') do (set sid=%%h)
		set "flag="
	) else (
		for /f "tokens=3" %%h in ('echo %%g') do (
			for /f "tokens=3 delims=\" %%i in ('echo %%h') do (set user=%%i)
				if !user!==%logged_user% (goto registry)
			)
			set flag=1
		)
	)
)

:registry
echo(
echo Registry:

set "paths[0][0]=Printers"
set "paths[0][1]=Printers\Connections"
set "paths[1][0]=Taskbar"
set "paths[1][1]=Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"
set "paths[2][0]=Icon Positions"
set "paths[2][1]=Software\Microsoft\Windows\Shell\Bags\1\Desktop"

reg load HKU\%logged_user% \\%machine%\C$\Users\%logged_user%\NTUSER.DAT >nul 2>&1

if %errorlevel%==0 (
	for /l %%g in (0, 1, 2) do (
		call set name=%%paths[%%g][0]%%
		echo(
		echo ========== !name! ==========
		call set dir=%%paths[%%g][1]%%
		reg copy "HKU\%logged_user%\!dir!" "HKU\!sid!\!dir!" /s /f
	)

	reg unload HKU\%logged_user% >nul 2>&1
) else (
	for /l %%g in (0, 1, 2) do (
		call set name=%%paths[%%g][0]%%
		echo(
		echo ========== !name! ==========
		call set dir=%%paths[%%g][1]%%
		reg copy "\\%machine%\HKU\!sid!\!dir!" "HKU\!sid!\!dir!" /s /f
	)
)

:files
echo(
echo Files:

set "paths[0][0]=Desktop"
set "paths[0][1]=Users\%logged_user%\Desktop"
set "paths[1][0]=Documents"
set "paths[1][1]=Users\%logged_user%\Documents"
set "paths[2][0]=Downloads"
set "paths[2][1]=Users\%logged_user%\Downloads"
set "paths[3][0]=Google Chrome"
set "paths[3][1]=Users\%logged_user%\AppData\Local\Google"
set "paths[4][0]=Taskbar"
set "paths[4][1]=Users\%logged_user%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
set "paths[5][0]=Layout"
set "paths[5][1]=Users\%logged_user%\AppData\Local\Microsoft\Windows\Shell"

if not exist C:\Windows\Temp\%logged_user% (mkdir C:\Windows\Temp\%logged_user%)

for /l %%g in (0, 1, 5) do (
	call set name=%%paths[%%g][0]%%
	echo(
	echo ========== !name! ==========
	call set dir=%%paths[%%g][1]%%
	if exist "\\%machine%\C$\!dir!" (
		robocopy "\\%machine%\C$\!dir!" "C:\!dir!" /zb /mir /copyall /r:1 /w:1 /unilog:"C:\Windows\Temp\%logged_user%\!name!.log"
	) else (
		echo Directory does not exist.
	)
)

ENDLOCAL