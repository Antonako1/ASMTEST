.386
.model          flat, stdcall
OPTION          casemap:NONE

include         \masm32\include\windows.inc
include         \masm32\include\user32.inc
include         \masm32\include\kernel32.inc
include         \masm32\include\gdi32.inc
include         \masm32\include\msvcrt.inc
include         .\macro.inc

includelib      \masm32\lib\kernel32.lib
includelib      \masm32\lib\user32.lib
includelib      \masm32\lib\gdi32.lib

; create_circle   proto   :DWORD, :DWORD
update_get_stS  proto
WinMain         proto   :DWORD, :DWORD, :DWORD, :DWORD
extern C        sprintf :proc
LINE_DRAW_PROCEDURE     proto :HDC, :WORD, :REAL4, :REAL4, :REAL4




.DATA
    winClassName    db  "ASMTEST", 0
    winAppName      db  "ASMTEST, GUI", 0
    winClass        WNDCLASSEX { SIZEOF WNDCLASSEX, CS_HREDRAW or CS_VREDRAW, WndProc, 0, 0, 0, IDI_APPLICATION, 0, COLOR_3DSHADOW + 1, 0, winClassName, IDI_APPLICATION };
    WindowHeight    dd  640
    WindowWidth     dd  780
    stS SYSTEMTIME  <>
    buffer          DB  16 DUP(?)               ; FOR SPRINTF
    formatStr       DB  "%02d:%02d:%02d.%02d", 0
    
    msgTitle        DB  "Oh no!", 0
    msgText1        DB  "EXIT!", 0
    msgText2        DB  "DRAW ERROR!", 0
    msgText3        DB  "TEXT ERROR!", 0

    PI              REAL4 3.1415927410125732
    TWO_PI          REAL4 6.2831854820251464
    CALC            REAL4 0.0000000000000000   
    CALC_TEMP       REAL4 0.0000000000000000  

THREEHUNDREDSIXTY   REAL4 360.0
ONEHUNDREDEIGHTY    REAL4 180.0
MS_MAX_VALUE        REAL4 1000.0
H_MAX_VALUE         REAL4 12.0
M_MAX_VALUE         REAL4 60.0
S_MAX_VALUE         REAL4 60.0
MS_CLOCK_RADIUS_f   REAL4 75.0
MAIN_CLOCK_RADIUS_f REAL4 250.0

