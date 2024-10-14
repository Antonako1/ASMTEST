.386
.model          flat, stdcall
option          casemap:none

include         \masm32\include\windows.inc
include         \masm32\include\user32.inc
include         \masm32\include\kernel32.inc

includelib      \masm32\lib\kernel32.lib
includelib      \masm32\lib\user32.lib
; https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemtime
; typedef struct _SYSTEMTIME {
;   WORD wYear;
;   WORD wMonth;
;   WORD wDayOfWeek;
;   WORD wDay;
;   WORD wHour;
;   WORD wMinute;
;   WORD wSecond;
;   WORD wMilliseconds;
; } SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;
.DATA
.CODE
update_get_stS proc
	push 	ebp
	mov 	ebp, esp
	
	mov	eax, [ebp+8]
	push 	eax
	; call 	GetSystemTime
	call 	GetLocalTime

	pop	ebp
	ret
update_get_stS endp

END


        ;push 0
        ;push OFFSET buffer
        ;push OFFSET msgTitle
        ;push hWnd
        ;call MessageBoxA

	

        ;push    eax
        ;
        ;push    eax
        ;push    OFFSET numberFormat
        ;push    OFFSET numberBuffer
        ;call    wsprintf
        ;add     esp, 12
        ;push    1
        ;push    OFFSET numberBuffer
        ;push    OFFSET msgText
        ;push    hWnd
        ;call    MessageBoxA
        ;
        ;pop     eax