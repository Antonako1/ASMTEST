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
    call "%TOOLSPATH%\VsDevCmd.bat"
)

cd src
"%MASMPATH%\ml.exe" /c /coff /Fl .\main.asm
IF %ERRORLEVEL% NEQ 0 (
    ECHO Assembling error! Exiting...
    GOTO ERROR_END
)
"%MASMPATH%\ml.exe" /c /coff /Fl .\clck.asm
IF %ERRORLEVEL% NEQ 0 (
    ECHO Assembling error! Exiting...
    GOTO ERROR_END
)
set "Q=\masm32\lib"
cl.exe  .\main.obj .\clck.obj                   ^
        "%Q%\user32.lib"                        ^
        "%Q%\kernel32.lib"                      ^
        "%Q%\gdi32.lib"                         ^
        "%Q%\msvcrt.lib"                        ^
        /link /ENTRY:Start /SUBSYSTEM:WINDOWS /DEBUG
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

:END