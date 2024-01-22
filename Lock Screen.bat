@echo off

SETLOCAL EnableDelayedExpansion

for %%g in ("%~dp0*.jpg") do (set image_file=%%g)
set "dir=\\%USERDNSDOMAIN%\NETLOGON\LockScreen"

if defined image_file (
	for %%g in ("%dir%\Backup\*.jpg") do (set backup_image_file=%%g)
	for %%g in ("%dir%\Backup\*.jpg") do (set counter=%%~ng)

	if not defined counter (set "counter=000")

	set counter=1!counter!
	set /a counter+=1
	set counter=!counter:~1!

	choice /m "Would you like to back up the current lock screen image"

	if !errorlevel!==1 (move "%dir%\LockScreen.jpg" "%dir%\Backup\!counter!.jpg")
	move "%image_file%" "%dir%\LockScreen.jpg"
) else (
	echo Missing image file :(
)

pause

ENDLOCAL