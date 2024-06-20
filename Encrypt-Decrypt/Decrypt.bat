@echo off

SETLOCAL EnableDelayedExpansion

for %%g in ("%~dp0*.7z") do (set zip_file="%%g")

if defined zip_file (
	if not exist "C:\Program Files\7-Zip\7z.exe" (
		chcp 437>nul

		PowerShell ^
			$url = \"https://7-zip.org/\" + (Invoke-WebRequest -UseBasicParsing -Uri \"https://7-zip.org/download.html\" ^| Select-Object -ExpandProperty Links ^| Where-Object {($_.outerHTML -match \"Download\"^) -and ($_.href -like \"a/*\"^) -and ($_.href -like \"*-x64.msi\"^)} ^| Select-Object -First 1 ^| Select-Object -ExpandProperty href^); ^
			$path = Join-Path -Path $pwd -ChildPath (Split-Path -Path $url -Leaf^); ^
			Invoke-WebRequest $url -OutFile $path; ^
			Start-Process "msiexec.exe" -ArgumentList \"/i "$path" /passive /qn\" -Wait; ^
			Remove-Item $path
			
	)
	set /p password="Enter password: "
	"C:\Program Files\7-Zip\7z.exe" x %zip_file% -p!password! -o%~dp0
) else (
	echo Missing zip file :(
)

pause

ENDLOCAL