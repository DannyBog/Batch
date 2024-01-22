@echo off

SETLOCAL EnableDelayedExpansion

for %%g in ("%~dp0*") do (
	if "%%g" NEQ "%~dp0Encrypt.bat" if "%%g" NEQ "%~dp0mailsend.exe" (set files=!files! "%%g")
)

if defined files (
	set /p smtp="SMTP server address/IP: "
	set /p from="From: "
	set /p to="To: "
	set /p cc="Carbon copy: "
	set /p Subject="Subject: "

	set files=!files:~1!
	set /p archive_name="Enter an archive name: "

	"C:\Program Files\7-Zip\7z.exe" a "%~dp0!archive_name!" !files! -p -mhe=on
	"%~dp0mailsend.exe" -smtp !smtp! -t "!to!" -f !from! -cc "!cc!" -sub "!subject!" -attach "%~dp0!archive_name!.7z"

	for %%g in ("%~dp0*") do (
		if "%%g" NEQ "%~dp0Encrypt.bat" if "%%g" NEQ "%~dp0mailsend.exe" (del "%%g")
	)
) else (
	echo The directory is empty :(
	pause
)

ENDLOCAL