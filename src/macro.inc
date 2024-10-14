IFNDEF CLOCK_MACROS
; MACROS
    CLOCK_REF_RATE      equ 100
    MAIN_CLOCK_RADIUS   equ 250
    H_HAND_LENGTH       equ 60
    M_HAND_LENGTH       equ 25
    S_HAND_LENGTH       equ 50

    MS_CLOCK_RADIUS     equ 75
    MS_HAND_LENGTH      equ 20

    ;MAIN_CLOCK_COLOUR
    MCC_1               equ 50
    MCC_2               equ 50
    MCC_3               equ 50

    ;MS_CLOCK_COLOUR
    MSCC_1              equ 100
    MSCC_2              equ 100
    MSCC_3              equ 100

    ;MS_HAND_COLOUR
    MSHC_1              equ 150
    MSHC_2              equ 150
    MSHC_3              equ 0
    
    ;S_HAND_COLOUR
    SHC_1              equ 150
    SHC_2              equ 150
    SHC_3              equ 0
    
    ;M_HAND_COLOUR
    MHC_1              equ 150
    MHC_2              equ 150
    MHC_3              equ 0
    
    ;H_HAND_COLOUR
    HHC_1              equ 150
    HHC_2              equ 150
    HHC_3              equ 0


    RGB MACRO red, green, blue
        xor     eax, eax
        mov     al, blue
        rol     eax, 8
        mov     al, green
        rol     eax, 8
        mov     al, red
    ENDM
; MACROEND
ELSE
	echo WARNING: Duplicate include file (macro.inc)
ENDIF