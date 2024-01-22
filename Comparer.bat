@echo off

SETLOCAL EnableDelayedExpansion

:menu
cls

echo ============== Comparer ==============
echo --------------------------------------

echo 1. File Comparer
echo 2. Directory Comparer

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

choice /n /c 12q /m "Choose a comparer: " & cls

if "%errorlevel%"=="1" (goto file_comparer)
if "%errorlevel%"=="2" (goto dir_comparer)
if "%errorlevel%"=="3" (exit)

:file_comparer
set /p "file_path1=Enter the first file path: "
set /p "file_path2=Enter the second file path: "
set file_path1=%file_path1:"=%
set file_path2=%file_path2:"=%
call :Comparer "%file_path1%", "%file_path2%"
pause
goto menu

:dir_comparer
set /p "dir_path1=Enter the first directory path: "
set /p "dir_path2=Enter the second directory path: "
set dir_path1=%dir_path1:"=%
set dir_path2=%dir_path2:"=%

set /a index1=0
for /f "delims=" %%g in ('where "%dir_path1%:*.*"') do (
	set "files1[!index1!]=%%g"
	set /a index1+=1
)

set /a index2=0
for /f "delims=" %%g in ('where "%dir_path2%:*.*"') do (
	set "files2[!index2!]=%%g"
	set /a index2+=1
)

set /a length1=%index1% - 1
set /a length2=%index2% - 1

set /a index=0
for /l %%g in (0, 1, %length1%) do (
	call set file1=%%files1[%%g]%%
	for %%h in ("!file1!") do (set "file_name1=%%~nxh")
	for /l %%h in (0, 1, %length2%) do if not defined flag (
		call set file2=%%files2[%%h]%%
		for %%i in ("!file2!") do (set "file_name2=%%~nxi")
		if /i "!file_name1!" EQU "!file_name2!" (
			call :Comparer "!file1!", "!file2!"
			set "files2[%%h]="
			set "flag=true"
		)
	)
	
	if not defined flag (
		set "leftovers1[!index!]=!file1!"
		set /a index+=1
	) else (
		set "flag="
	)
)

set /a index=0
for /l %%g in (0, 1, %length2%) do (
	call set file2=%%files2[%%g]%%
	if defined file2 (
		set "leftovers2[!index!]=!file2!"
		set /a index+=1
	)
)

set /a index=0
:while
	call set file1=%%leftovers1[%index%]%%
	set "file2="
	if defined file1 (call :Comparer "!file1!", "!file2!")

	set "file1="
	call set file2=%%leftovers2[%index%]%%
	if defined file2 (call :Comparer "!file1!", "!file2!")

	if not defined file1 if not defined file2 (
		pause
		goto menu
	)

	set /a index+=1
goto while

:Comparer
SETLOCAL
	echo(
	set "file1=%~1"
	set "file2=%~2"

	echo ***** Statistics

	for /l %%g in (1, 1, 2) do (
		for %%h in ("!file%%g!") do (
			set "name%%g=%%~nh"
			set "extension%%g=%%~xh"
			set "extension%%g=!extension%%g:~1!"
			set "modified%%g=%%~th"
			set "size%%g=%%~zh"
		)

		if defined name%%g (
			set "file_name%%g=!name%%g!.!extension%%g!"
		) else (
			set "file_name%%g=?"
		)

		((echo !extension%%g!| findstr /i /r /c:"^c$">nul) || <nul ^
		(echo !extension%%g!| findstr /i /r /c:"^h$">nul) || <nul ^
		(echo !extension%%g!| findstr /i /r /c:"^bat$">nul) || <nul ^
		(echo !extension%%g!| findstr /i /r /c:"^csv$">nul) || <nul ^
		(echo !extension%%g!| findstr /i /r /c:"^ini$">nul) || <nul ^
		(echo !extension%%g!| findstr /i /r /c:"^log$">nul) || <nul ^
		(echo !extension%%g!| findstr /i /r /c:"^ps1$">nul) || <nul ^
		(echo !extension%%g!| findstr /i /r /c:"^txt$">nul) || <nul ^
		(echo !extension%%g!| findstr /i /r /c:"^xml$">nul)) && (
			for /f "tokens=3 delims=:" %%h in ('find /v /c "" "!file%%g!"') do (set "lines%%g=%%h")
			set "lines%%g=!lines%%g:~1!"
			echo Line Count=!lines%%g!, Date Modified=!modified%%g!, Size=!size%%g! Bytes
		) || (
			if not defined modified%%g (set modified%%g=?)
			if defined size%%g (
				set "size%%g=!size%%g! Bytes"
			) else (
				set "size%%g=?"
			)
			echo Line Count=?, Date Modified=!modified%%g!, Size=!size%%g!
			set "flag=true"
		)
	)

	if defined flag (
		echo ***** !file_name1!
		echo ***** !file_name2!
		exit /b 0
	)

	echo ***** !file_name1!
	set /a index=1
	for /f "tokens=1,* delims=]" %%g in ('type "%file1%"^|find /v /n ""') do (
		(for /l %%i in (1, 1, !index!) do set /p "line1=") < "%file1%"

		if !index! LEQ %lines2% (
			(for /l %%i in (1, 1, !index!) do set /p "line2=") < "%file2%"
		) else (
			set "line2="
		)

		if "!line1!" NEQ "!line2!" (echo(     !index!: %%h)
		set /a index+=1
	)

	echo ***** !file_name2!
	set /a index=1
	for /f "tokens=1,* delims=]" %%g in ('type "%file2%"^|find /v /n ""') do (
		if !index! LEQ %lines1% (
			(for /l %%i in (1,1,!index!) do set /p "line1=") < "%file1%"
		) else (
			set "line1="
		)

		(for /l %%i in (1,1,!index!) do set /p "line2=") < "%file2%"

		if "!line2!" NEQ "!line1!" (echo(     !index!: %%h)
		set /a index+=1
	)

	exit /b 0
ENDLOCAL

ENDLOCAL