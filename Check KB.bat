@echo off

SETLOCAL EnableDelayedExpansion

for %%g in ("%~dp0*.txt") do (set text_file=%%g)
set /p kb="Enter a KB number: "
set "header=Caption                                     CSName          Description      HotFixID  InstalledBy          InstalledOn"
set separator="=========================================== =============== ================ ========= ==================== ==========="
set separator=%separator:"=%

if defined text_file (
	echo(
	echo %header%
	echo %separator%
	if defined kb (
		for /f "usebackq" %%g in ("%text_file%") do (
			for /f "usebackq skip=1 tokens=*" %%h in (`wmic /node:"%%g" qfe where "HotfixID = '%kb%'" get
									Caption^,CSName^,Description^,HotfixID^,InstalledBy^,InstalledOn 2^>nul`) do (
				if not defined line (set line=%%h)
			)

			(echo !line! | findstr /c:%kb%>nul) && (
				echo !line!
			) || (
				echo                                             %%g
			)2>nul
			set "line="
		)
	) else (
		for /f "usebackq" %%g in ("%text_file%") do (
			for /f "usebackq tokens=*" %%h in (`wmic /node:"%%g" qfe where "Description = 'Security Update'" get
								Caption^,CSName^,Description^,HotfixID^,InstalledBy^,InstalledOn 2^>nul ^| sort /r`) do (
				if not defined line (set line=%%h)
			)
			
			(echo !line! | findstr /c:"Security Update">nul) && (
				echo !line!
			) || (
				echo                                             %%g
			)2>nul
			set "line="
		)
	)
) else (
	echo Missing text file :(
)

pause

ENDLOCAL