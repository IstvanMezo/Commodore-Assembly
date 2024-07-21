; Assembly code (6502 and 7501 microprocessor) by Istvan Mezo
; This program calculates coordinates from memory address
;
; input: screen address: $1030 (HI), $1031 (LO)
; screen address should be in $0C00..0FE7
; output: X in $1032 (0..39), Y in $1033 (0..24)
; no error check is coded
;
; once loaded, run with SYS(8192)
; typed with the lumydctt editor by Charlemagne

    ORG $2000   ;8192
    
    JSR $C567   ;SCNCLR

test
    LDA #$0F
    STA $1030
    LDA #$E7
    STA $1031
    JSR calccoord
    
    ;check the results
    LDA $1032
    JSR $CD74
    JSR $90A6   ;prints a space
    LDA $1033
    JSR $CD74
        
    RTS
    
calccoord
    LDX #$00
    ;subtract $0C00
    SEC
    LDA $1030
    SBC #$0C
    STA $1030

    CMP #$00    ;is the HI byte zero?
    BEQ subtract2
    
cont
    INX
    SEC
    LDA $1031
    SBC #$28
    STA $1031

    LDA $1030
    SBC #$00
    STA $1030

    CMP #$00    ;is the HI byte greater than zero?
    BNE cont    ;if not, continue subtracting $28
    JMP cont2   ;HI byte is zero now. Go to cont2 (no need to go through subtract2)
    
subtract2   ;when the HI byte is already zero
    ;check whether coord <= $28
    LDA $1031
    CMP #$28    ;subtract $28=40 from the LO byte.
    BCS cont2   ;if carry is 1, branch to cont2

return
    STX $1033
    LDA $1031
    STA $1032
    RTS
    
cont2
    INX
    SEC
    LDA $1031
    SBC #$28
    STA $1031
    CMP #$28
    BCS cont2
    
    JMP return
