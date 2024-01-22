@echo off

SETLOCAL EnableDelayedExpansion

:menu
cls

echo ============== Location ==============
echo --------------------------------------

echo 1. User
echo 2. Computer

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

choice /n /c 12q /m "Select a certificate store location: "

if "%errorlevel%"=="1" (cls & goto user)
if "%errorlevel%"=="2" (cls & goto computer)
if "%errorlevel%"=="3" (exit)

:user
echo ============= User Store =============
echo --------------------------------------

set /a index=1
for /f "skip=2 delims=" %%g in ('certutil -user -enumstore ^| findstr /v :') do (
	(echo %%g | findstr """">nul) && (
		for /f tokens^=1^ delims^=^" %%h in ('echo %%g') do (set store=%%h)
		set store=!store:~2!
		set /a index-=1
		set stores[!index!]=!store!
		set /a index+=1

		for /f tokens^=2^ delims^=^" %%h in ('echo %%g') do (echo !index!. %%h)
		set /a index+=1
	) || (
		for /f tokens^=1^ delims^=^" %%h in ('echo %%g') do (set store=%%h)
		set store=!store:~2!
		if !store! NEQ ACRS (
			set /a index-=1
			set stores[!index!]=!store!
			set /a index+=1
			echo !index!. !store!
			set /a index+=1
		)
	)
)

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

set "input="
set /p input="Choose an index: " & cls
if not defined input (goto menu)
if /i %input%==Q (exit)

set "location=CurrentUser"
goto cert

:computer
echo =========== Computer Store ===========
echo --------------------------------------

set /a index=1
for /f "skip=2 delims=" %%g in ('certutil -enumstore ^| findstr /v :') do (
	(echo %%g | findstr """">nul) && (
		for /f tokens^=1^ delims^=^" %%h in ('echo %%g') do (set store=%%h)
		set store=!store:~2!
		set /a index-=1
		set stores[!index!]=!store!
		set /a index+=1

		for /f tokens^=2^ delims^=^" %%h in ('echo %%g') do (echo !index!. %%h)
		set /a index+=1
	) || (
		for /f tokens^=1^ delims^=^" %%h in ('echo %%g') do (set store=%%h)
		set store=!store:~2!
		if !store! NEQ ACRS (
			set /a index-=1
			set stores[!index!]=!store!
			set /a index+=1
			echo !index!. !store!
			set /a index+=1
		)
	)
)

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

set "input="
set /p input="Choose an index: " & cls
if not defined input (goto menu)
if /i %input%==Q (exit)

set "location=LocalMachine"

:cert
echo ============ Certificates ============
echo --------------------------------------

set /a index=%input% - 1
call set store=%%stores[%index%]%%