H_HAND_LENGTH       REAL4 0.9
M_HAND_LENGTH       REAL4 0.8
S_HAND_LENGTH       REAL4 0.95
MS_HAND_LENGTH      REAL4 0.8

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
    mov     eax, WS_OVERLAPPEDWINDOW
    or      eax, WS_VISIBLE
    mov     ecx, WS_THICKFRAME or WS_MAXIMIZEBOX
    not     ecx
    and     eax, ecx
    push    eax
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
    LOCAL   rect:RECT
    LOCAL   hbrush:HBRUSH
    LOCAL   hpen:HPEN
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
        ;? add     esp, 12

        push    OFFSET buffer
        call    STRLEN
        push    eax             ; strlen
        push    OFFSET buffer
        push    10
        push    10
        push    hdc
        call    TextOutA
        test    eax, eax
        je      textout_error
        jmp     ENDTEXT

        textout_error:
        call    FAIL_MESSAGE_3
        
        ENDTEXT:


        ; CLOCK INTERFACE

        lea     eax, rect
        push    eax
        push    hWnd
        call    GetClientRect

        RGB     MCC_1, MCC_2, MCC_3
        push    eax
        call    CreateSolidBrush
        test    eax, eax
        je      DRAW_error
        mov     hbrush, eax

        push    hbrush
        push    hdc
        call    SelectObject

        ;   CIRCLES:
        ;       eax: centerX
        ;       ecx: centerY
        ;       edx: temp
        ;
        ; MAIN CIRCLE
        xor     eax, eax
        mov     ecx, eax
        mov     edx, eax
        
        mov     eax, rect.left
        add     eax, rect.right
        shr     eax, 1

        mov     ecx, rect.top
        add     ecx, rect.bottom
        shr     ecx, 1

        push    eax
        push    ecx

        mov     edx, ecx
        add     edx, MAIN_CLOCK_RADIUS
        push    edx

        mov     edx, eax
        add     edx, MAIN_CLOCK_RADIUS
        push    edx
        
        mov     edx, ecx
        sub     edx, MAIN_CLOCK_RADIUS
        push    edx

        mov     edx, eax
        sub     edx, MAIN_CLOCK_RADIUS
        push    edx
        
        push    hdc
        call    Ellipse
        test    eax, eax
        je      DRAW_error

        lea     eax, hbrush
        push    eax
        call    DeleteObject
        

        ; MS CIRCLE
        RGB     MSCC_1, MSCC_2, MSCC_3
        push    eax
        call    CreateSolidBrush
        test    eax, eax
        je      DRAW_error
        mov     hbrush, eax
        push    hbrush
        push    hdc
        call    SelectObject

        xor     eax, eax
        mov     ecx, eax
        mov     edx, eax
        
        mov     eax, rect.left
        add     eax, rect.right
        shr     eax, 1

        mov     ecx, rect.top
        add     ecx, rect.bottom
        shr     ecx, 1
        add     ecx, 150

        push    eax
        push    ecx

        mov     edx, ecx
        add     edx, MS_CLOCK_RADIUS
        push    edx

        mov     edx, eax
        add     edx, MS_CLOCK_RADIUS
        push    edx
        
        mov     edx, ecx
        sub     edx, MS_CLOCK_RADIUS
        push    edx

        mov     edx, eax
        sub     edx, MS_CLOCK_RADIUS
        push    edx

        push    hdc
        call    Ellipse
        test    eax, eax
        je      DRAW_error

        lea     eax, hbrush
        push    eax
        call    DeleteObject
        
        ; Lines:
        ;   eax: from
        ;   ecx: to
        ;   edx: temp
        ;
        ; MS HAND
        RGB     MSHC_1, MSHC_2, MSHC_3
        push    eax
        push    2
        push    PS_SOLID
        call    CreatePen
        test    eax, eax
        je      DRAW_error
        mov     hpen, eax
        push    hpen
        push    hdc
        call    SelectObject
        

        
        pop     ecx ; CENTERY FOR MS_CIRCLE
        pop     eax ; CENTERX FOR MS_CIRCLE
        push    eax
        push    ecx
        push    NULL
        push    ecx
        push    eax
        push    hdc
        call    MoveToEx
        test    eax, eax
        je      DRAW_error
        
        pop     ecx;centery. FOR MS_CIRCLE. NO PRESERVE
        pop     eax;centerx. FOR MS_CIRCLE. NO PRESERVE

        invoke  LINE_DRAW_PROCEDURE, hdc, [stS.wMilliseconds], [MS_MAX_VALUE], [MS_CLOCK_RADIUS_f], [MS_HAND_LENGTH] 
        cmp     edx, 1
        je      DRAW_error

        lea     eax, hpen
        push    eax
        call    DeleteObject

        ; HOUR HAND
        RGB     HHC_1, HHC_2, HHC_3
        push    eax
        push    2
        push    PS_SOLID
        call    CreatePen
        test    eax, eax
        je      DRAW_error
        mov     hpen, eax
        push    hpen
        push    hdc
        call    SelectObject
        
        pop     ecx ; CENTERY for MAIN_CIRCLE
        pop     eax ; CENTERX for MAIN_CIRCLE
        push    eax ; CENTERY for MAIN_CIRCLE
        push    ecx ; CENTERX for MAIN_CIRCLE
        
        push    NULL
        push    ecx
        push    eax
        push    hdc
        call    MoveToEx
        test    eax, eax
        je      DRAW_error
        
        pop     ecx ; CENTERY for MAIN_CIRCLE
        pop     eax ; CENTERX for MAIN_CIRCLE
        push    eax ; CENTERY for MAIN_CIRCLE
        push    ecx ; CENTERX for MAIN_CIRCLE
        
        invoke  LINE_DRAW_PROCEDURE, hdc, [stS.wHour], [H_MAX_VALUE], [MAIN_CLOCK_RADIUS_f], [H_HAND_LENGTH] 
        cmp     edx, 1
        je      DRAW_error

        lea     eax, hpen
        push    eax
        call    DeleteObject

        ; MINUTE HAND
        RGB MHC_1, MHC_2, MHC_3
        push    eax
        push    2
        push    PS_SOLID
        call    CreatePen
        test    eax, eax
        je      DRAW_error
        mov     hpen, eax
        push    hpen
        push    hdc
        call    SelectObject

        pop     ecx ; CENTERY for MAIN_CIRCLE
        pop     eax ; CENTERX for MAIN_CIRCLE
        push    eax ; CENTERY for MAIN_CIRCLE
        push    ecx ; CENTERX for MAIN_CIRCLE
        
        push    NULL
        push    ecx
        push    eax
        push    hdc
        call    MoveToEx
        test    eax, eax
        je      DRAW_error
        
        pop     ecx ; CENTERY for MAIN_CIRCLE
        pop     eax ; CENTERX for MAIN_CIRCLE
        push    eax ; CENTERY for MAIN_CIRCLE
        push    ecx ; CENTERX for MAIN_CIRCLE
        
        invoke  LINE_DRAW_PROCEDURE, hdc, [stS.wMinute], [M_MAX_VALUE], [MAIN_CLOCK_RADIUS_f], [M_HAND_LENGTH] 
        cmp     edx, 1
        je      DRAW_error

        lea     eax, hpen
        push    eax
        call    DeleteObject

        ; SECOND HAND
        RGB SHC_1, SHC_2, SHC_3
        push    eax
        push    2
        push    PS_SOLID
        call    CreatePen
        test    eax, eax
        je      DRAW_error
        mov     hpen, eax
        push    hpen
        push    hdc
        call    SelectObject

        pop     ecx ; CENTERY for MAIN_CIRCLE
        pop     eax ; CENTERX for MAIN_CIRCLE
        push    eax ; CENTERY for MAIN_CIRCLE
        push    ecx ; CENTERX for MAIN_CIRCLE
        
        push    NULL
        push    ecx
        push    eax
        push    hdc
        call    MoveToEx
        test    eax, eax
        je      DRAW_error

        pop     ecx ; CENTERY for MAIN_CIRCLE
        pop     eax ; CENTERX for MAIN_CIRCLE
        
        invoke  LINE_DRAW_PROCEDURE, hdc, [stS.wSecond], [S_MAX_VALUE], [MAIN_CLOCK_RADIUS_f], [S_HAND_LENGTH] 
        cmp     edx, 1
        je      DRAW_error

        lea     eax, hpen
        push    eax
        call    DeleteObject

        
        
        jmp     ENDPAINT
        DRAW_error:
        call    FAIL_MESSAGE_2
        ENDPAINT:
        lea     eax, ps
        push    eax
        push    hWnd
        call    EndPaint
        
        lea     eax, hbrush
        push    eax
        call    DeleteObject  

        lea     eax, hpen
        push    eax
        call    DeleteObject    

        jmp     CASE_OUT
    CASE_WM_DESTROY:
        push    1
        push    hWnd
        call    KillTimer

        call    FAIL_MESSAGE_1

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
    

    ; LINE_DRAW_PROCEDURE:
    ;     pop     edx
    ;     pop     edx
    ;     pop     edx
    ;     xor     edx, edx
    ;     pop     dx

    ;     fld     [PI]
    ;     fdiv    [ONEHUNDREDEIGHTY]
    ;     fstp    [CALC]



    ;     ; !PARAM1
    ;     fild    WORD PTR [ebp+2]            ; MS
    ;     fmul    [THREEHUNDREDSIXTY]         ; 360deg
    ;     ; !PARAM2
    ;     fdiv    DWORD PTR [ebp+4]           ; MAX VAL
    ;     fmul    [CALC]                      ; PI CALC
    ;     fstp    [CALC]                      ; THETA

    ;     ;CENTERY
    ;     mov     [float_to_dword], ecx       ; LOAD CENTERY
    ;     fild    DWORD PTR [float_to_dword]  ; LOADED
    ;     fld     [CALC]                      ; THETA
    ;     fcos                                ; COS
    ;     ; !PARAM3
    ;     fld     DWORD PTR [ebp+8]           ; RADIUS
    ;     ; !PARAM4
    ;     fld     DWORD PTR [ebp+12]          ; LENGTH
    ;     fmul                                ; MULTIPLY
    ;     fmul
    ;     fsub                                ; SUBTRACT
    ;     fstp    [CALC_TEMP]                 ; RES

    ;     ; CAST FLOAT TO INT
    ;     fld     [CALC_TEMP]
    ;     fistp   DWORD PTR [float_to_dword]
    ;     push    float_to_dword
        
    ;     ; CENTERX CAST INT TO FLOAT
    ;     mov     [float_to_dword], eax          
    ;     fild    DWORD PTR [float_to_dword]
    ;     fstp    [CALC_TEMP]

    ;     ; radius +
    ;     fld     [CALC]              ; THETA
    ;     fsin                        ; SIN
    ;     ; !PARAM3
    ;     fld     DWORD PTR [ebp-8]   ; RADIUS
    ;     ; !PARAM4
    ;     fld     DWORD PTR [ebp-12]  ; LENGTH
    ;     fmul
    ;     fmul                        ; MULTIPLY
    ;     fadd    [CALC_TEMP]         ; ADD CENTERX
    ;     fstp    [CALC_TEMP]         ; LOAD EP_X

    ;     ; CAST FLOAT TO INT
    ;     fld     [CALC_TEMP]
    ;     fistp   DWORD PTR [float_to_dword]

    ;     push    float_to_dword             ; X
    ;     push    hdc
    ;     call    LineTo
    ;     test    eax, eax
    ;     je      LINETOERROR
    ;     jmp     RETIRM
    ;     LINETOERROR:
    ;     ; mov     esp, ebp
    ;     ; pop     ebp
    ;     jmp     DRAW_error
    ;     RETIRM:
    ;     ret


