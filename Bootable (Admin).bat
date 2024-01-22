@echo off

SETLOCAL

:menu
cls

(
	echo list disk
) > diskpart.txt

diskpart /s diskpart.txt
del diskpart.txt

echo(

set /p disk="Enter the index number of your USB drive: "
choice /c fn /m "Enter the preferred file system for the USB drive: "
if "%errorlevel%"=="1" (set fs=FAT32)
if "%errorlevel%"=="2" (set fs=NTFS)
set /p label="Enter a label for the USB drive: "

cls

(
	echo select disk %disk%
	echo clean
	echo convert mbr
	echo create partition primary
	echo format quick fs=%fs% label="%label%"
	echo active
) > diskpart.txt

diskpart /s diskpart.txt
del diskpart.txt

goto menu

ENDLOCAL