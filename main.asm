.MODEL SMALL 
.STACK 100h
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
    BOARD DW 10 DUP('~')
    BOARDSPACE DB 5 DUP('1')
    ROWS DW 400
    X DW ?
    randomNum DB ?          ; variável para o número aletório
.CODE
; gera um número aleatório entre 0 e 9
RANDOMNUMBER PROC
    MOV AH,0
    INT 1ah

    MOV AX,DX
    XOR DX,DX
    MOV BX,10
    DIV BX
    
    MOV randomNum,DL
    INT 21h
    RET
RANDOMNUMBER ENDP
DELAY PROC
    MOV CX,1
STARTDELAY:
    CMP CX,100
    JE ENDDELAY
    INC CX
    JMP STARTDELAY
ENDDELAY:
    RET
DELAY ENDP
UPDATESCREEN PROC
    
        RET
UPDATESCREEN ENDP

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    CALL RANDOMNUMBER

    MOV AH,2h
    MOV DL,randomNum
    OR DL,30h
    INT 21h

    ; CALL UPDATESCREEN

    MOV AH,4ch
    INT 21h
MAIN ENDP
END MAIN