@echo off

SETLOCAL

REM set /p user_name="Enter a username: "

for /f "skip=1 tokens=1-2" %%g in ('dsquery * -filter "(&(objectCategory=Person)(objectClass=User)(!userAccountControl:1.2.840.113556.1.4.803:=2))" -attr sAMAccountName lockoutTime -limit 0') do (
	if /i "%%h" GEQ "1" (dsquery user -samid %%g | dsmod user -disabled no)
)

pause

ENDLOCAL