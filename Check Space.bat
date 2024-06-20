@echo off

SETLOCAL EnableDelayedExpansion

chcp 437>nul

for %%g in ("%~dp0*.txt") do (set text_file=%%g)

if defined text_file (
	for /f "usebackq" %%g in ("%text_file%") do (
		echo ========== %%g ==========

		for /f "skip=1" %%h in ('wmic /node:"%%g" LogicalDisk where "DeviceID='c:'" get FreeSpace 2^>nul') do (
			if not defined free_space (set free_space=%%h)
		)

		for /f %%h in ('powershell (!free_space! / 1024 / 1024 / 1024^)') do (set free_space=%%h)

		for /f "tokens=1,2 delims=." %%h in ('echo !free_space!') do (
			set exponent=%%h
			set mantissa=%%i
		)

		set free_space=

		if defined mantissa (
			echo !exponent!.!mantissa:~0,2! GB
		) else (
			echo %%g is offline :(
		)
		echo(
	)
) else (
	set /p machine="Enter a computer name (or IP): "

	for /f "skip=1" %%g in ('wmic /node:"!machine!" LogicalDisk where "DeviceID='c:'" get FreeSpace 2^>nul') do (
		if not defined free_space (set free_space=%%g)
	)

	for /f %%g in ('powershell (!free_space! / 1024 / 1024 / 1024^)') do (set free_space=%%g)

	for /f "tokens=1,2 delims=." %%g in ('echo !free_space!') do (
		set exponent=%%g
		set mantissa=%%h
	)

	if defined mantissa (
		echo !exponent!.!mantissa:~0,2! GB
	) else (
		echo !machine! is offline :(
	)
)

pause

ENDLOCAL