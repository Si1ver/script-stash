@echo off
rem This script configures specific Git repository to sign commits and tags using a specified GPG key.
rem Usage: configure_git_sign.cmd (GPG key ID)

setlocal enabledelayedexpansion

rem First argument is the gpg key ID.
set GPG_KEY_ID=%1

if "%GPG_KEY_ID%" == "" (
    echo Usage: configure_git_sign.cmd ^<GPG key ID^>
    echo Example: configure_git_sign.cmd 1234567890ABCDEF
    echo:
    echo To find your GPG key ID, run:
    echo gpg --list-secret-keys --keyid-format=long
    echo:
    echo Error: No GPG key ID provided.
    exit /b 1
)

echo ---------------------------------------------------

rem GPG executable installed in Windows have different settings than one in Git Bash.
rem This script will set the GPG executable path in Git configuration.
echo Searching for GPG executable in PATH...
set GPG_PATH=
for /f "tokens=*" %%i in ('where gpg') do set GPG_PATH=%%i
if "%GPG_PATH%" == "" (
    echo ---------------------------------------------------
    echo Error: GPG executable not found. Please ensure GPG is installed and in your PATH.
    exit /b 1
)
echo GPG executable found at: %GPG_PATH%

echo Configuring Git to sign commits and tags with GPG key: %GPG_KEY_ID%...

git config gpg.format openpgp

if %ERRORLEVEL% neq 0 (
    echo ---------------------------------------------------
    echo Error: git config gpg.format command failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)

git config gpg.program "%GPG_PATH%"

if %ERRORLEVEL% neq 0 (
    echo ---------------------------------------------------
    echo Error: git config gpg.program command failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)

git config user.signingkey !GPG_KEY_ID!

if %ERRORLEVEL% neq 0 (
    echo ---------------------------------------------------
    echo Error: git config user.signingkey command failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)

git config commit.gpgsign true

if %ERRORLEVEL% neq 0 (
    echo ---------------------------------------------------
    echo Error: git config commit.gpgsign command failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)

git config tag.gpgsign true

if %ERRORLEVEL% neq 0 (
    echo ---------------------------------------------------
    echo Error: git config tag.gpgsign command failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)

echo ---------------------------------------------------
echo Git configuration for signing commits and tags with GPG key '%GPG_KEY_ID%' successfully completed.
exit /b 0
