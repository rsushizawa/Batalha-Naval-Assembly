.MODEL SMALL 
PULAR_LINHA MACRO
    PUSH AX
    PUSH DX
    MOV AH,2h
    MOV DL,10
    INT 21h
    MOV DL,13
    INT 21h
    POP DX
    POP AX
ENDM
.DATA
    BOARD DW 20 DUP(10 DUP('~'))
    BOARDSPACE DW 5 DUP(32) 
.CODE
UPDATESCREEN PROC
    XOR BX,BX       ; contador das linhas

    ; imprime o tabuleiro
    PULALINHA:
        ROR BX,1
        JC CONTINUAR
            PULAR_LINHA
        CONTINUAR:
            ROL BX,1
            MOV AH,2h      ; imprimir caractere
            XOR DI,DI       ; contador das colunas

        ; imprime uma linha dos tabuleiros
        LPLAYER:
            MOV CX,BOARD[BX][DI]
            MOV DL,CL
            INT 21h
            INC DI
            CMP DI,20
            JNZ LPLAYER

            ; espaço entre os tabuleiros
            MOV AH,9h
            LEA DX,BOARDSPACE   
            INT 21h
        
        ADD BX,DI
        CMP BX,
        JNZ PULALINHA

        RET
UPDATESCREEN ENDP

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    CALL UPDATESCREEN
MAIN ENDP
END MAIN