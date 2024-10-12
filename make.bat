@echo off
CLS
FOR /L %%I in (1, 1, 10) DO ECHO.
setlocal
cd %~dp0
SET "TOOLSPATH=C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools"
SET "MASMPATH=C:\masm32\bin"
:: {0|1}
SET /A "RUN_AFTER_COMPILE=1" 

if not defined DevEnvDir ( 
    call "%TOOLSPATH%\VsDevCmd.bat" -arch=amd64
)

cd src
"%MASMPATH%\ml.exe" /c /coff .\main.asm
"%MASMPATH%\ml.exe" /c /coff .\clck.asm
IF %ERRORLEVEL% NEQ 0 (
    ECHO Assembling error! Exiting...
    GOTO ERROR_END
)
cl.exe  .\main.obj                                                                      ^
        "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\user32.lib"     ^
        "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\kernel32.lib"   ^
        "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\gdi32.lib"      ^
        /link /ENTRY:Start /SUBSYSTEM:WINDOWS
IF %ERRORLEVEL% NEQ 0 (
    ECHO Compilation error! Exiting...
    GOTO ERROR_END
)
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