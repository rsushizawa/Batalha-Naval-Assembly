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
    seed DW 24653               ; Initial seed value (can be changed for different sequences)
    multiplier DW 13849          ; Multiplier constant for LCG
    increment DW 1               ; Increment constant for LCG
    randomNum DW 0            ; Storage for random number between 0 and 9
.CODE
; gera um número aleatório entre 0 e 9
RANDOMNUMBER PROC
    ; Load the seed into AX
    MOV AX, seed
    ; Load the multiplier into BX
    MOV BX, multiplier
    ; Multiply AX by BX (result in DX:AX)
    MUL BX
    ; Add the increment
    ADD AX, increment
    ; Update the seed with the new value
    MOV seed, AX

    ; Limit the result to 0-9 by performing modulo 10
    MOV DX, 0                ; Clear DX for DIV operation
    MOV BX, 10               ; Set divisor to 10
    DIV BX                    ; AX / 10, remainder in DX
    MOV randomNum, DX      ; Store the result (0-9) in randomNumber
RANDOMNUMBER ENDP

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
