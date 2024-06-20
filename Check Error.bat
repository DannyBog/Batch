@echo off

SETLOCAL EnableDelayedExpansion

set /p error="Enter an error code: "

for /f "tokens=2,3 delims=(/:." %%g in ('certutil -error %error%') do (
	set "continue="

	if not defined source1 (
		set source1=%%g
		(echo %%h | findstr /v /c:"--">nul) && (set source2=%%h)
		set "continue=true"
	)

	if not defined continue (
		if not defined message1 (
			if defined source2 (
				set message1=%%g
				set message2=%%h
			) else (
				set message1=%%g
			)
		)
	)
)

echo(
echo %message1:~1% (%source1%^)
if defined message2 (
	echo %message2:~1% (%source2%^)
) else (
	if defined source2 (echo %message1:~1% (%source2%^))
)

pause

ENDLOCAL