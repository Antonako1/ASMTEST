.386
.model          flat, stdcall
OPTION          casemap:NONE

include         \masm32\include\windows.inc
include         \masm32\include\user32.inc
include         \masm32\include\kernel32.inc
include         \masm32\include\gdi32.inc
include         \masm32\include\msvcrt.inc

includelib      \masm32\lib\kernel32.lib
includelib      \masm32\lib\user32.lib
includelib      \masm32\lib\gdi32.lib

update_get_stS  proto
WinMain         proto   :DWORD, :DWORD, :DWORD, :DWORD
extern C        sprintf :proc


CLOCK_REF_RATE      equ 1

.DATA
    winClassName    db  "ASMTEST", 0
    winAppName      db  "ASMTEST, GUI", 0
    winClass        WNDCLASSEX { SIZEOF WNDCLASSEX, CS_HREDRAW or CS_VREDRAW, WndProc, 0, 0, 0, IDI_APPLICATION, 0, COLOR_3DSHADOW + 1, 0, winClassName, IDI_APPLICATION };
    WindowHeight    dd  640
    WindowWidth     dd  640
    stS SYSTEMTIME  <>
    buffer          DB  16 DUP(?)               ; FOR SPRINTF
    formatStr       DB  "%02d:%02d:%02d.%02d", 0

    msgTitle        DB  "Oh no!", 0
    msgText         DB  "Failure somewhere!", 0
.CODE
Start:
WinMainCRTStartup proc
    LOCAL   msg:MSG
    LOCAL   hWnd:HWND
    ; LOCAL   hInst:HINSTANCE

    push    NULL
    call    GetModuleHandle
    mov     winClass.hInstance, eax

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
    push    OFFSET winClass.hInstance
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
    push    eax
    call    UpdateWindow

    push    NULL
    push    CLOCK_REF_RATE
    push    1
    push    hWnd
    call    SetTimer

    push    OFFSET stS
    call    update_get_stS

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
    LOCAL   hdc:HDC
    ; LOCAL: CIRCLE, LINE x3 || CIRCLE x2, LINE x4 (w/ ms)

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
    cmp     uMsg, WM_TIMER
    je      CASE_WM_TIMER
    ;=========================
    jmp     CASE_DEFAULT
    ;=========================
    CASE_WM_TIMER:
        push    OFFSET stS
        call    update_get_stS
        
        push    1
        push    NULL
        push    hWnd
        call    InvalidateRect
        jmp     CASE_OUT
    CASE_WM_SIZE:
        lea     eax, lParam
        push    ebx
        mov     ebx, eax
        shr     eax, 16
        mov     [WindowHeight], eax
        mov     eax, ebx
        shl     eax, 16
        shr     eax, 16
        mov     [WindowWidth], eax
        pop     ebx
        jmp     CASE_OUT
    CASE_WM_PAINT:
        lea     eax, ps
        push    eax
        push    hWnd
        call    BeginPaint
        test    eax, eax
        je      textout_error
        mov     hdc, eax

        push    TRANSPARENT
        push    hdc
        call    SetBkMode

        xor     eax, eax
        mov     ax, stS.wMilliseconds
        push    eax
        mov     ax, stS.wSecond
        push    eax
        mov     ax, stS.wMinute
        push    eax
        mov     ax, stS.wHour
        push    eax
        push    OFFSET formatStr
        push    OFFSET buffer
        call    sprintf
        add     esp, 12

        push    OFFSET buffer
        call    STRLEN
        push    eax             ; strlen
        push    OFFSET buffer
        push    50
        push    50
        push    hdc
        call    TextOutA
        test    eax, eax
        je      textout_error
        jmp     ENDPAINTING

        textout_error:
        call    TEST_PROC
        
        ENDPAINTING:
        lea     eax, ps
        push    eax
        push    hWnd
        call    EndPaint        
        jmp     CASE_OUT
    CASE_WM_DESTROY:
        ; call    TEST_PROC

        push    1
        push    hWnd
        call    KillTimer

        push    0
        call    PostQuitMessage
        jmp     CASE_OUT
    CASE_DEFAULT:
        push    lParam
        push    wParam
        push    uMsg
        push    hWnd
        call    DefWindowProc
        jmp     CASE_OUT
    CASE_OUT:
    ret
WndProc endp


TEST_PROC proc
    push    MB_ICONWARNING
    push    offset msgTitle
    push    offset msgText
    push    0
    call    MessageBoxA
    ret
TEST_PROC endp

STRLEN proc string: PTR BYTE
    mov     eax, 1
    push    edi
    mov     edi, string

    count_loop:
        cmp     BYTE PTR [edi], 0
        je      done
        inc     edi
        inc     eax
        jmp     count_loop

    done:
        pop     edi
        ret
STRLEN endp

END Start