IFNDEF CLOCK_MACROS
; MACROS
    CLOCK_REF_RATE      equ 100
    MAIN_CLOCK_RADIUS   equ 250     ;TODO: .DATA AND CALCULATE ON RESIZE!
    MS_CLOCK_RADIUS     equ 55      ;TODO: .DATA AND CALCULATE ON RESIZE!
    
    ;SAME AS RADIUS
    MVISOR_LENGTH       equ 170     ;TODO: .DATA AND CALCULATE ON RESIZE!
    HVISOR_LENGTH       equ 135     ;TODO: .DATA AND CALCULATE ON RESIZE!
    VISOR_FROM_BOTTOM   equ 100     ;TODO: .DATA AND CALCULATE ON RESIZE!

    M_MAX_VALUE_INT     equ 60
    H_MAX_VALUE_INT     equ 12
    ;MAIN_CLOCK_COLOUR
    MCC_1               equ 30
    MCC_2               equ 30
    MCC_3               equ 60

    ;MS_CLOCK_COLOUR
    MSCC_1              equ 120
    MSCC_2              equ 120
    MSCC_3              equ 120

    ;MS_HAND_COLOUR
    MSHC_1              equ 255
    MSHC_2              equ 0
    MSHC_3              equ 0
    
    ;S_HAND_COLOUR
    SHC_1              equ 255
    SHC_2              equ 165
    SHC_3              equ 0
    
    ;M_HAND_COLOUR
    MHC_1              equ 0
    MHC_2              equ 200
    MHC_3              equ 200
    
    ;H_HAND_COLOUR
    HHC_1              equ 0
    HHC_2              equ 100
    HHC_3              equ 150


    ONE_START_X         equ 0
    ONE_START_Y         equ 0
    ONE_END_X           equ 0
    ONE_END_Y           equ 0

    TWO_START_X         equ 0
    TWO_START_Y         equ 0
    TWO_END_X           equ 0
    TWO_END_Y           equ 0
    FOUR_START_X        equ 0
    FOUR_START_Y        equ 0
    FOUR_END_X          equ 0
    FOUR_END_Y          equ 0
    FIVE_START_X        equ 0
    FIVE_START_Y        equ 0
    FIVE_END_X          equ 0
    FIVE_END_Y          equ 0
    SEVEN_START_X       equ 0
    SEVEN_START_Y       equ 0
    SEVEN_END_X         equ 0
    SEVEN_END_Y         equ 0
    EIGHT_START_X       equ 0
    EIGHT_START_Y       equ 0
    EIGHT_END_X         equ 0
    EIGHT_END_Y         equ 0
    TEN_START_X         equ 0
    TEN_START_Y         equ 0
    TEN_END_X           equ 0
    TEN_END_Y           equ 0
    ELEVEN_START_X      equ 0
    ELEVEN_START_Y      equ 0
    ELEVEN_END_X        equ 0
    ELEVEN_END_Y        equ 0



    MIDDLE_CIRCLE_SIZE  equ 10
    MS_MIDDLE_CIRCLE_SIZE   equ 5

    RGB MACRO red, green, blue
        xor     eax, eax
        mov     al, blue
        rol     eax, 8
        mov     al, green
        rol     eax, 8
        mov     al, red
    ENDM

    ACREGPP MACRO
        pop     ecx
        pop     eax
        push    eax
        push    ecx
    ENDM

    FSTPCLEAR MACRO
        fstp    st(0)
        fstp    st(1)
        fstp    st(2)
        fstp    st(3)
        fstp    st(4)
        fstp    st(5)
        fstp    st(6)
        fstp    st(7)
    ENDM

    ; RESULT IN EAX, % in edx
    QDIVISION MACRO DIVIDENT, DIVIDER
        push    ebx

        xor     eax, eax
        mov     ebx, eax
        mov     edx, eax

        mov     eax, DIVIDENT
        mov     ebx, DIVIDER
        div     ebx

        pop     ebx
    ENDM

    ;RESULT IN EAX
    QMULTIPLICATION MACRO __X__, __Y__
        push    ebp
        xor     eax, eax
        mov     ebx, ebx

        mov     eax, __X__
        mov     ebx, __Y__
        mul     ebx
        pop     ebp
    ENDM
; MACROEND
ELSE
	echo WARNING: Duplicate include file (macro.inc)
ENDIF

        ; push    ebx

        ; xor     eax, eax
        ; mov     ebx, eax
        ; mov     edx, eax

        ; mov     eax, MAIN_CLOCK_RADIUS
        ; mov     ebx, 3
        ; div     ebx
        ; mov     edx, eax
        
        ; pop     ebx