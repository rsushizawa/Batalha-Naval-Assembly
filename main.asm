.MODEL SMALL 
.STACK 100h
; macro de pulara 1 linha
pulaLinha MACRO
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
    playerBoard DW 5 DUP( 10 DUP('~')),5 DUP( 10 DUP('A'))          ; tabuleiro do jogador
    cpuBoard DW 5 DUP( 10 DUP('~')),5 DUP( 10 DUP('A'))             ; tabuleiro da CPU que é exibido na tela
    cpuSecret DW 10 DUP( 10 DUP('~'))                               ; tabuleiro da CPU
    boardSpace DB 32,32,32,32,32,32,32,'$'                          ; string de spaços para o UPDATESCREEN
    randomNum DB ?                                                  ; variável para o número aletório
    playerMap DW ?                                                  ; endereço de memória do mapa selecionado para o player
    cpuMap DW ?                                                     ; endereço de memória do mapa selecionado para a CPU

    map1 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','A','A','A','A','~','~','~','~','A'
         DW '~','~','~','~','~','~','~','~','~','A'
         DW '~','~','~','~','~','~','A','~','~','A'
         DW '~','~','~','~','~','~','A','~','~','~'
         DW '~','~','A','A','~','~','~','~','A','~'
         DW '~','~','~','~','~','A','~','A','A','A'
         DW '~','~','~','~','A','A','~','~','~','~'
         DW '~','~','~','~','~','A','~','~','~','~'
    
    map2 DW 0,0,0,0,0,0,0,0,0,0
         DW 0,1,0,1,0,0,0,1,0,0
         DW 0,1,0,1,0,0,1,1,0,0
         DW 0,1,0,0,0,0,0,1,0,0
         DW 0,1,0,0,0,0,0,0,0,0
         DW 0,0,0,0,0,0,0,0,0,0
         DW 0,0,0,1,0,0,0,0,1,1
         DW 0,0,1,1,1,0,0,0,0,0
         DW 0,0,0,0,0,0,1,1,1,0

.CODE
; reloads the screen with the current matrizes of the PLAYERBOARD and CPUBOARD
reloadScreen PROC
    ; entrada: PLAYERBOARD, CPUBOARD, BOARDSPACE
    ; saida: void

    XOR BX,BX       ; contador para as linhas
    XOR CX,CX       ; contador auxiliar para as linhas
    XOR DI,DI       ; contador auxiliar pular linhas

; START_REPEAT
    REPEAT:
    ; START_SWICH_CASE
        ; verifica se está no começo da linha
        TEST DI,1       
        JZ PLAYER
        ; se não estiver então imprime a CPUBOARD
        LEA DX,cpuBoard
        JMP CONTINUE

        PLAYER:
        ; se estiver no começo da linha então imrprime a PLEYERBOARD
        LEA DX,playerBoard
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
        MOV AH,09h
        LEA DX,boardSpace
        INT 21h
    ; START_IF
            INC DI
        ; IF DI IS ODD
            TEST DI,1
        ; THEN
            JNZ REPEAT
        ; ELSE
            pulaLinha
            ADD CX,SI
    ; END_IF

; END_REPEAT_CONDITION
    CMP CX,0C8h
    JNZ REPEAT

    RET
reloadScreen ENDP

; gera um número aleatório entre 0 e 9
randomNumber PROC
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
randomNumber ENDP

generateMaps PROC
    ; seleciona dois mapas aleatórios diferentes
    ; entrada: randomNum, cpuMap, playerMap
    ; saida: playerBoard,cpuBoard

    LEA DX,[map1]
    MOV cpuMap,DX

    CALL copyCPUMap

    RET
generateMaps ENDP

copyCPUMap PROC
    ; copia um mapa selecionado para o tabuleiro da CPU
    ; endtrada: cpuMap
    ; saida: cpuBoard

    XOR BX,BX
    XOR DI,DI
    XOR DX,DX
    MOV CX,20

    COPIAR:
        MOV DX,cpuMap[BX][DI]
        MOV cpuBoard[BX][DI],DX
        ADD DI,2
        CMP DI,20
        JNZ COPIAR

        ADD BX,DI
        XOR DI,DI
        LOOP COPIAR

    RET
copyCPUMap ENDP
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

; test code
    CALL randomNumber

    MOV AH,2h
    MOV DL,randomNum
    OR DL,30h
    INT 21h

    pulaLinha

    CALL copyCPUMap

    CALL reloadScreen
; end test code
; code_overview

    ; generateMaps

    ; REPEAT
    ;     updateScreen
        
    ;     REPEAT
    ;         selecionaAlvo

    ;         verificaAcerto

    ;         updateMatrix

    ;         updateScreen
    ;     UNTIL TIRO = ERRO

    ;     REPEAT
    ;         selecionaAlvoAleatorio

    ;         verificaAcerto

    ;         updateMatrix

    ;         updateScreen
    ;     UNTIL TIRO = ERRO
    ; UNTIL ALL BOATS OF ONE OF THE PLAYER HAVE SINKEN

    ; endScreen
;  end code_overview

    MOV AH,4ch
    INT 21h
MAIN ENDP
END MAIN