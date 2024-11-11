.MODEL SMALL
.STACK 100h
.DATA
.CODE
inputPlayerTarget PROC
    ; entrada: cpuSecret, cpuBoard
    ; saida: DX (DL:x-cordenada DH: y-coordenada)

    DO_WHILE2:
        MOV AH,1h
        INT 21h
        
        AND AX,000FH
        SHL AX,1

        MOV DI,AX

        MOV AH,1h
        INT 21h

        SUB AL,'A'

        MOV DL,22
        MUL DL
        MOV BX,AX

        XOR DX,DX
        MOV DX,DI
        MOV DH,BL

    RET
inputPlayerTarget ENDP

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    CALL inputPlayerTarget

    ADD BL,DH
    AND DX,00FFh
    ADD DI,DX

    MOV AH,4ch
    INT 21h
MAIN ENDP
END MAIN