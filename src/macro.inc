IFNDEF CLOCK_MACROS
; MACROS
    CLOCK_REF_RATE      equ 50
    MAIN_CLOCK_RADIUS   equ 250
    ; H_HAND_LENGTH       equ 60
    ; M_HAND_LENGTH       equ 25
    ; S_HAND_LENGTH       equ 50

    MS_CLOCK_RADIUS     equ 75
    ; MS_HAND_LENGTH      equ 90

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



    ; STATIC LINE POS'
    ; TWELVE_START_X      equ 390
    TWELVE_START_Y      equ 75
    ; TWELVE_END_X        equ 390
    TWELVE_END_Y        equ 200

    THREE_START_X       equ 150
    ; THREE_START_Y       equ 100
    THREE_END_X         equ 275
    ; THREE_END_Y         equ 200

    ; SIX_START_X         equ 390
    SIX_START_Y         equ 400
    ; SIX_END_X           equ 390
    SIX_END_Y           equ 550

    NINE_START_X        equ 475
    ; NINE_START_Y        equ 100
    NINE_END_X          equ 600
    ; NINE_END_Y          equ 200

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
; MACROEND
ELSE
	echo WARNING: Duplicate include file (macro.inc)
ENDIF