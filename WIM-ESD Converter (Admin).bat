@echo off

SETLOCAL EnableDelayedExpansion

set /p file_path="Enter a file path: "

:menu
cls

echo =============== Images ===============
echo --------------------------------------

for /f "skip=5 delims=: tokens=1,2" %%g in ('dism /Get-WimInfo /WimFile:%file_path%') do (
	if "%%g"=="Index " set index=%%h
	if "%%g"=="Name " set name=%%h
	if "%%g"=="Size " set size=%%h

	if defined index (
		if defined name (
			if defined size (		
				echo !index!. !name:~1! (!size:~1!^)
				set "index="
				set "name="
				set "size="
			)
		)
	)
)

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

set /p input="Choose an index: "

if /i %input%==Q (exit)

cls

set file_path=%file_path:"=%
set extension=%file_path:~-3%
set file_path=%file_path:~0,-4%

if %extension%==wim (dism /Export-Image /SourceImageFile:"%file_path%.wim" /SourceIndex:%input% /DestinationImageFile:"%file_path%.esd" /Compress:recovery /CheckIntegrity)
if %extension%==esd (dism /Export-Image /SourceImageFile:"%file_path%.esd" /SourceIndex:%input% /DestinationImageFile:"%file_path%.wim" /Compress:max /CheckIntegrity)

set file_path="%file_path%.%extension%"

pause

goto menu

ENDLOCAL