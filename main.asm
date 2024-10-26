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

    playerBoard DW 10 DUP( 9 DUP('~'),'1')                          ; tabuleiro do jogador
    cpuBoard DW 10 DUP( 9 DUP('~'),'1')                             ; tabuleiro da CPU que é exibido na tela
    cpuSecret DW 10 DUP( 10 DUP('~'))                               ; tabuleiro da CPU
    boardSpace DB 32,32,32,32,32,32,32,'$'                          ; string de spaços para o reloadScreen
    seed DW 24653                                                   ; Initial seed value (can be changed for different sequences)
    multiplier DW 13849                                             ; Multiplier constant for LCG
    randomNum DB 0                                                  ; Storage for random number between 0 and 9
    playerMap DW ?                                                  ; endereço de memória do mapa selecionado para o player
    cpuMap DW ?                                                     ; endereço de memória do mapa selecionado para a CPU
    maps DW 10 DUP(?)                                               ; vetor de endereços dos mapas
    
    map0 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'

    map1 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','A','A','A','A','~','~','~','~','A'
         DW '~','~','~','~','~','~','~','~','~','A'
         DW '~','~','~','~','~','~','A','~','~','A'
         DW '~','~','~','~','~','~','A','~','~','~'
         DW '~','~','A','A','~','~','~','~','A','~'
         DW '~','~','~','~','~','A','~','A','A','A'
         DW '~','~','~','~','A','A','~','~','~','~'
         DW '~','~','~','~','~','A','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
    
    map2 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','A','~','A','~','~','~','A','~','~'
         DW '~','A','~','A','~','~','A','A','~','~'
         DW '~','A','~','~','~','~','~','A','~','~'
         DW '~','A','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','A','A'
         DW '~','~','~','A','~','~','~','~','~','~'
         DW '~','~','A','A','A','~','~','~','~','~'
         DW '~','~','~','~','~','~','A','A','A','~'
    
    map3 DW 'A','~','~','~','~','~','~','~','~','~'
         DW 'A','A','~','~','~','~','~','~','~','~'
         DW 'A','~','~','A','A','A','~','~','A','~'
         DW '~','~','~','~','~','~','~','~','A','~'
         DW '~','A','~','~','A','~','~','~','~','~'
         DW '~','A','~','A','A','~','~','~','~','~'
         DW '~','~','~','~','A','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','A','A','A','A','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
    
    map4 DW '~','~','~','A','~','~','~','~','~','~'
         DW '~','~','A','A','A','~','A','~','~','~'
         DW '~','~','~','~','~','~','A','~','~','~'
         DW 'A','A','~','A','~','~','A','~','~','~'
         DW '~','~','~','A','~','~','~','~','~','~'
         DW '~','~','~','A','~','~','A','A','~','~'
         DW '~','~','~','A','~','~','~','~','~','~'
         DW '~','~','~','A','~','~','~','~','~','~'
         DW '~','~','~','~','~','A','~','~','~','~'
         DW '~','~','~','~','A','A','A','~','~','~'
    
    map5 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','A','~','~','~','A','A','A','A','~'
         DW '~','A','A','~','~','~','~','~','~','~'
         DW '~','A','~','~','~','~','~','A','~','~'
         DW '~','~','~','~','~','~','~','A','~','~'
         DW '~','~','~','A','A','A','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','A','~'
         DW '~','~','~','~','A','~','~','A','A','~'
         DW '~','~','~','~','A','~','~','~','A','~'
         DW '~','~','~','~','~','~','~','~','~','~'
    
    map6 DW '~','~','~','~','~','~','~','~','~','~'
         DW 'A','~','~','~','A','A','A','~','~','~'
         DW 'A','~','~','~','~','A','~','~','~','~'
         DW 'A','~','~','~','~','~','~','~','~','~'
         DW 'A','~','~','A','~','~','A','A','~','~'
         DW '~','~','~','A','~','~','~','~','~','~'
         DW '~','~','~','A','~','~','~','~','A','~'
         DW 'A','A','~','~','~','~','~','A','A','~'
         DW '~','~','~','~','~','~','~','~','A','~'
         DW '~','~','~','~','~','~','~','~','~','~'
    
    map7 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','A','~'
         DW '~','~','A','A','A','A','~','A','A','~'
         DW '~','~','~','~','~','~','~','~','A','~'
         DW '~','A','A','~','~','~','~','~','~','~'
         DW '~','~','~','~','A','A','A','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','A','A','~','~','~','A','~','~','~'
         DW '~','~','~','~','~','~','A','A','~','~'
         DW '~','~','~','~','~','~','A','~','~','~'
    
    map8 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','A','A','A','~','~','A','A','A','~'
         DW '~','~','A','~','~','~','~','~','~','~'
         DW '~','~','~','~','A','~','~','~','~','~'
         DW '~','~','~','A','A','A','~','~','~','~'
         DW '~','~','~','~','~','~','~','A','A','~'
         DW '~','A','A','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','A','A','A','A','~','~','~'
    
    map9 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','A','A','A','A','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW 'A','~','~','~','~','~','A','A','A','~'
         DW 'A','A','~','~','~','~','~','A','~','~'
         DW 'A','~','~','~','~','A','~','~','~','~'
         DW '~','~','A','A','~','A','~','~','~','~'
         DW '~','~','~','~','~','A','~','A','A','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
    
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
    CALL auxRandomNumber
    ; Load the seed into AX
    MOV AX,seed
    ; Load the multiplier into BX
    MOV BX,multiplier
    ; Multiply AX by BX (result in DX:AX)
    MUL BX
    ; Add the increment
    ADD AL,12
    ; Update the seed with the new value
    MOV seed,AX

    ; Limit the result to 0-9 by performing modulo 10
    XOR DX,DX               ; Clear DX for DIV operation
    MOV BX,10               ; Set divisor to 10
    DIV BX                    ; AX / 10, remainder in DX
    MOV randomNum,DL      ; Store the result (0-9) in randomNumber

    RET
