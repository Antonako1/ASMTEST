
section .text
    extern ExitProcess

    global WinMainCRTStartup

WinMainCRTStartup:
    mov rcx, 1
    call ExitProcess

section .data

section .bss
    hInstance       resq    1
    hWnd            resq    1