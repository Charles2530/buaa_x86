STACK SEGMENT PARA
    STACK_AREA DW  100h DUP(?)
    STACK_TOP  EQU $-STACK_AREA
STACK ENDS

DATA SEGMENT PARA
    HEX  DB "0123456789ABCDEF"
DATA ENDS

CODE SEGMENT PARA
            ASSUME CS:CODE,DS:DATA,SS:STACK

GETINT PROC
            PUSH   CX
            PUSH   BX
            MOV    BX,10
            MOV    CX,0
    INPUT:  
            MOV    AH,1
            INT    21H
            CMP    AL,'0'
            JB     RETURN
            CMP    AL,'9'
            JA     RETURN
            MOV    AH,0
            SUB    AL,30H
            XCHG   CX,AX
            MUL    BX
            ADD    AX,CX
            XCHG   CX,AX
            JMP    INPUT
    RETURN: 
            MOV    AX,CX
            POP    BX
            POP    CX
            RET
GETINT ENDP
PUTHEX8 PROC
            PUSH   BX
            PUSH   CX
            PUSH   DX
            PUSH   AX
            MOV    BX,0
            MOV    BL,AL
            MOV    CL,4
            SHR    BX,CL
            MOV    DL,BYTE PTR HEX[BX]
            MOV    AH,2
            INT    21H
            POP    AX
            AND    AL,0FH
            MOV    AH,0
            MOV    BX,AX
            MOV    DL,BYTE PTR HEX[BX]
            MOV    AH,2
            INT    21H
            POP    DX
            POP    CX
            POP    BX
            RET
PUTHEX8 ENDP
PUTHEX PROC
            PUSH   AX
            PUSH   DX
            MOV    AL,DH
            CALL   PUTHEX8
            MOV    AL,DL
            CALL   PUTHEX8
            POP    DX
            POP    AX
            RET
PUTHEX ENDP
MAIN PROC
            MOV    AX,DATA
            MOV    DS,AX
            MOV    AX,STACK
            MOV    SS,AX
            MOV    SP,STACK_TOP
            CALL   GETINT
            MOV    BX,AX
            CALL   GETINT
            MUL    BX
            MOV    DX,AX
            CALL   PUTHEX
            MOV    AH,4CH
            INT    21H

MAIN ENDP

CODE ENDS
END MAIN