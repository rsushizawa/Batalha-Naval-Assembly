.MODEL SMALL 
.STACK 100h
; macro de pulara 1 linha
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
    PLAYERBOARD DW 10 DUP( 10 DUP('~'))         ; tabuleiro do jogador
    CPUBOARD DW 10 DUP( 10 DUP('1'))            ; tabuleiro da CPU que é exibido na tela
    CPUSECRET DW 10 DUP( 10 DUP('~'))           ; tabuleiro da CPU
    BOARDSPACE DB 32,32,32,32,32,32,32,'$'      ; string de spaços para o UPDATESCREEN
    randomNum DB ?                              ; variável para o número aletório

.CODE
; updates the screen with the current matrizes of the PLAYERBOARD and CPUBOARD
UPDATESCREEN PROC
    ; entrada: PLAYERBOARD, CPUBOARD, BOARDSPACE
    ; saida: void

    XOR BX,BX       ; contador para as linhas
    XOR CX,CX       ; contador auxiliar para as linhas
    XOR DI,DI       ; contador auxiliar pular linhas

REPEAT:
; START_SWICH_CASE
    ; verifica se está no começo da linha
    TEST DI,1       
    JZ PLAYER
    ; se não estiver então imprime a CPUBOARD
    LEA DX,CPUBOARD
    JMP CONTINUE

PLAYER:
    ; se estiver no começo da linha então imrprime a PLEYERBOARD
    LEA DX,PLAYERBOARD
; END_SWICH_CASE

; imprimir a linha do tabuleiro selecionado em DX
; START_REPEAT
CONTINUE:
    XOR SI,SI
    MOV AH,2h
    ADD DX,CX
    MOV BX,DX
IMPRIME:
    MOV DL,[BX][SI]
    INT 21h

    INC SI
    CMP SI,20
    JNZ IMPRIME
; END_REPEAT
; imprime 7 caracteres de espaço
SPACE:
    MOV AH,09h
    LEA DX,BOARDSPACE
    INT 21h

; START_IF
    INC DI
; IF DI IS ODD
    TEST DI,1
; THEN
    JNZ REPEAT
; ELSE
PULALINHA:
    PULAR_LINHA
    ADD CX,SI
; END_REPEAT_CONDITION
    CMP CX,0C8h
    JNZ REPEAT

    RET
UPDATESCREEN ENDP

; gera um número aleatório entre 0 e 9
RANDOMNUMBER PROC
    ; entrada: void
    ; saida: randomNum
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

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    CALL RANDOMNUMBER

    MOV AH,2h
    MOV DL,randomNum
    OR DL,30h
    INT 21h

    PULAR_LINHA

    CALL UPDATESCREEN

    MOV AH,4ch
    INT 21h
MAIN ENDP
END MAIN