@echo off

SETLOCAL EnableDelayedExpansion

:menu
cls

(
	echo list disk
) > diskpart.txt

diskpart /s diskpart.txt
del diskpart.txt

echo(

set /p disk="Enter the index number of your USB drive: "
set /p label="Enter a label for the USB drive: "

chcp 437>nul

PowerShell ^
	$disk = Get-Disk -Number %disk%; ^
	Clear-Disk -InputObject $disk -RemoveData -RemoveOEM -Confirm:$false; ^
	Set-Disk -Number %disk% -PartitionStyle GPT; ^
	$system = New-Partition -InputObject $disk -Size (260MB) -GptType \"{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}\"; ^
	Format-Volume -FileSystem FAT32 -Partition $system; ^
	Set-Partition -InputObject $system -NewDriveLetter "S"; ^
	$data = New-Partition -InputObject $disk -UseMaximumSize; ^
	Format-Volume -NewFileSystemLabel "%label%" -FileSystem NTFS -Partition $data; ^
	Set-Partition -InputObject $data -NewDriveLetter "W"

cls

set /p image_path="Enter an image file path: "

cls

echo =============== Images ===============
echo --------------------------------------

for /f "skip=5 delims=: tokens=1,2" %%g in ('dism /Get-WimInfo /WimFile:%image_path%') do (
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

set image_path=%image_path:"=%
set extension=%image_path:~-3%
set image_path=%image_path:~0,-4%

if %extension%==wim (dism /Export-Image /SourceImageFile:"%image_path%.wim" /SourceIndex:%input% /DestinationImageFile:"%image_path%_modified.wim" /Compress:max /CheckIntegrity)
if %extension%==esd (dism /Export-Image /SourceImageFile:"%image_path%.esd" /SourceIndex:%input% /DestinationImageFile:"%image_path%_modified.wim" /Compress:max /CheckIntegrity && del "%image_path%.esd")

move "%image_path%_modified.wim" "%image_path%.wim"
set image_path="%image_path%.%extension%"

dism /Apply-Image /ImageFile=%image_path% /Index:1 /ApplyDir:W:\
W:\Windows\System32\bcdboot W:\Windows /f ALL /s S:
mountvol S: /d

goto menu

ENDLOCAL