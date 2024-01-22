@echo off 

SETLOCAL

for /f "tokens=3" %%g in ('certutil -store -user my ^| findstr "Serial Number"') do (set certID=%%g)
certutil -store -user My %certID% temp.cer
certutil -encode temp.cer %username%.txt
del temp.cer

ENDLOCAL