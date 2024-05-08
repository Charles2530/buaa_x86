STACK SEGMENT PARA
    STACK_AREA DW  100h DUP(?)
    STACK_TOP  EQU $-STACK_AREA
STACK ENDS

DATA SEGMENT PARA
    HEX      DB  "0123456789ABCDEF"
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
                        ASSUME CS:CODE, DS:DATA,ES:DATA, SS:STACK
MEMSET PROC
                        PUSH   ES
                        PUSH   DS
                        POP    ES
                        MOV    AL,0
                        MOV    CL,STR1_LEN
                        LEA    DI,STR1
                        CLD
                        REP    STOSB
                        POP    ES
                        RET
MEMSET ENDP
MEMCPY PROC
                        PUSH   ES
                        PUSH   DS
                        POP    ES
                        MOV    CL,STR1_LEN
                        LEA    SI,STR1
                        LEA    DI,STR2
                        CLD
                        REP    MOVSB
                        POP    ES
                        RET
MEMCPY ENDP
STRCMP PROC
                        PUSH   ES
                        PUSH   DS
                        POP    ES
                        LEA    SI,STR1
                        LEA    DI,STR2
                        MOV    AL,STR1_LEN
                        MOV    CL,STR1_LEN
                        CMP    AL,CL
                        JA     STRCMP_CMPARE
                        MOV    CL,STR2_LEN
    STRCMP_CMPARE:      
                        REPZ   CMPSB
                        JNZ    STRCMP_END
                        CMP    AL,STR2_LEN
    STRCMP_END:         
                        POP    ES
                        RET
STRCMP ENDP
FIND PROC
                        PUSH   ES
                        PUSH   DS
                        POP    ES
                        LEA    DI, STR1
                        MOV    SI,0
    FIND_LOOP:          
                        MOV    CL, STR1_LEN
                        REPNE  SCASB
                        JNE    FIND_END
                        INC    SI
                        INC    DI
                        JMP    FIND_LOOP
    FIND_END:           
                        MOV    AX, SI
                        POP    ES
                        RET
FIND ENDP
PUTHEX8 PROC
                        PUSH   BX
                        PUSH   CX
                        PUSH   DX
                        PUSH   AX
                        MOV    CX,4
                        MOV    BX,0
                        MOV    BL,AL
                        SHR    BL,CL
                        MOV    DL,HEX[BX]
                        MOV    AH,2
                        INT    21H
                        POP    AX
                        PUSH   AX
                        MOV    BL,AL
                        AND    AL,0FH
                        MOV    DL,HEX[BX]
                        MOV    AH,2
                        INT    21H
                        POP    AX
                        POP    DX
                        POP    CX
                        POP    BX
                        RET
PUTHEX8 ENDP
PUTHEX16 PROC
                        PUSH   AX
                        PUSH   DX
                        MOV    AL,DH
                        CALL   PUTHEX8
                        MOV    AL,DL
                        CALL   PUTHEX8
                        POP    DX
                        POP    AX
PUTHEX16 ENDP
GETINT PROC
                        PUSH   BX
                        PUSH   CX

                        MOV    BX,10
                        MOV    CX,0
    GETINT_INPUT_LOOP:  
                        MOV    AH,1
                        INT    21H
                        CMP    AL,'0'
                        JB     GETINT_INPUT_END
                        CMP    AL,'9'
                        JA     GETINT_INPUT_END
                        SUB    AL,'0'
                        XCHG   AX,CX
                        MUL    BX
                        ADD    AX,CX
                        XCHG   AX,CX
                        JMP    GETINT_INPUT_LOOP
    GETINT_INPUT_END:   
                        MOV    AX,CX

                        POP    CX
                        POP    BX
                        RET
GETINT ENDP
PUTINT PROC
                        PUSH   AX
                        PUSH   BX
                        PUSH   CX
                        PUSH   DX
                        MOV    BX,10
                        MOV    CX,0
    PUTINT_OUTPUT_LOOP: 
                        MOV    DX,0
                        DIV    BX
                        PUSH   DX
                        INC    CX
                        CMP    AX,0
                        JNE    PUTINT_OUTPUT_LOOP

    PUTINT_OUTPUT_LOOP2:
                        POP    DX
                        ADD    DL,'0'
                        MOV    AH,2
                        INT    21H
                        LOOP   PUTINT_OUTPUT_LOOP2

                        POP    DX
                        POP    CX
                        POP    BX
                        POP    AX
                        RET
PUTINT ENDP
MAIN PROC
                        MOV    AX,DATA
                        MOV    DS,AX
                        MOV    ES,AX
                        MOV    AX,STACK
                        MOV    SS,AX
                        MOV    SP,STACK_TOP


                        MOV    AX,4C00H
                        INT    21H
MAIN ENDP

CODE ENDS
END MAIN