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
    playerBoard DW 10 DUP( 10 DUP('~'),'$')                          ; tabuleiro do jogador
    cpuBoard DW 10 DUP( 10 DUP('~'),'$')                             ; tabuleiro da CPU que é exibido na tela
    cpuSecret DW 10 DUP( 10 DUP('~'),'$')                            ; tabuleiro da CPU
    boardSpace DB 32,32,32,32,32,32,32,'$'                           ; string de spaços para o reloadScreen
    seed DW 24653                                                    ; Initial seed value (can be changed for different sequences)
    multiplier DW 13849                                              ; Multiplier constant for LCG
    randomNum DB 0                                                   ; Storage for random number between 0 and 9
    playerMap DW ?                                                   ; endereço de memória do mapa selecionado para o player
    cpuMap DW ?                                                      ; endereço de memória do mapa selecionado para a CPU
    maps DW 10 DUP(?)                                                ; vetor de endereços dos mapas

    hitBoatMsg DB 10,13,'VOCE ACERTOU UM NAVIO $'
    coordenadaInvalidaMsg DB 10,13,'COORDENADA INVALIDA'

    playernBoats DB 1,4,3,2,2,4,4

    cpuBoats DB 1,4,3,2,2,4,4

    eixoX DW '  ','0','1','2','3','4','5','6','7','8','9','$'
    eixoY DB 'A','B','C','D','E','F','G','H','I','J'

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
         DW '~','E','E','E','E','~','~','~','~','F'
         DW '~','~','~','~','~','~','~','~','~','F'
         DW '~','~','~','~','~','~','S','~','~','F'
         DW '~','~','~','~','~','~','S','~','~','~'
         DW '~','~','s','s','~','~','~','~','H','~'
         DW '~','~','~','~','~','h','~','H','H','H'
         DW '~','~','~','~','h','h','~','~','~','~'
         DW '~','~','~','~','~','h','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
    
    map2 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','E','~','S','~','~','~','H','~','~'
         DW '~','E','~','S','~','~','H','H','~','~'
         DW '~','E','~','~','~','~','~','H','~','~'
         DW '~','E','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','s','s'
         DW '~','~','~','h','~','~','~','~','~','~'
         DW '~','~','h','h','h','~','~','~','~','~'
         DW '~','~','~','~','~','~','F','F','F','~'
    
    map3 DW 'H','~','~','~','~','~','~','~','~','~'
         DW 'H','H','~','~','~','~','~','~','~','~'
         DW 'H','~','~','F','F','F','~','~','S','~'
         DW '~','~','~','~','~','~','~','~','S','~'
         DW '~','s','~','~','h','~','~','~','~','~'
         DW '~','s','~','h','h','~','~','~','~','~'
         DW '~','~','~','~','h','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','E','E','E','E','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
    
    map4 DW '~','~','~','H','~','~','~','~','~','~'
         DW '~','~','H','H','H','~','F','~','~','~'
         DW '~','~','~','~','~','~','F','~','~','~'
         DW 'S','S','~','E','~','~','F','~','~','~'
         DW '~','~','~','E','~','~','~','~','~','~'
         DW '~','~','~','E','~','~','s','s','~','~'
         DW '~','~','~','E','~','~','~','~','~','~'
         DW '~','~','~','E','~','~','~','~','~','~'
         DW '~','~','~','~','~','h','~','~','~','~'
         DW '~','~','~','~','h','h','h','~','~','~'
    
    map5 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','H','~','~','~','E','E','E','E','~'
         DW '~','H','H','~','~','~','~','~','~','~'
         DW '~','H','~','~','~','~','~','S','~','~'
         DW '~','~','~','~','~','~','~','S','~','~'
         DW '~','~','~','F','F','F','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','h','~'
         DW '~','~','~','~','s','~','~','h','h','~'
         DW '~','~','~','~','s','~','~','~','h','~'
         DW '~','~','~','~','~','~','~','~','~','~'
    
    map6 DW '~','~','~','~','~','~','~','~','~','~'
         DW 'E','~','~','~','H','H','H','~','~','~'
         DW 'E','~','~','~','~','H','~','~','~','~'
         DW 'E','~','~','~','~','~','~','~','~','~'
         DW 'E','~','~','F','~','~','s','s','~','~'
         DW '~','~','~','F','~','~','~','~','~','~'
         DW '~','~','~','F','~','~','~','~','h','~'
         DW 'S','S','~','~','~','~','~','h','h','~'
         DW '~','~','~','~','~','~','~','~','h','~'
         DW '~','~','~','~','~','~','~','~','~','~'
    
    map7 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','H','~'
         DW '~','~','E','E','E','E','~','H','H','~'
         DW '~','~','~','~','~','~','~','~','H','~'
         DW '~','S','S','~','~','~','~','~','~','~'
         DW '~','~','~','~','F','F','F','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','s','s','~','~','~','h','~','~','~'
         DW '~','~','~','~','~','~','h','h','~','~'
         DW '~','~','~','~','~','~','h','~','~','~'
    
    map8 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','H','H','H','~','~','F','F','F','~'
         DW '~','~','H','~','~','~','~','~','~','~'
         DW '~','~','~','~','h','~','~','~','~','~'
         DW '~','~','~','h','h','h','~','~','~','~'
         DW '~','~','~','~','~','~','~','s','s','~'
         DW '~','S','S','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','E','E','E','E','~','~','~'
    
    map9 DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','E','E','E','E','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW 'h','~','~','~','~','~','H','H','H','~'
         DW 'h','h','~','~','~','~','~','H','~','~'
         DW 'h','~','~','~','~','F','~','~','~','~'
         DW '~','~','S','S','~','F','~','~','~','~'
         DW '~','~','~','~','~','F','~','s','s','~'
         DW '~','~','~','~','~','~','~','~','~','~'
         DW '~','~','~','~','~','~','~','~','~','~'
    
