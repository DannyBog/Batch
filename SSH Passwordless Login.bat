@echo off

SETLOCAL

:menu
cls

echo ======= SSH Passwordless Login =======
echo --------------------------------------

echo 1. Generate Key
echo 2. Upload Key
echo 3. Login

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

choice /n /c 123q /m "Choose an option: "

if "%errorlevel%"=="1" (cls & goto generate)
if "%errorlevel%"=="2" (cls & goto upload)
if "%errorlevel%"=="3" (cls & goto login)
if "%errorlevel%"=="4" (exit)

:generate
echo ====== Cryptographic Algorithms ======
echo --------------------------------------

echo 1. ecdsa
echo 2. ecdsa-sk
echo 3. ed25519
echo 4. ed25519-sk
echo 5. rsa

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

choice /n /c 12345q /m "Choose an option: "

if "%errorlevel%"=="1" (cls & ssh-keygen -t ecdsa)
if "%errorlevel%"=="2" (cls & ssh-keygen -t ecdsa-sk)
if "%errorlevel%"=="3" (cls & ssh-keygen -t ed25519)
if "%errorlevel%"=="4" (cls & ssh-keygen -t ed25519-sk)
if "%errorlevel%"=="5" (cls & ssh-keygen -t rsa)
if "%errorlevel%"=="6" (exit)

pause
goto menu

:upload
echo ============= Public Key =============
echo --------------------------------------

echo 1. Default Path
echo 2. Custom Path

echo --------------------------------------
echo ========= PRESS 'Q' To Quit ==========
echo(

choice /n /c 12q /m "Choose the path of the public key you want to upload: "

if "%errorlevel%"=="1" (cls & goto default)
if "%errorlevel%"=="2" (cls & goto custom)
if "%errorlevel%"=="3" (exit)

:default
set /p server="Enter the server name: "
for %%g in ("%USERPROFILE%\.ssh\*.pub") do (type "%%g" >> \\%server%\C$\ProgramData\ssh\administrators_authorized_keys)
goto menu

:custom
set /p server="Enter the server name: "
set /p key_path="Enter the full path of the public key you want to upload: "
type "%key_path%" >> \\%server%\C$\ProgramData\ssh\administrators_authorized_keys
goto menu

:login
set /p server="Enter the server name: "
set /p username="Enter an administrative username: "
ssh %username%@%server%
ssh 

ENDLOCAL