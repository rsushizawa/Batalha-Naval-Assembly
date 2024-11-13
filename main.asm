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
delay MACRO
    LOCAL PRINTF
    PRINTF:
    PUSH AX
    MOV AH,1
    INT 21h
    POP AX
ENDM

imprime_string MACRO string
    LOCAL PRINTF
    PUSH SI
    PUSH AX
    PUSH DX
    PUSH CX

    MOV CX,6
    LEA SI,string
    
PRINTF:
        MOV AH,2

        MOV DL,[SI]
        ADD DL,'0'
        INT 21H
        MOV DL,' '
        INT 21H
        INC SI
        LOOP PRINTF

    POP CX
    POP DX
    POP AX
    POP SI
    
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

    missBoatMsg DB 10,13,'VOCE ERROU$'
    hitBoatMsg DB 10,13,'VOCE ACERTOU UM NAVIO $'
    coordenadaInvalidaMsg DB 10,13,'COORDENADA INVALIDA$'
    playerTurnMsg DB 10,13,'VEZ DO JOGADOR$'
    playerInputMsg DB 10,13,'DIGITE AS CONDENADAS DO SEU ALVO (NUMERO/LETRA): $'
    cpuTurnMsg DB 10,13,'VEZ DA CPU$'
    cpuInputMsg DB 10,13,'COORDENADAS ALVO DA CPU: $'

    playerBoats DB 4,3,2,2,4,4
    hitBoat DB 1
    cpuBoats DB 4,3,2,2,4,4
    sunkShips DB 0


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
         DW '~','~','~','~','~','~','~','~','H','~'
         DW '~','~','~','~','F','F','F','~','~','~'
         DW '~','~','E','E','E','E','~','H','H','~'
         DW '~','S','S','~','~','~','~','~','~','~'
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

    pulaLinha

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
        ; imprime uma linha da matriz da cpu
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
        ; imprime uma linha da matriz do jogador
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

inputPlayerTarget PROC
    ; entrada: cpuSecret, cpuBoard
    ; saida: DX (DL:x-cordenada DH: y-coordenada)

    DO_WHILE2:
        MOV AH,1h
        INT 21h

        SUB AL,30H

        CMP AL,9
        JA COORDENADAINVALIDA

        AND AX,000FH
        SHL AX,1

        MOV DI,AX

        MOV AH,1h
        INT 21h

        SUB AL,'A'

        CMP AL,9
        JA COORDENADAINVALIDA
        
        MOV DL,22
        MUL DL
        MOV BX,AX

        MOV CX,cpuSecret[BX][DI]
        CMP CX,'X'
        JZ DO_WHILE2
        CMP CX,'O'
        JZ DO_WHILE2
        XOR DX,DX
        MOV DX,DI
        MOV DH,BL

    RET

    COORDENADAINVALIDA:
    PUSH AX
    pulaLinha
    MOV AH,9
    LEA DX,coordenadaInvalidaMsg
    INT 21h
    pulaLinha
    POP AX
    JMP DO_WHILE2
inputPlayerTarget ENDP

transferSecrettoBoard PROC
    
    PUSH CX
    PUSH AX
    PUSH SI
    PUSH BX

    XOR BX,BX

    NEWLINE:
        MOV CX,10
        XOR SI,SI
    TRANSFER:
        MOV AX,cpuSecret[BX][SI]
        CMP AL,'X'
        JZ SUBSTITUTE
        CMP AL,'O'
        JZ SUBSTITUTE

    CONTINUE_TRANSFER:
        ADD SI,2
        LOOP TRANSFER

        ADD BX,22
        CMP BX,220
        JNZ NEWLINE

        POP BX
        POP SI
        POP AX
        POP CX

        RET

    SUBSTITUTE:
        MOV cpuBoard[BX][SI],AX
        JMP CONTINUE_TRANSFER



    RET

transferSecrettoBoard ENDP    

inputCpuTarget PROC
    INPUT:
    CALL randomNumber
    MOV AH,2
    MOV DL,randomNum
    ADD DL,30h
    INT 21h
    MOV AL,randomNum
    AND AX,000FH
    SHL AX,1
    MOV DI,AX

    CALL randomNumber
    MOV AH,2
    MOV DL,randomNum
    ADD DL,65
    INT 21h
    MOV AL,randomNum
    AND AX,000FH
    MOV BX,22
    MUL BL
    MOV BX,AX


    
    CMP cpuSecret[BX][DI],'O' 
    JZ INPUT

    CMP cpuSecret[BX][DI],'X' 
    JZ INPUT

    XOR DX,DX
    MOV DX,DI
    MOV DH,BL

    RET
inputCpuTarget ENDP

