STACK SEGMENT PARA
    STACK_AREA DW  100h DUP(?)
    STACK_TOP  EQU $-STACK_AREA
STACK ENDS

DATA SEGMENT PARA
    STR1_MAX EQU 20h
    STR1_BUF DB  STR1_MAX-1
    STR1_LEN DB  ?
    STR1     DB  STR1_MAX DUP(?)
    STR2_MAX EQU 20h
    STR2_BUF DB  STR2_MAX-1
    STR2_LEN DB  ?
    STR2     DB  STR2_MAX DUP(?)
DATA ENDS

CODE SEGMENT PARA
                 ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK
STRCMP PROC
                 PUSH   ES
                 PUSH   DS
                 POP    ES
                 LEA    SI,STR1
                 LEA    DI,STR2
                 MOV    CH,0
                 MOV    AL,STR1_LEN
                 CMP    AL,STR2_LEN
                 JA     MIN_LEN
                 MOV    CL,STR1_LEN
                 JMP    COMPARE
    MIN_LEN:     
                 MOV    CL,STR2_LEN
    COMPARE:     
                 
                 CLD
                 REPE   CMPSB
                 JNE    EXIT
                 CMP    AL,STR2_LEN

    EXIT:        
                 POP    ES
                 RET
STRCMP ENDP
MAIN PROC
                 MOV    AX,STACK
                 MOV    SS,AX
                 MOV    SP,STACK_TOP
                 MOV    AX,DATA
                 MOV    DS,AX
                 MOV    ES,AX

                 LEA    DX,STR1_BUF
                 MOV    AH,0AH
                 INT    21H
                 MOV    DL,0AH
                 MOV    AH,2
                 INT    21H
                 MOV    BH,0
                 MOV    BL,STR1_LEN
                 MOV    BYTE PTR STR1[BX],'$'

                 LEA    DX,STR2_BUF
                 MOV    AH,0AH
                 INT    21H
                 MOV    DL,0AH
                 MOV    AH,2
                 INT    21H
                 MOV    BH,0
                 MOV    BL,STR2_LEN
                 MOV    BYTE PTR STR2[BX],'$'

                 LEA    DX,STR1
                 MOV    AH,9
                 INT    21H
                 
                 CALL   STRCMP
                 
                 JA     MAIN_GREATER
                 JB     MAIN_LESS
                 MOV    DL,'='
                 JE     MAIN_EQUAL
    MAIN_LESS:   
                 MOV    DL,'<'
                 JMP    MAIN_EQUAL
    MAIN_GREATER:
                 MOV    DL,'>'
                 JMP    MAIN_EQUAL
    
    MAIN_EQUAL:  

                 MOV    AH,2
                 INT    21H

                 LEA    DX,STR2
                 MOV    AH,9
                 INT    21H
                 MOV    AX,4C00H
                 INT    21H
MAIN ENDP
CODE ENDS
    END MAIN