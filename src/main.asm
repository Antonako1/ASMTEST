.386
.model          flat, stdcall
option          casemap:none

include         \masm32\include\windows.inc
include         \masm32\include\user32.inc
include         \masm32\include\kernel32.inc
include         \masm32\include\gdi32.inc

includelib      \masm32\lib\kernel32.lib
includelib      \masm32\lib\user32.lib
includelib      \masm32\lib\gdi32.lib

WinMain         proto   :DWORD, :DWORD, :DWORD, :DWORD

.DATA
    winClassName    db  "ASMTEST", 0
    winAppName      db  "ASMTEST, GUI", 0
    winClass        WNDCLASSEX { SIZEOF WNDCLASSEX, CS_HREDRAW or CS_VREDRAW, WndProc, 0, 0, 0, IDI_APPLICATION, 0, COLOR_3DSHADOW + 1, 0, winClassName, IDI_APPLICATION };
    msgText         db 'WndProc run', 0
    msgCaption      db 'WndProc is running!', 0
    MB_OKCANCEL     equ 1
    WindowHeight    dd  640
    WindowWidth     dd  480

.CODE
Start:
WinMainCRTStartup proc
    LOCAL   msg:MSG
    LOCAL   hWnd:HWND
    LOCAL   hInst:HINSTANCE

    push    NULL
    call    GetModuleHandle
    mov     winClass.hInstance, eax
    mov     eax, hInst

    push    IDI_APPLICATION
    push    NULL
    call    LoadIcon
    mov     winClass.hIcon, eax
    mov     winClass.hIconSm, eax
    
    push    IDC_ARROW
    push    NULL
    call    LoadCursor
    mov     winClass.hCursor, eax
    
    lea     eax, winClass
    push    eax
    call    RegisterClassExA

    push    NULL
    push    hInst
    push    NULL
    push    NULL
    mov     eax, [WindowHeight]
    push    eax
    mov     eax, [WindowWidth]
    push    eax
    push    CW_USEDEFAULT
    push    CW_USEDEFAULT
    push    WS_OVERLAPPEDWINDOW + WS_VISIBLE
    push    OFFSET winAppName
    push    OFFSET winClassName
    push    0
    call    CreateWindowExA

    cmp     eax, NULL
    je      WinMainReturn
    mov     hWnd, eax

    push eax                        ; force paint
    call UpdateWindow

    MessageLoop:
        push    0
        push    0
        push    NULL
        lea     eax, msg
        push    eax
        call    GetMessage
        cmp     eax, 0
        je      MessagesDone

        lea     eax, msg
        push    eax
        call    TranslateMessage

        lea     eax, msg
        push    eax
        call    DispatchMessage

        jmp MessageLoop
    MessagesDone:
        mov eax, msg.wParam
    WinMainReturn:
        ret
WinMainCRTStartup endp


WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    LOCAL   ps:PAINTSTRUCT
    LOCAL   rect:RECT
    LOCAL   hdc:HDC

    ;=========================
    cmp     uMsg, WM_DESTROY
    je      CASE_WM_DESTROY
    ;=========================
    cmp     uMsg, WM_PAINT
    je      CASE_WM_PAINT
    ;=========================
    cmp     uMsg, WM_SIZE
    je      CASE_WM_SIZE
    ;=========================
    jmp     CASE_DEFAULT
    ;=========================
    CASE_WM_SIZE:
        lea     eax, lParam
        mov     ebx, eax
        shr     eax, 16
        mov     [WindowHeight], eax
        mov     eax, ebx
        shl     eax, 16
        shr     eax, 16
        mov     [WindowWidth], eax
        ret
    CASE_WM_PAINT:
        lea     eax, ps
        push    eax
        push    hWnd
        call    BeginPaint
        mov     hdc, eax

        push    TRANSPARENT
        push    hdc
        call    SetBkMode

        lea     eax, rect
        push    eax
        push    hWnd
        call    GetClientRect

        mov     eax, [WindowHeight]
        shr     eax, 1
        mov     rect.top, eax

        push    DT_CENTER + DT_VCENTER + DT_WORDBREAK + DT_EDITCONTROL
        lea     eax, rect
        push    eax
        push    -1
        push    OFFSET winAppName
        push    hdc
        call    DrawText

        lea     eax, ps
        push    eax
        push    hWnd
        call    EndPaint

        xor     eax, eax
        ret
    CASE_WM_DESTROY:
        push    0
        call    PostQuitMessage
        xor     eax, eax
        ret
    CASE_DEFAULT:
        push    lParam
        push    wParam
        push    uMsg
        push    hWnd
        call    DefWindowProc
        ret
WndProc endp

END Start