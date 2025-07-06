@echo off
rem This script is used to run the container analysis tool for specified image.
rem Usage: analyze_docker_image.cmd (image name) [arguments ...]

setlocal enabledelayedexpansion

rem First argument is the image name.
rem Remaining arguments are passed to the dive command.
set DIVE_RUN_ARGS=
for /F "tokens=1*" %%A in ("%*") DO (
   SET IMAGE_NAME=%%A
   SET DIVE_RUN_ARGS=%%B
)

if [%IMAGE_NAME%] == [] (
    echo Usage: analyze_docker_image.cmd ^<image name^> [arguments ...]
    echo:
    echo Error: No image name provided.
    exit /b 1
)

echo ---------------------------------------------------
echo Analyzing image '%IMAGE_NAME%':
echo Additional arguments: '%DIVE_RUN_ARGS%'
docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock docker.io/wagoodman/dive "%IMAGE_NAME%" %DIVE_RUN_ARGS%

if %ERRORLEVEL% neq 0 (
    echo ---------------------------------------------------
    echo Error: Docker dive command failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)

echo ---------------------------------------------------
echo Docker dive completed successfully for image '%IMAGE_NAME%'.
exit /b 0
