@echo off

SETLOCAL EnableDelayedExpansion

for %%g in (%~dp0*.txt) do (set text_file=%%g)
set /p management_point="Enter the management point name: "
set /p site_code="Enter the site code name: "

if defined text_file (
	for /f %%g in (%text_file%) do (
		echo ========== %%g ==========

		echo Deleting SMSCFG.INI...
		del \\%%g\C$\Windows\SMSCFG.INI

		echo(

		set "dir=C:\Windows\CCM"
		echo Deleting !dir!...
		rmdir /s /q \\%%g\C$\Windows\CCM

		echo(

		set "dir=C:\Windows\CCMSetup"
		echo Deleting !dir!...
		rmdir /s /q \\%%g\C$\Windows\CCMSetup

		echo(

		set "dir=C:\Windows\CCMCache"
		echo Deleting !dir!...
		rmdir /s /q \\%%g\C$\Windows\CCMCache

		echo(

		set "key=HKLM\SOFTWARE\Microsoft\CCM"
		echo Deleting !key!...
		reg delete \\%%g\!key! /f

		echo(

		set "key=HKLM\SOFTWARE\Microsoft\CCMSetup"
		echo Deleting !key!...
		reg delete \\%%g\!key! /f

		echo(

		set "key=HKLM\SOFTWARE\Microsoft\SMS"
		echo Deleting !key!...
		reg delete \\%%g\!key! /f

		echo(

		set "key=HKLM\SOFTWARE\Microsoft\SystemCertificates\SMS\Certificates"
		echo Deleting !key!...
		reg delete \\%%g\!key! /f

		echo(

		echo Copying:
		xcopy .\Client \\%%g\C$\Windows\ccmsetup /E /H /I

		echo(

		psexec -d -s \\%%g C:\Windows\ccmsetup\ccmsetup.exe /mp:%management_site% SMSSITECODE=%site_code% /AllowMetered /forceinstall /forcereboot

		echo(
	)
) else (
	set /p machine="Enter a computer name (or IP): "

	echo(

	echo Deleting SMSCFG.INI...
	del \\!machine!\C$\Windows\SMSCFG.INI

	echo(

	set "dir=C:\Windows\CCM"
	echo Deleting !dir!...
	rmdir /s /q \\!machine!\C$\Windows\CCM

	echo(

	set "dir=C:\Windows\CCMSetup"
	echo Deleting !dir!...
	rmdir /s /q \\!machine!\C$\Windows\CCMSetup

	echo(

	set "dir=C:\Windows\CCMCache"
	echo Deleting !dir!...
	rmdir /s /q \\!machine!\C$\Windows\CCMCache

	echo(

	set "key=HKLM\SOFTWARE\Microsoft\CCM"
	echo Deleting !key!...
	reg delete \\!machine!\!key! /f

	echo(

	set "key=HKLM\SOFTWARE\Microsoft\CCMSetup"
	echo Deleting !key!...
	reg delete \\!machine!\!key! /f

	echo(

	set "key=HKLM\SOFTWARE\Microsoft\SMS"
	echo Deleting !key!...
	reg delete \\!machine!\!key! /f

	echo(

	set "key=HKLM\SOFTWARE\Microsoft\SystemCertificates\SMS\Certificates"
	echo Deleting !key!...
	reg delete \\!machine!\!key! /f

	echo(

	echo Copying:
	xcopy .\Client \\!machine!\C$\Windows\ccmsetup /E /H /I

	echo(

	psexec -d -s \\!machine! C:\Windows\ccmsetup\ccmsetup.exe /mp:%management_site% SMSSITECODE=%site_code% /AllowMetered /forceinstall /forcereboot

	echo(
)

pause

ENDLOCAL