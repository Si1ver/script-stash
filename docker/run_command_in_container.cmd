@echo off
rem This script is used to run a command in a Docker container.
rem Container will be deleted after exit.
rem Usage: run_command_in_container.cmd (image name) [arguments ...]

setlocal enabledelayedexpansion

rem First argument is the image name.
rem Remaining arguments are passed to the docker run command.
set IMAGE_RUN_ARGS=
for /F "tokens=1*" %%A in ("%*") DO (
   SET IMAGE_NAME=%%A
   SET IMAGE_RUN_ARGS=%%B
)

if [%IMAGE_NAME%] == [] (
    echo Usage: run_command_in_container.cmd ^<image name^> [arguments ...]
    echo:
    echo Error: No image name provided.
    exit /b 1
)

echo ---------------------------------------------------
echo Checking docker image '%IMAGE_NAME%':
docker inspect --type image --format "{{index .RepoDigests 0}}" %IMAGE_NAME%

if %ERRORLEVEL% neq 0 (
    echo Error: Docker image '%IMAGE_NAME%' not found.
    exit /b 1
)

echo ---------------------------------------------------
echo Running container:
echo Image: '%IMAGE_NAME%'
echo Arguments: '%IMAGE_RUN_ARGS%'
docker run --rm %IMAGE_NAME% %IMAGE_RUN_ARGS%

if %ERRORLEVEL% neq 0 (
    echo ---------------------------------------------------
    echo Error: Docker run command failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)

echo ---------------------------------------------------
echo Docker container run completed successfully.
exit /b 0
