@echo off

if not exist %windir%\system32\wbem goto TryInstall

cd /d %WINDIR%\system32\wbem

net stop winmgmt /y

if exist Rep_bak rd Rep_bak /s /q
ren Repository Rep_bak

for %%g in (*.dll) do (RegSvr32 -s %%g)
for %%g in (*.exe) do (call :FixSrv %%g)
for %%g in (*.mof,*.mfl) do (Mofcomp %%g)

net start winmgmt
goto End
 
:FixSrv
if /I (%1) == (wbemcntl.exe) goto SkipSrv
if /I (%1) == (wbemtest.exe) goto SkipSrv
if /I (%1) == (mofcomp.exe) goto SkipSrv
 
:SkipSrv
goto Skip
 
:TryInstall
if not exist wmicore.exe goto End
wmicore /s
net start winmgmt

:End
del C:\WMI.bat
shutdown /r /f /t 0

:Skip