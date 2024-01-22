@echo off

SETLOCAL

title MAKE ^|Danny Bog^|

set /p project_name="Enter the project's name: "
set /p main_file_name="Enter the main file name: "
choice /c wc /m "Press W for a windows application and C for a console application"

if %ERRORLEVEL%==1 (set "application_type=WINDOWS")
if %ERRORLEVEL%==2 (set "application_type=CONSOLE")

if not exist %USERPROFILE%\Documents\Projects mkdir %USERPROFILE%\Documents\Projects
mkdir "%USERPROFILE%\Documents\Projects\%project_name%"
mkdir "%USERPROFILE%\Documents\Projects\%project_name%\build"
mkdir "%USERPROFILE%\Documents\Projects\%project_name%\res"
mkdir "%USERPROFILE%\Documents\Projects\%project_name%\src"

set SHORTCUT='%USERPROFILE%\Documents\Projects\%project_name%\Command Prompt.lnk'
set ARGUMENTS='/k \"%USERPROFILE%\Documents\Projects\%project_name%\build\shell.bat\"'

PowerShell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile ^
	$ws = New-Object -ComObject WScript.Shell; ^
	$s = $ws.CreateShortcut(%SHORTCUT%); ^
	$s.TargetPath = \"%%COMSPEC%%\"; ^
	$s.Arguments = %ARGUMENTS%; ^
	$s.Save()

call :build_bat
call :shell_bat
call :emacs_bat
call :remedy_bat

exit /b %ERRORLEVEL%
:build_bat
(echo %application_type% | findstr /c:"WINDOWS">nul) && (
	(
		echo #define WIN32_LEAN_AND_MEAN
		echo #include ^<windows.h^>
		echo(
		echo #pragma comment(lib, "kernel32.lib"^)
		echo(
		echo #ifdef _DEBUG
		echo int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR pCmdLine, int nCmdShow^) {
		echo #else
		echo void WinMainCRTStartup(^) {
		echo #endif
		echo		ExitProcess(0^);
		echo }
	) > "%USERPROFILE%\Documents\Projects\%project_name%\src\%main_file_name%.c"

	(
		echo ^<?xml version='1.0' encoding='UTF-8' standalone='yes'?^>
		echo ^<assembly xmlns='urn:schemas-microsoft-com:asm.v1' manifestVersion='1.0' xmlns:asmv3='urn:schemas-microsoft-com:asm.v3'^>
		echo   ^<asmv3:application^>
		echo     ^<asmv3:windowsSettings^>
		echo       ^<dpiAwareness xmlns='http://schemas.microsoft.com/SMI/2016/WindowsSettings'^>PerMonitorV2^</dpiAwareness^>
		echo     ^</asmv3:windowsSettings^>
		echo   ^</asmv3:application^>
		echo ^</assembly^>
	) > "%USERPROFILE%\Documents\Projects\%project_name%\res\%project_name%.manifest"

	(
		echo @echo off
		echo(
		echo set "app=%project_name%"
		echo(
		echo if "%%1" equ "debug" (
		echo		set "cl=/MTd /Od /D_DEBUG /Zi /RTC1 /Fd"%%app%%.pdb" /fsanitize=address"
		echo		set "link=/DEBUG libucrtd.lib"
		echo ^) else (
		echo		set "cl=/GL /O1 /DNDEBUG /GS-"
		echo		set "link=/LTCG /OPT:REF /OPT:ICF libvcruntime.lib"
		echo ^)
		echo(
		echo set "warnings=/wd4100 /wd4706"
		echo(
		echo if not exist "%%~dp0..\output" mkdir "%%~dp0..\output"
		echo(
		echo pushd "%%~dp0..\output"
		echo cl /nologo /WX /W4 %%warnings%% /MP "..\src\%main_file_name%.c" /Fe"%%app%%" /link /INCREMENTAL:NO /MANIFEST:EMBED /MANIFESTINPUT:"..\res\%%app%%.manifest" /SUBSYSTEM:%application_type% /FIXED /merge:_RDATA=.rdata
		echo(
		echo del *.obj ^>nul
		echo popd
	) > "%USERPROFILE%\Documents\Projects\%project_name%\build\build.bat"
) || (echo %application_type% | findstr /c:"CONSOLE">nul) && (
	(
		echo #define WIN32_LEAN_AND_MEAN
		echo #include ^<windows.h^>
		echo(
		echo #pragma comment(lib, "kernel32.lib"^)
		echo(
		echo #ifdef _DEBUG
		echo int main(int argc, char **argv^) {
		echo #else
		echo void mainCRTStartup(^) {
		echo #endif
		echo		ExitProcess(0^);
		echo }
	) > "%USERPROFILE%\Documents\Projects\%project_name%\src\%main_file_name%.c"

	(
		echo @echo off
		echo(
		echo set "app=%project_name%"
		echo(
		echo if "%%1" equ "debug" (
		echo		set "cl=/MTd /Od /D_DEBUG /Zi /RTC1 /Fd"%%app%%.pdb" /fsanitize=address"
		echo		set "link=/DEBUG libucrtd.lib"
		echo ^) else (
		echo		set "cl=/GL /O1 /DNDEBUG /GS-"
		echo		set "link=/LTCG /OPT:REF /OPT:ICF libvcruntime.lib"
		echo ^)
		echo(
		echo set "warnings=/wd4100 /wd4706"
		echo(
		echo if not exist "%%~dp0..\output" mkdir "%%~dp0..\output"
		echo(
		echo pushd "%%~dp0..\output"
		echo cl /nologo /WX /W4 %%warnings%% /MP "..\src\%main_file_name%.c" /Fe"%%app%%" /link /INCREMENTAL:NO /SUBSYSTEM:%application_type% /FIXED /merge:_RDATA=.rdata
		echo(
		echo del *.obj ^>nul
		echo popd
	) > "%USERPROFILE%\Documents\Projects\%project_name%\build\build.bat"
)
exit /b 0

exit /b %ERRORLEVEL%
:shell_bat
(
	echo @echo off
	echo(
	echo set "vswhere=C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
	echo set "component=Microsoft.Component.MSBuild"
	echo for /f "tokens=*" %%%%g in ('"%%vswhere%%" -products * -requires %%component%% -property installationPath'^) do (set VS=%%%%g^)
	echo(
	echo call "%%VS%%\VC\Auxiliary\Build\vcvars64.bat"
	echo set Path=%%cd%%\build;%%PATH%%
) > "%USERPROFILE%\Documents\Projects\%project_name%\build\shell.bat"
exit /b 0

exit /b %ERRORLEVEL%
:emacs_bat
(
	echo @echo off
	echo(
	echo for /f %%%%g in ('dir "C:\Program Files\Emacs" /ad /b /on'^) do (
	echo		for /f "tokens=2 delims=-." %%%%h in ('echo %%%%g'^) do (set "major=%%%%h"^)
	echo		for /f "tokens=2 delims=." %%%%h in ('echo %%%%g'^) do (set "minor=%%%%h"^)
	echo ^)
	echo(
	echo start "" "C:\Program Files\Emacs\emacs-%%major%%.%%minor%%\bin\runemacs.exe"
) > "%USERPROFILE%\Documents\Projects\%project_name%\build\emacs.bat"
exit /b 0

exit /b %ERRORLEVEL%
:remedy_bat
(
	echo @echo off
	echo(
	echo start "" "C:\Program Files\RemedyBG\remedybg.exe"
) > "%USERPROFILE%\Documents\Projects\%project_name%\build\remedy.bat"
exit /b 0

ENDLOCAL