verifyIftargetHit PROC
    ; entrada: DX (DL:x-cordenada DH: y-coordenada),
    ;          BX OFFSET da matriz a ser lida (player ou cpu),
    ;          SI OFFSET do vetor dos barcos
    ; saida: void encreve na tela se foi acertado algum alvo

    XOR CX,CX
    MOV CL,DH
    ADD BX,CX
    AND DX,00FFh
    MOV DI,DX

    MOV AH,9h
    ; switch (input)
    MOV DX,[BX][DI]
    ; case [input] = '~'
        CMP DX,'~'
        JZ MISS
    ; case [input] = 'E'
        CMP DX,'E'
        JNZ CONTINUE1
        DEC BYTE PTR [SI]
        JMP HIT ; break
    CONTINUE1:
    ; case [input] = 'F'
        CMP DX,'F'
        JNZ CONTINUE2
        DEC BYTE PTR [SI+1]
        JMP HIT ; break
    CONTINUE2:
    ; case [input] = 'S'
        CMP DX,'S'
        JNZ CONTINUE3
        DEC BYTE PTR [SI+2]
        JMP HIT ; break
    CONTINUE3:
    ; case [input] = 's'
        CMP DX,'s'
        JNZ CONTINUE4
        DEC BYTE PTR [SI+3]
        JMP HIT ; break
    CONTINUE4:
    ; case [input] = 'H'
        CMP DX,'H'
        JNZ CONTINUE5
        DEC BYTE PTR [SI+4]
        JMP HIT ; break
    CONTINUE5:
    ; case [input] = 'h'
        CMP DX,'h'
        JNZ CONTINUE6
        DEC BYTE PTR [SI+5]
        JMP HIT ; break
    CONTINUE6:
    ; default: coordenadaInválida 
        LEA DX,coordenadaInvalidaMsg
        INT 21h
        pulaLinha
        JMP EXIT5
    ; end_switch

    ; if hit
    HIT:
        LEA DX,hitBoatMsg
        INT 21h
        pulaLinha
        MOV DX,'X'
        MOV [BX][DI],DX
        JMP EXIT5
    ; else if miss
    MISS:
        LEA DX,missBoatMsg
        INT 21h
        DEC BYTE PTR hitBoat
        MOV DX,'O'
        MOV [BX][DI],DX
    ; else
    EXIT5:
    RET
verifyIftargetHit ENDP

verifyPlayerSunkships PROC
    
    PUSH AX
    PUSH SI

    XOR SI,SI

    imprime_string playerBoats

    COMPARE:
        MOV AL,playerBoats[SI]
        CMP AL,0
        JNZ CONTINUA
        INC BYTE PTR sunkShips
    
    CONTINUA:
        INC SI
        CMP BYTE PTR sunkShips,6
        JZ GAMEOVER
        CMP SI,5
        JZ ENDING
        
        
        JMP COMPARE

    ENDING:
        MOV BYTE PTR sunkShips,0
        POP SI
        POP AX
        RET  

    GAMEOVER:
        MOV AH,4ch
        INT 21H
    

verifyPlayerSunkships ENDP

verifyCPUSunkships PROC
    
    PUSH AX
    PUSH SI

    XOR SI,SI

    imprime_string cpuBoats

    COMPARE_CPU:
        MOV AL,cpuBoats[SI]
        CMP AL,0
        JNZ CONTINUA_CPU
        INC BYTE PTR sunkShips
    
    CONTINUA_CPU:
        INC SI
        CMP BYTE PTR sunkShips,6
        JZ GAMEOVER_CPU
        CMP SI,5
        JZ ENDING_CPU
        
        JMP COMPARE_CPU

    ENDING_CPU:
        MOV BYTE PTR sunkShips,0
        POP SI
        POP AX
        RET 

    GAMEOVER_CPU:
        MOV AH,4ch
        INT 21h


verifyCPUSunkships ENDP

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
; code_overview

    CALL addMapsToArray
    CALL generateMaps
    pulaLinha
        PLAYER_REPEAT:
            CALL updateScreen
            MOV AH,9h
            LEA DX,playerTurnMsg
            INT 21h
            LEA DX,playerInputMsg
            INT 21h
                CALL inputPlayerTarget
                LEA BX,cpuBoard
                LEA SI,cpuBoats
                CALL verifyIftargetHit
                CALL verifyCPUSunkships
                CALL transferSecrettoBoard    
            MOV CL,hitBoat
            OR CL,CL
            JNZ PLAYER_REPEAT
            

            INC BYTE PTR hitBoat
        CPU_REPEAT:
            CALL updateScreen
            MOV AH,9h
            LEA DX,cpuTurnMsg
            INT 21h
            LEA DX,cpuInputMsg
            INT 21h
                CALL inputCpuTarget
                LEA BX,playerBoard
                LEA SI,playerBoats
                CALL verifyIftargetHit
                CALL verifyPlayerSunkships
            MOV CL,hitBoat
            OR CL,CL
            JNZ CPU_REPEAT
            

            INC BYTE PTR hitBoat

        JMP PLAYER_REPEAT

    MOV AH,4ch
    INT 21h
MAIN ENDP
END MAIN