WndProc endp


LINE_DRAW_PROCEDURE proc hdc:HDC, value:WORD, max_value:REAL4, radius:REAL4, h_length:REAL4
    LOCAL   float_to_dword:DWORD
    
; CALCULATE MS POS
; EAX: CENTERX
; ECX: CENTERY
; EDX: TEMP
; CALC: THETA
; CALC_TEMP: TEMP
;
; handle_length = handle_length(.f)*radius
; THETA = (VALUE * 360deg / MAX_VALUE) * (PI / 180)
; EP_X = centerX + handle_length * sin(theta)
; EP_Y = centerY - handle_length * cos(theta)
        

    ; THETASTART
    fld     [PI]
    fdiv    [ONEHUNDREDEIGHTY]
    fstp    [CALC]                      ; PI/180
    fild    [value]                     ; MS VALUE
    fmul    [THREEHUNDREDSIXTY]         ; 360deg
    fdiv    [max_value]                 ; MAX VAL
    fmul    [CALC]                      ; PI CALC
    fstp    [CALC]                      ; THETA
    ; KEEP RANGE 0-2pi
    ; fld     [TWO_PI]
    ; fld     [CALC]
    ; fprem
    ; fstp    [CALC]
    ;THETAEND

    ;CENTERY
    mov     [float_to_dword], ecx       ; LOAD CENTERY
    fild    DWORD PTR [float_to_dword]  ; LOADED
    
    fld     [CALC]                      ; THETA
    fcos                                ; COS

    fld     [radius]                    ; RADIUS
    fld     [h_length]                  ; LENGTH
    fmul                                ; MULTIPLY
    fmul                                ; THETA MULTIPLY

    fsub                                ; SUBTRACT ECX
    fstp    [CALC_TEMP]                 ; RES

    ; CAST FLOAT TO INT
    fld     [CALC_TEMP]
    fistp   DWORD PTR [float_to_dword]
    push    [float_to_dword]

    ; CENTERX CAST INT TO FLOAT
    mov     [float_to_dword], eax          
    fild    DWORD PTR [float_to_dword]
    fstp    [CALC_TEMP]

    fld     [CALC]                  ; THETA
    fsin                            ; SIN
    
    fld     [radius]                ; RADIUS
    fld     [h_length]              ; LENGTH
    fmul
    
    fmul                            ; MULTIPLY
    fadd    [CALC_TEMP]             ; ADD CENTERX
    fstp    [CALC_TEMP]             ; LOAD EP_X

    ; CAST FLOAT TO INT
    fld     [CALC_TEMP]
    fistp   DWORD PTR [float_to_dword]
    push    [float_to_dword]        ; X

    push    hdc
    call    LineTo
    test    eax, eax
    je      LINETOERROR
    xor     edx, edx
    mov     edx, 0
    jmp     RETIRM
    LINETOERROR:
    xor     edx, edx
    mov     edx, 1
    RETIRM:
    ret
LINE_DRAW_PROCEDURE endp

FAIL_MESSAGE_1 proc
    push    MB_ICONWARNING
    push    offset msgTitle
    push    offset msgText1
    push    0
    call    MessageBoxA
    ret
FAIL_MESSAGE_1 endp
FAIL_MESSAGE_2 proc
    push    MB_ICONWARNING
    push    offset msgTitle
    push    offset msgText2
    push    0
    call    MessageBoxA
    ret
FAIL_MESSAGE_2 endp
FAIL_MESSAGE_3 proc
    push    MB_ICONWARNING
    push    offset msgTitle
    push    offset msgText3
    push    0
    call    MessageBoxA
    ret
FAIL_MESSAGE_3 endp

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