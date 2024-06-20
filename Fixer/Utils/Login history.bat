@echo off 

SETLOCAL

REM set /p user_name="Enter a username: "

for /f "delims=() tokens=1,2,4,6" %%g in ('dsquery * -filter "(objectCategory=Computer)" -attr name description -limit 0') do (
	if %%h==%user_name% (echo %%g(%%h^), Last checked: (%%i^), IP Address: (%%j^))
)

pause

ENDLOCAL