randomNumber ENDP

; seleciona dois mapas aleatórios para o PLAYER e a CPU
generateMaps PROC
    ; entrada: randomNum, cpuMap, playerMap,maps
    ; saida: playerBoard,cpuBoard

    XOR BX,BX
    XOR DX,DX

    CALL randomNumber
    MOV AH,2h
    MOV DL,randomNum
    OR DL,30h
    INT 21h   
    MOV BL,randomNum
    SHL BX,1
    MOV DX,maps[BX]
    MOV playerMap,DX

    CALL randomNumber
    MOV AH,2h
    MOV DL,randomNum
    OR DL,30h
    INT 21h   
    MOV BL,randomNum
    SHL BX,1
    MOV DX,maps[BX]
    MOV cpuMap,DX

    CALL copyPLAYERMap
    CALL copyCPUMap

    RET
generateMaps ENDP

; copia um mapa selecionado para o tabuleiro da CPU
copyCPUMap PROC
    ; endtrada: cpuMap
    ; saida: cpuBoard

    XOR BX,BX
    MOV DI,cpuMap
    XOR SI,SI
    MOV CX,10

    COPIAR:
        
        XOR DX,DX
        XCHG BX,DI
        MOV DX,[BX][SI]
        XCHG DI,BX
        MOV cpuBoard[BX][SI],DX
        ADD SI,2
        CMP SI,20
        JNZ COPIAR

        ADD BX,SI
        ADD DI,SI
        XOR SI,SI
        LOOP COPIAR

    RET
copyCPUMap ENDP

; copia um mapa selecionado para o tabuleiro do player
copyPLAYERMap PROC
    ; endtrada: playerMap
    ; saida: playerBoard

    XOR BX,BX
    MOV DI,playerMap
    XOR SI,SI
    MOV CX,10

    COPY:
        
        XOR DX,DX
        XCHG BX,DI
        MOV DX,[BX][SI]
        XCHG DI,BX
        MOV playerBoard[BX][SI],DX
        ADD SI,2
        CMP SI,20
        JNZ COPY

        ADD BX,SI
        ADD DI,SI
        XOR SI,SI
        LOOP COPY

    RET
copyPLAYERMap ENDP

; add the maps offset to the array maps
addMapsToArray PROC
    ; entrada: maps,map0,map1,map2,map3,map4,map5,map6,map7,map8,map9
    ; saida: maps

    XOR DX,DX

    LEA DX,map0
    MOV maps[0],DX
    LEA DX,map1
    MOV maps[2],DX
    LEA DX,map2
    MOV maps[4],DX
    LEA DX,map3
    MOV maps[6],DX
    LEA DX,map4
    MOV maps[8],DX
    LEA DX,map5
    MOV maps[10],DX
    LEA DX,map6
    MOV maps[12],DX
    LEA DX,map7
    MOV maps[14],DX
    LEA DX,map8
    MOV maps[16],DX
    LEA DX,map9
    MOV maps[18],DX

    RET

addMapsToArray ENDP

; random number for multiplyer
auxRandomNumber PROC
    XOR CX,CX

    MOV AH,0
    INT 1ah

    MOV AX,DX
    XOR DX,DX
    MOV BX,10
    DIV BX
    
    MOV CL,DL
    INT 21h

    ADD multiplier,CX

    RET
auxRandomNumber ENDP

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

; test code

    CALL addMapsToArray
    CALL generateMaps
    pulaLinha
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