.CODE

updateScreen PROC
    ; updates the screen with the current matrizes of the PLAYERBOARD and CPUBOARD
    ; entrada: PLAYERBOARD, CPUBOARD, BOARDSPACE
    ; saida: void

    MOV CX,10
    XOR BX,BX
    XOR DI,DI
    ; o index do eixo x da matriz (numeros)
    MOV AH,9h
    LEA DX,eixoX
    INT 21h
    LEA DX,boardSpace
    INT 21h
    LEA DX,eixoX
    INT 21h
    pulaLinha
    ; for_loop
    REPEAT:
        ; imprime a letra da linha correspondente
        MOV AH,2h
        MOV DL,eixoY[DI]
        INT 21h
        MOV DL,' '
        INT 21h
        ; imprime uma linha da matriz do jogador
        MOV AH,9h
        LEA DX,playerBoard[BX]
        INT 21h
        LEA DX,boardSpace
        INT 21h
        ; imprime a letra da linha correspondente
        MOV AH,2h
        MOV DL,eixoY[DI]
        INT 21h
        MOV DL,' '
        INT 21h
        ; imprime uma linha da matriz da cpu
        MOV AH,9h
        LEA DX,cpuBoard[BX]      
        INT 21h
        pulaLinha
        ADD BX,22
        INC DI
        LOOP REPEAT
    ; end_for
    RET
updateScreen ENDP

randomNumber PROC
    ; gera um número aleatório entre 0 e 9
    ; entrada: seed,multiplier,randomNum
    ; saida: randomNum
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

generateMaps PROC
    ; seleciona dois mapas aleatórios para o PLAYER e a CPU
    ; entrada: randomNum, cpuMap, playerMap,maps
    ; saida: playerBoard,cpuBoard

    XOR BX,BX
    XOR DX,DX

    ; gera um numero aleatório entre 0-9 e então pega o mapa com o index correpondente no vetor maps e coloca o endereço de memória da matriz do mapa selecionádo em playerMap
    CALL randomNumber
    MOV AH,2h
    MOV DL,randomNum
    OR DL,30h
    INT 21h   
    MOV BL,randomNum
    SHL BX,1
    MOV DX,maps[BX]
    MOV playerMap,DX

    ; gera um numero aleatório entre 0-9 e então pega o mapa com o index correpondente no vetor maps e coloca o endereço de memória da matriz do mapa selecionádo em cpuMap
    CALL randomNumber
    MOV AH,2h
    MOV DL,randomNum
    OR DL,30h
    INT 21h   
    MOV BL,randomNum
    SHL BX,1
    MOV DX,maps[BX]
    MOV cpuMap,DX

    ; copia os mapas selecionados em playerMap e cpuMap nas matrizes playerBoard e cpuSecret
    CALL copyPLAYERMap
    CALL copyCPUMap

    RET
generateMaps ENDP

copyCPUMap PROC
    ; copia um mapa selecionado para o tabuleiro da CPU
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

        ADD BX,22
        ADD DI,20
        XOR SI,SI
        LOOP COPIAR

    RET
copyCPUMap ENDP

