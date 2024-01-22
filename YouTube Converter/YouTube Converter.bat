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
if %errorlevel%==1 (cls & .\Utils\yt-dlp.exe --extract-audio --audio-format mp3 --output "mp3\%%(title)s.%%(ext)s" %url% & pause & goto menu)

cls

set /a length=0
for /f "skip=5 tokens=1,3,4" %%g in ('.\Utils\yt-dlp.exe -F "%url%"') do (
	(echo %%g| findstr /r "^[1-9][0-9]*$">nul) && (echo %%i| findstr /r "^[1-9][0-9]*$">nul) && (
		for /f "tokens=2 delims=x" %%k in ('echo %%h') do (set video_res=%%k)

		if !video_res! GTR !res! (
			if defined res (set /a length+=1)
		)

		if !video_res! GEQ !res! (
			set code=%%g
			set res=!video_res!
		)

		set format_codes[!length!]=%%g
		set resolutions[!length!]=!video_res!
	)
)
set format_codes[%length%]=%code%
set resolutions[%length%]=%res%

echo ============== Converter ==============
echo ---------------------------------------

for /l %%g in (0, 1, %length%) do (
	set /a index = %%g + 1
	call set res=%%resolutions[%%g]%%
	echo !index!. !res!p
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
.\Utils\yt-dlp.exe --format %code%+bestaudio --recode-video mp4 --output "mp4\%%(title)s.%%(ext)s" %url%

pause

goto menu

ENDLOCAL