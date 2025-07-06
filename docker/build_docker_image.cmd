@echo off
rem This script is used to build a Docker container while developing or testing it.
rem Usage: build_docker_image.cmd (build directory) (docker file) (image tag) [arguments ...]

setlocal enabledelayedexpansion

rem First argument is the build directory.
rem Second argument is the Dockerfile name.
rem Third argument is the image tag.
rem Remaining arguments are passed to the docker build command.
set IMAGE_BUILD_ARGS=
for /F "tokens=1-3*" %%A in ("%*") DO (
   SET BUILD_DIRECTORY=%%A
   SET DOCKER_FILE=%%B
   SET IMAGE_TAG=%%C
   SET IMAGE_BUILD_ARGS=%%D
)

if [%BUILD_DIRECTORY%] == [] (
    echo Usage: build_docker_image.cmd ^<build directory^> ^<docker file^> ^<image tag^> [arguments ...]
    echo:
    echo Error: No build directory provided.
    exit /b 1
)

if [%DOCKER_FILE%] == [] (
    echo Usage: build_docker_image.cmd ^<build directory^> ^<docker file^> ^<image tag^> [arguments ...]
    echo:
    echo Error: No Dockerfile provided.
    exit /b 1
)

if [%IMAGE_TAG%] == [] (
    echo Usage: build_docker_image.cmd ^<build directory^> ^<docker file^> ^<image tag^> [arguments ...]
    echo:
    echo Error: No image tag provided.
    exit /b 1
)

echo ---------------------------------------------------
echo Building Docker image with the following parameters:
echo Build Directory: '%BUILD_DIRECTORY%'
echo Dockerfile: '%BUILD_DIRECTORY%\%DOCKER_FILE%'
echo Image Tag: '%IMAGE_TAG%'
echo Additional Arguments: '%IMAGE_BUILD_ARGS%'
docker build --file "%BUILD_DIRECTORY%\\%DOCKER_FILE%" --tag "%IMAGE_TAG%" "%BUILD_DIRECTORY%" %IMAGE_BUILD_ARGS%

if %ERRORLEVEL% neq 0 (
    echo ---------------------------------------------------
    echo Error: Docker build command failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)

echo ---------------------------------------------------
echo Docker image '%IMAGE_TAG%' built successfully.
exit /b 0