copyPLAYERMap PROC
    ; copia um mapa selecionado para o tabuleiro do player
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

        ADD BX,22
        ADD DI,20
        XOR SI,SI
        LOOP COPY

    RET
copyPLAYERMap ENDP

addMapsToArray PROC
    ; add the maps offset to the array maps for random map selection
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

auxRandomNumber PROC
    ; random number for multiplier
    ; entrada: void
    ; saida: multiplier
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

inputPlayerTarget PROC
    ; entrada: cpuSecret, cpuBoard
    ; saida: DX (DL:x-cordenada DH: y-coordenada)

    MOV AH,1h
    INT 21h
    AND AL,0Fh
    MOV DL,AL
    INT 21h
    SUB AL,55
    MOV DH,AL

    DO_WHILE2:
        XOR AX,AX
        MOV AH,1h
        INT 21h
        AND AL,0Fh
        MOV BL,AL
        MOV AL,22
        MUL BL
        MOV BX,AX
        INT 21h
        SUB AL,55
        MOV AL,2
        MUL AH
        MOV DI,AX
        MOV CX,playerBoard[BX][DI]
        CMP CX,'X'
        JZ DO_WHILE2
        CMP CX,'O'
        JZ DO_WHILE2
        XOR DX,DX
        MOV DX,DI
        MOV DH,BL
        ROR DX,8
        CALL verifyIftargetHit

    RET
inputPlayerTarget ENDP

verifyIftargetHit PROC
    ; entrada: DX (coordenadas do alvo),
    ;          BX OFFSET da matriz a ser lida (player ou cpu), 
    ;          SI OFFSET do vetor dos barcos
    ; saida: void encreve na tela se foi acertado algum alvo

    MOV AL,DH
    MUL DL
    AND DX,00FFh
    MOV DI,DX
    ADD BX,AX
    MOV AH,9h
    MOV CX,[BX][DI]
    CMP CX,'~'
    JZ MISS
    CMP CX,'E'
    JZ HITENCOURAÇADO
    CMP CX,'F'
    JZ HITFRAGATA
    CMP CX,'S'
    JZ HITSUB1
    CMP CX,'s'
    JZ HITSUB2
    CMP CX,'H'
    JZ HITHIDRO1
    CMP CX,'h'
    JZ HITHIDRO2
    COORDENADAINVALIDA:
    LEA DX,coordenadaInvalidaMsg
    INT 21h
    JMP EXIT5

    HITENCOURAÇADO:
    DEC BYTE PTR [SI+1]
    JMP HIT
    HITFRAGATA:
    DEC BYTE PTR [SI+2]
    JMP HIT
    HITSUB1:
    DEC BYTE PTR [SI+3]
    JMP HIT
    HITSUB2:
    DEC BYTE PTR [SI+4]
    JMP HIT
    HITHIDRO1:
    DEC BYTE PTR [SI+5]
    JMP HIT
    HITHIDRO2:
    DEC BYTE PTR [SI+6]
    HIT:
    LEA DX,hitBoatMsg
    INT 21h
    MOV CX,'X'
    JMP EXIT5
    MISS:
    DEC BYTE PTR [SI]
    MOV CX,'O'
    EXIT5:
    RET
verifyIftargetHit ENDP

inputCpuTarget PROC
    ;Procedimento para ataque da CPU
    ;entrada: randomNumber
    ;saída: transforma a posição da matriz atacada em X ou O dependendo se foi um ataque bem-sucedido ou não
    PUSH BX
    PUSH DI
    PUSH AX
    PUSH CX
    PUSH DX
    
    DO_WHILE:
        XOR AX,AX
        CALL randomNumber
        MOV BL,randomNum
        MOV AL,22
        MUL BL
        MOV BX,AX
        CALL randomNumber
        MOV AH,randomNum
        MOV AL,2
        MUL AH
        MOV DI,AX
        MOV CX,playerBoard[BX][DI]
        CMP CX,'X'
        JZ DO_WHILE
        CMP CX,'O'
        JZ DO_WHILE
        XOR DX,DX
        MOV DX,DI
        MOV DH,BL
        ROR DX,8
        CALL verifyIftargetHit

    POP DX
    POP CX
    POP AX
    POP DI
    POP BX

    RET
inputCpuTarget ENDP

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

; test code
    CALL addMapsToArray
    CALL generateMaps
    pulaLinha

    CALL updateScreen

    CALL inputPlayerTarget

    CALL inputCpuTarget



    
; end test code
; code_overview

    ; gerarMapas

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