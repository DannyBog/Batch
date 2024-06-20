@echo off

SETLOCAL

:menu
cls

set /p file_path="Enter a file path: "

for /f "skip=1" %%g in ('certutil -hashfile %file_path% MD5') do (
	if not defined md5 (set md5=%%g)
)

for /f "skip=1" %%g in ('certutil -hashfile %file_path% SHA1') do (
	if not defined sha1 (set sha1=%%g)
)

for /f "skip=1" %%g in ('certutil -hashfile %file_path% SHA256') do (
	if not defined sha256 (set sha256=%%g)
)

for /f "skip=1" %%g in ('certutil -hashfile %file_path% SHA512') do (
	if not defined sha512 (set sha512=%%g)
)

echo(
echo MD5: %md5%
echo SHA1: %sha1%
echo SHA256: %sha256%
echo SHA512: %sha512%
echo(

pause

set "md5="
set "sha1="
set "sha256="
set "sha512="

goto menu

ENDLOCAL