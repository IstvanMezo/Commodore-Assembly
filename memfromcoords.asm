; Assembly code (6502 and 7501 microprocessor) by Istvan Mezo
; This program calculates memory address from coordinates
;
; input: Y coord in $1030 (0..24), X coord in $1031 (0..39)
; output: screen mem HI byte in $1032, LO byte in $1033
; no error check: coords are expected to be proper screen coordinates
;
; once loaded, run with SYS(8192)
; typed with the lumydctt editor by Charlemagne

    ORG $2000   ;8192
    
    JSR $C567   ;SCNCLR

test
    LDA #$12
    STA $1030
    LDA #$17
    STA $1031
    JSR calcmem
    
    ;check the results
    LDA $1032
    JSR $CD74
    JSR $90A6   ;prints a space
    LDA $1033
    JSR $CD74
    
    ;prints an '@' at the given position
    LDA $1033
    STA $2B
    LDA $1032
    STA $2C
    LDA #$00
    STY #$00
    STA ($2B),Y
    
    RTS
    
calcmem
    ;initialization of the output
    LDA #$0C
    STA $1032
    LDA #$00
    STA $1033
    
    LDA $1030
    CMP #$00
    BEQ addx    ;if Y=0, skip the cycle

    LDX #$00
    
cycle       ;add 40=$28 Y times  
    INX
    CLC
    LDA $1033
    ADC #$28
    STA $1033
    LDA $1032
    ADC #$00
    STA $1032
    
    CPX $1030
    BNE cycle

addx
;add X to the result
    CLC
    LDA $1033
    ADC $1031
    STA $1033
    LDA $1032
    ADC #$00
    STA $1032
    
    RTS
