@echo off
setlocal
cd /d "%~dp0"

set "OLD_CI=%CI%"
set "CI=1"

echo.
echo   MK 3D standalone build
echo   ======================
echo   Building only Mortal Kombat: Deception and Mortal Kombat: Armageddon.
echo   MKDA is intentionally not part of this build.
echo.

if not exist "recomp\mkd\assets\default.xbe" (
    echo   [MKD] Missing recomp\mkd\assets\default.xbe
    echo         Put your Mortal Kombat: Deception Xbox files in recomp\mkd\assets\
    goto :fail
)

if not exist "recomp\mka\assets\default.xbe" (
    echo   [MKA] Missing recomp\mka\assets\default.xbe
    echo         Put your Mortal Kombat: Armageddon Xbox files in recomp\mka\assets\
    goto :fail
)

echo   [1/2] Mortal Kombat: Deception
call "recomp\mkd\build.bat"
if errorlevel 1 goto :fail
if not exist "recomp\mkd\out\build\release\MKD.exe" (
    echo   MKD build completed but MKD.exe was not found.
    goto :fail
)

echo.
echo   [2/2] Mortal Kombat: Armageddon
call "recomp\mka\build.bat"
if errorlevel 1 goto :fail
if not exist "recomp\mka\out\build\release\MKA.exe" (
    echo   MKA build completed but MKA.exe was not found.
    goto :fail
)

echo.
echo   ================================================
echo   Both standalone games built successfully.
echo.
echo   Deception:
echo     %CD%\recomp\mkd\out\build\release\MKD.exe
echo.
echo   Armageddon:
echo     %CD%\recomp\mka\out\build\release\MKA.exe
echo.
echo   Add those two executables separately to Steam.
echo   Keep each executable in its own game directory with its runtime files and assets.
echo   ================================================
echo.

if defined OLD_CI (set "CI=%OLD_CI%") else set "CI="
pause
exit /b 0

:fail
if defined OLD_CI (set "CI=%OLD_CI%") else set "CI="
echo.
echo   BUILD FAILED. Read the last message above.
echo.
pause
exit /b 1
