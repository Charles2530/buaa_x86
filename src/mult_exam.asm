STACK SEGMENT PARA
    STACK_AREA DW  100h DUP(?)
    STACK_TOP  EQU $-STACK_AREA
STACK ENDS

CODE SEGMENT PARA
              ASSUME CS:CODE,SS:STACK
GETINT PROC
              PUSH   CX
              PUSH   BX
              MOV    CX,0
              MOV    BX,10
    INPUT:    
              MoV    AH,1
              INT    21H
              MOV    AH,0
              CMP    AL,'0'
              JB     END_INPUT
              CMP    AL,'9'
              JA     END_INPUT
              SUB    AL,30H
              MOV    AH,0
              XCHG   AX,CX
              MUL    BX
              ADD    AX,CX
              XCHG   AX,CX
              JMP    INPUT
    END_INPUT:
              MOV    AX,CX
              POP    BX
              POP    CX
              RET

GETINT ENDP
PUTINT PROC
              PUSH   AX
              PUSH   BX
              PUSH   CX
              PUSH   DX
              MOV    BX,10
              MOV    AX,DX
              MOV    CX,0
    OUTPUT:   
              MOV    DX,0
              DIV    BX
              PUSH   DX
              INC    CX
              CMP    AX,0
              JNE    OUTPUT
    PRINT:    
              POP    DX
              ADD    DL,30H
              MOV    AH,2
              INT    21H
              LOOP   PRINT
              POP    DX
              POP    CX
              POP    BX
              POP    AX
              RET
PUTINT ENDP
MAIN PROC
MAIN ENDP
              MOV    AX,STACK
              MOV    SS,AX
              MOV    SP,STACK_TOP

              CALL   GETINT
              MOV    BX,AX
              CALL   GETINT
              MUL    BX
              MOV    DX,AX
              CALL   PUTINT

              MOV    AX,4C00H
              INT    21H
CODE ENDS
        END MAIN