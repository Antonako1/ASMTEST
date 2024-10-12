:: Install and run the installer:
::  https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/win64/
::
:: Check variables below
::
::
@echo off
CLS
FOR /L %%I in (1, 1, 10) DO ECHO.
setlocal
cd %~dp0
SET "NASM_PATH=%LOCALAPPDATA%\bin\NASM"
SET "TOOLSPATH=C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools"

:: {0|1}
SET /A "RUN_AFTER_COMPILE=1" 

@REM SET /A "VSCMD_DEBUG=2"

call "%NASM_PATH%\nasmpath.bat"
IF %ERRORLEVEL% NEQ 0 (
    ECHO Error setting up nasm. Please make sure it exists in the given path: "%NASM_PATH%"!
    GOTO ERROR_END
)
if not defined DevEnvDir ( 
    call "%TOOLSPATH%\VsDevCmd.bat"
)

cd src
nasm -fwin64 .\main.asm -o .\main.obj
IF %ERRORLEVEL% NEQ 0 (
    ECHO Assembling error! Exiting...
    GOTO ERROR_END
)
cl.exe  .\main.obj                                                                      ^
        "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\user32.lib"     ^
        "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\kernel32.lib"   ^
        "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\gdi32.lib"      ^
        /link /entry:WinMainCRTStartup /SUBSYSTEM:WINDOWS
        @REM /link /entry:MainEntry /SUBSYSTEM:CONSOLE

IF %ERRORLEVEL% NEQ 0 (
    ECHO Compilation error! Exiting...
    GOTO ERROR_END
)
ECHO Compiled binary: .\main.exe

IF %RUN_AFTER_COMPILE% EQU 1 (
    echo running!
    start /wait .\main.exe
    echo.
    echo %ERRORLEVEL%
)
endlocal
GOTO SUCCESS_END

:ERROR_END
endlocal
exit /B 1

:SUCCESS_END
endlocal
exit /B 0