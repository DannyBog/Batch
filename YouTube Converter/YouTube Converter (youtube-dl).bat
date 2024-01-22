@echo off

SETLOCAL EnableDelayedExpansion

title YouTube Converter

:menu
cls

echo =============== Converter ===============
echo -----------------------------------------
echo 1. MP3
echo 2. MP4
echo -----------------------------------------
echo =========== PRESS 'Q' TO QUIT ===========
echo(

choice /n /c 12q /m "Select a file format: "
if %errorlevel%==3 (exit)
set /p url="Enter a YouTube video URL: "
if %errorlevel%==1 (cls & .\Utils\youtube-dl.exe --extract-audio --audio-format mp3 --output "mp3\%%(title)s.%%(ext)s" %url% & pause & goto menu)

cls

set /a length=0
for /f "skip=3 tokens=1,4,*" %%g in ('.\Utils\youtube-dl.exe -F "%url%"') do (
	(echo %%h | findstr /c:p>nul) && (
		for /f "tokens=1 delims=p" %%j in ('echo %%h') do (set video_res=%%j)
		for /f "tokens=6 delims=," %%j in ('echo %%i') do (set video_size=%%j)

		if !video_res! GTR !res! (
			if defined res (set /a length+=1)
		)

		if !video_res! GEQ !res! (
			set code=%%g
			set res=!video_res!
			set size=!video_size:~1!
		)

		set format_codes[!length!]=%%g
		set resolutions[!length!]=!video_res!
		set sizes[!length!]=!video_size:~1!
	)
)
set format_codes[%length%]=%code%
set resolutions[%length%]=%res%
set sizes[%length%]=%size%

echo ============== Converter ==============
echo ---------------------------------------

for /l %%g in (0, 1, %length%) do (
	set /a index = %%g + 1
	call set res=%%resolutions[%%g]%%
	call set size=%%sizes[%%g]%%
	echo !index!. !res!p (!size!^)
)

echo ---------------------------------------
echo ========== PRESS 'Q' To Quit ==========
echo(

set /p input="Choose an index: "

if /i %input%==Q (exit)

cls

set "res="
set /a index = %input% - 1
call set code=%%format_codes[%index%]%%
.\Utils\youtube-dl.exe --format %code%+bestaudio --recode-video mp4 --output "mp4\%%(title)s.%%(ext)s" %url%

pause

goto menu

ENDLOCAL