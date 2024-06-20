@echo off

SETLOCAL EnableDelayedExpansion

echo ============== Licenses ==============
echo --------------------------------------

set /a index=1
for /f "skip=3 tokens=*" %%g in ('cscript C:\Windows\System32\slmgr.vbs /dli') do (
		if !index! LEQ 4 (echo %%g)
		set /a index+=1
)

set /a index=1
for /f "skip=7 tokens=*" %%g in ('cscript "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /dstatus') do (
		(echo %%g | findstr /c:"LICENSE NAME">nul) && (
			for /f "tokens=2 delims=_" %%h in ('echo %%g') do (set edition=%%h)
			echo(
			echo %%g
		) || (
			((echo !edition! | findstr /c:"MAK">nul) || (echo !edition! | findstr /c:"Retail">nul)) && (
				if !index! GEQ 0 if !index! LSS 5 (
					if !index! NEQ 2 (echo %%g)
					set /a index+=1
				)  else (
					set "edition="
					set /a index=-3
				)
			) || (echo !edition! | findstr /c:"KMS">nul) && (
				if !index! GEQ 0 if !index! LEQ 5 (
					if !index! NEQ 2 (echo %%g)
					set /a index+=1
				) else (
					set "edition="
					set /a index=-9
				)
			)
		)

		if !index! LEQ 0 (set /a index+=1)
)

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

pause

ENDLOCAL