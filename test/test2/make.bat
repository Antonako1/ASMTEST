@echo off
ml /c /coff test.s
cl.exe test.obj /link /out:test.exe /subsystem:console \masm32\lib\msvcrt.lib \masm32\lib\kernel32.lib \masm32\lib\user32.lib
test.exe