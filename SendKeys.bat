@if (@CodeSection == @Batch) @then

@echo off
SETLOCAL

REM The first line above is...
REM in Batch: a valid IF command that does nothing.
REM in JScript: a conditional compilation IF statement that is false,
REM             so this section is omitted until next "at-sign end".

REM Refer to:
REM https://technet.microsoft.com/en-us/library/ee156592.aspx
REM https://stackoverflow.com/questions/15167742/execute-wshshell-command-from-a-batch-script

REM ##### Examples #####
REM For running process (The match is first attempted by full title, then title beginning, then title ending):
REM SendKeys.bat "chrome" "^thttps://google.com{ENTER}{PAUSE}{PAUSE}{PAUSE}Steve Jobs{ENTER}"

REM For new process: (The match has to be either by full path or by name if name is included in the %PATH% environment variable):
REM SendKeys.bat "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe -inprivate" "https://google.com{ENTER}{PAUSE}{PAUSE}{PAUSE}Steve Jobs{ENTER}"

if "%~2"=="" (
	echo Usage: %~nx0 "window title | full path" "keys to send"
	goto :EOF
)

cscript /nologo /e:JScript "%~f0" "%~1" "%~2"
goto :EOF

ENDLOCAL
@end

// JScript section

var wsh = WScript.CreateObject('WScript.Shell');
var args = {title: WScript.Arguments(0), keys: WScript.Arguments(1)};

function type(what) {
	var keys = what.split('{PAUSE}');

	for (var i = 0; i < keys.length; ++i) {
		wsh.SendKeys(keys[i]);
		WScript.Sleep(1000);
	}
}

if (wsh.AppActivate(args.title)) {
	type(args.keys);
} else {
	var app = wsh.Exec(args.title);
	WScript.Sleep(1000);
	wsh.AppActivate(app.ProcessID);
	type(args.keys);
}