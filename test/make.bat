@echo off
setlocal
cd %~dp0
SET "TOOLSPATH=C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools"
if not defined DevEnvDir ( 
    call "%TOOLSPATH%\VsDevCmd.bat"
)
cd test
cl.exe test.c user32.lib gdi32.lib

call test.exe
endlocal