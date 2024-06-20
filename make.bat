@echo off

SETLOCAL EnableDelayedExpansion

title MAKE ^|Danny Bog^|

:menu
cls

echo ================ Make ================
echo --------------------------------------

echo 1. Project name: %project_name%
if not defined main_file_name (
	echo 2. Main file name: %main_file_name%
) else (
	echo 2. Main file name: %main_file_name%.c
)
echo 3. Application type: %application_type%
echo 4. Create Project

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

choice /n /c 1234q /m "Select the setting you would like to modify: "
cls

if %ERRORLEVEL%==1 (set /p project_name="Enter the project's name: " & goto menu)
if %ERRORLEVEL%==2 (set /p main_file_name="Enter the main file name: " & goto menu)
if %ERRORLEVEL%==3 (
	choice /c gcw /m "Press G for a GUI application, C for a Console application or W for a Web application"
	if !ERRORLEVEL!==1 (set "application_type=GUI")
	if !ERRORLEVEL!==2 (set "application_type=Console")
	if !ERRORLEVEL!==3 (set "application_type=Web")
	goto menu
)
if %ERRORLEVEL%==4 (
	if defined project_name if defined main_file_name if defined application_type (goto make)
	goto menu
)
if %ERRORLEVEL%==5 (exit)

:make
if not exist %USERPROFILE%\Documents\Projects mkdir %USERPROFILE%\Documents\Projects
mkdir "%USERPROFILE%\Documents\Projects\%project_name%"
mkdir "%USERPROFILE%\Documents\Projects\%project_name%\build"
mkdir "%USERPROFILE%\Documents\Projects\%project_name%\res"
mkdir "%USERPROFILE%\Documents\Projects\%project_name%\src"

set SHORTCUT='%USERPROFILE%\Documents\Projects\%project_name%\Command Prompt.lnk'
set ARGUMENTS='/k \"%%USERPROFILE%%\Documents\Projects\%project_name%\build\shell.bat\"'

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
(echo %application_type% | findstr /c:"GUI">nul) && (
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
		echo       ^<dpiAware xmlns='http://schemas.microsoft.com/SMI/2005/WindowsSettings'^>true^</dpiAware^>
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
		echo cl /nologo /WX /W4 %%warnings%% /MP "..\src\%main_file_name%.c" /Fe"%%app%%" /link /INCREMENTAL:NO /MANIFEST:EMBED /MANIFESTINPUT:"..\res\%%app%%.manifest" /SUBSYSTEM:WINDOWS /FIXED /merge:_RDATA=.rdata
		echo(
		echo del *.obj ^>nul
		echo popd
	) > "%USERPROFILE%\Documents\Projects\%project_name%\build\build.bat"
) || (echo %application_type% | findstr /c:"Console">nul) && (
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
		echo cl /nologo /WX /W4 %%warnings%% /MP "..\src\%main_file_name%.c" /Fe"%%app%%" /link /INCREMENTAL:NO /SUBSYSTEM:CONSOLE /FIXED /merge:_RDATA=.rdata
		echo(
		echo del *.obj ^>nul
		echo popd
	) > "%USERPROFILE%\Documents\Projects\%project_name%\build\build.bat"
) || (echo %application_type% | findstr /c:"Web">nul) && (
	(
		echo ^<html^>
		echo   ^<head^>
		echo     ^<title^>%project_name% WebAssembly HTML5 Canvas^</title^>
		echo     ^<style^>
		echo         body {
		echo             overflow-y: hidden;
		echo         }
		echo(
		echo         #%project_name% {
		echo             position: absolute;
		echo             top: 50%%;
		echo             left: 50%%;
		echo             transform: translate(-50%%, -50%%^);
		echo             height: 100%%;
		echo             touch-action: none;
		echo         }
		echo     ^</style^>
		echo   ^</head^>
		echo   ^<body^>
		echo     ^<canvas id="%project_name%" width=1600 height=900^>^</canvas^>
		echo     ^<script src="%main_file_name%.js"^>^</script^>
		echo   ^</body^>
		echo ^</html^>
	) > "%USERPROFILE%\Documents\Projects\%project_name%\src\index.html"

	(
		echo let wasm = null;
		echo(
		echo WebAssembly.instantiateStreaming(fetch("..\\output\\%project_name%.wasm"^), {
		echo		env: {
		echo		}
		echo }^).then((w^) =^> {
		echo		wasm = w;
		echo }^);
	) > "%USERPROFILE%\Documents\Projects\%project_name%\src\%main_file_name%.js"

	type NUL > "%USERPROFILE%\Documents\Projects\%project_name%\src\%main_file_name%.c"

	(
		echo @echo off
		echo(
		echo set "app=%project_name%"
		echo(
		echo if "%%1" equ "debug" (
		echo		set "clang=-O0 -D_DEBUG -g -fdiagnostics-absolute-paths"
		echo		set "link=-debug"
		echo ^) else (
		echo		set "clang=-Os -DNDEBUG"
		echo		set "link=-ltcg -opt:ref -opt:icf"
		echo ^)
		echo(
		echo set "warnings=-Wno-unused-function -Wno-unused-parameter -Wno-switch"
		echo(
		echo if not exist "%%~dp0..\output" mkdir "%%~dp0..\output"
		echo(
		echo pushd "%%~dp0..\output"
		echo clang %%clang%% -Wall -Wextra %%warnings%% "..\src\main.c" -o "%%app%%.wasm" --target=wasm32 --no-standard-libraries -mbulk-memory -Wl,--no-entry,--export-all,--allow-undefined
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