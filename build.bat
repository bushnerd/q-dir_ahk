@echo off
SET AHKPath=D:\scoop\apps\autohotkey1.1\current\
REM Takes a simple optional command parameter, /t, which starts testing before build.
SET Param1=%1

if "%Param1%"=="/t" (
    start /w "%AHKPath%\Autohotkey.exe" q-dir_ahk.ahk -quiet
)
REM Return code from above (0 if tests all pass) is stored in %errorlevel%
if errorlevel 1 (
    echo   .
    echo   .
    echo Tests failed. Exes not built. Log contents:
    echo   .
    echo   .
    type testLogs\*
    echo   .
    echo   .
    exit /b %errorlevel%
)
"%AHKPath%\compiler\ahk2exe.exe" /in q-dir_ahk.ahk /out q-dir_ahk.exe /compress 0