set /a index=1
chcp 437>nul
for /f "delims=" %%g in ('
PowerShell ^
"
	$entries ^= @(^)^; ^
	$store ^= \"Cert:\%location%\%store%\" -replace \"\s\s+\"^, \"\"^; ^
	$certificates ^= Get-ChildItem $store^; ^
	foreach ($certificate in $certificates^) {^; ^
		$date ^= $certificate ^| Select-Object -ExpandProperty NotAfter^; ^
		$subject ^= $certificate ^| Select-Object -ExpandProperty Subject^; ^
		if ($subject.StartsWith(\"E\"^)^) {^; ^
			$entries +^= [PSCustomObject]@{Name^=$subject.Split(\"=,\"^)[3].Trim('"`\"'^)^; ExpirationDate^=\"(\" + $date + \")\"}^; ^
		} else {^; ^
			$entries +^= [PSCustomObject]@{Name^=$subject.Split(\"=,\"^)[1].Trim('"`\"'^)^; ExpirationDate^=\"(\" + $date + \")\"}^; ^
		}^; ^
	}^; ^
	$entries ^= $entries ^| Sort-Object Name^; ^
	$entries ^| Format-Table -HideTableHeaders
"
') do (echo !index!. %%g & set /a index+=1)

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

set "input="
set /p input="Choose an index: " & cls
if not defined input (goto menu)
if /i %input%==Q (exit)

set /a index=%input%-1
for /f "delims=" %%g in ('
PowerShell ^
"
	$entries ^= @(^)^; ^
	$store ^= \"Cert:\%location%\%store%\" -replace \"\s\s+\"^, \"\"^; ^
	$certificates ^= Get-ChildItem $store^; ^
	foreach ($certificate in $certificates^) {^; ^
		$subject ^= $certificate ^| Select-Object -ExpandProperty Subject^; ^
		if ($subject.StartsWith(\"E\"^)^) {^; ^
			$entries +^= [PSCustomObject]@{Name^=$subject.Split(\"=,\"^)[3].Trim('"`\"'^)^; Subject^=$subject}^; ^
		} else {^; ^
			$entries +^= [PSCustomObject]@{Name^=$subject.Split(\"=,\"^)[1].Trim('"`\"'^)^; Subject^=$subject}^; ^
		}^; ^
	}^; ^
	$entries ^= $entries ^| Sort-Object Name^; ^
	$entries[%index%] ^| Select-Object Subject ^| Format-Table -HideTableHeaders
"
') do (set subject=%%g)

set /a element=0
for /f "delims=" %%g in ('
PowerShell ^
"
	$entries ^= @(^)^; ^
	$store ^= \"Cert:\%location%\%store%\" -replace \"\s\s+\"^, \"\"^; ^
	$certificates ^= Get-ChildItem $store^; ^
	foreach ($certificate in $certificates^) {^; ^
		$subject ^= $certificate ^| Select-Object -ExpandProperty Subject^; ^
		$extensions ^= $certificate.Extensions ^| Where-Object {$_.Oid.FriendlyName -eq \"Subject Alternative Name\"}^; ^
		if ($extensions^) {$extensions ^= $extensions.Format($true^)}^; ^
		if ($subject.StartsWith(\"E\"^)^) {^; ^
			$entries +^= [PSCustomObject]@{Name^=$subject.Split(\"=,\"^)[3].Trim('"`\"'^)^; Extensions^=$extensions}^; ^
		} else {^; ^
			$entries +^= [PSCustomObject]@{Name^=$subject.Split(\"=,\"^)[1].Trim('"`\"'^)^; Extensions^=$extensions}^; ^
		}^; ^
	}^; ^
	$entries ^= $entries ^| Sort-Object Name^; ^
	$entries[%index%] ^| Select-Object -ExpandProperty Extensions ^| Format-Table -HideTableHeaders
"
') do (set extensions[!element!]="%%g" & set /a element+=1)

echo [Version]>> "%~dp0policy.inf"
echo Signature = "$Windows NT$">> "%~dp0policy.inf"

echo(>> "%~dp0policy.inf"

echo [NewRequest]>> "%~dp0policy.inf"
echo MachineKeySet = TRUE>> "%~dp0policy.inf"
echo RequestType = PKCS10>> "%~dp0policy.inf"
echo Subject = "%subject%">> "%~dp0policy.inf"
echo KeySpec = ^1>> "%~dp0policy.inf"
echo KeyLength = 2048>> "%~dp0policy.inf"
echo Exportable = FALSE>> "%~dp0policy.inf"
echo SMIME = FALSE>> "%~dp0policy.inf"
echo PrivateKeyArchive = FALSE>> "%~dp0policy.inf"
echo UserProtected = FALSE>> "%~dp0policy.inf"
echo UseExistingKeySet = FALSE>> "%~dp0policy.inf"
echo ProviderName = "Microsoft RSA SChannel Cryptographic Provider">> "%~dp0policy.inf"
echo ProviderType = 12>> "%~dp0policy.inf"
echo KeyUsage = 0xa0>> "%~dp0policy.inf"

echo(>> "%~dp0policy.inf"

echo [RequestAttributes]>> "%~dp0policy.inf"
echo CertificateTemplate = Workstation Authentication>> "%~dp0policy.inf"

echo(>> "%~dp0policy.inf"

echo [EnhancedKeyUsageExtension]>> "%~dp0policy.inf"
echo OID = 1.3.6.1.5.5.7.3.1>> "%~dp0policy.inf"
echo OID = 1.3.6.1.5.5.7.3.2>> "%~dp0policy.inf"

if defined extensions[0] (
	echo(>> "%~dp0policy.inf"

	echo [Extensions]>> "%~dp0policy.inf"
	echo 2.5.29.17 = "{text}">> "%~dp0policy.inf"
	set /a length=%element%-1
	for /l %%g in (0,1,!length!) do (
		call set extension=%%extensions[%%g]%%
		for /f "tokens=1,2 delims==" %%h in ('echo !extension!') do (
			set field1=%%h
			set field2=%%i
			set field1=!field1:~1!
			set field2=!field2:~0,-2!
			
			if %%g NEQ !length! (
				set "ampersand=&"
			) else (
				set "ampersand="
			)

			if "!field1!"=="DNS Name" (echo _continue_ = DNS=!field2!!ampersand!>> "%~dp0policy.inf")
			if "!field1!"=="IP Address" (echo _continue_ = IPAddress=!field2!!ampersand!>> "%~dp0policy.inf")
		)
		set "extensions[%%g]="
	)
)

certreq -new "%~dp0policy.inf" "%~dp0%COMPUTERNAME%.txt"
goto menu

ENDLOCAL