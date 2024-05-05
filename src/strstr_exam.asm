STACK SEGMENT PARA
    STACK_AREA DB  100h DUP(?)
    STACK_TOP  EQU $-STACK_AREA
STACK ENDS

DATA SEGMENT
    SUBSTRING DB  0Dh,0Ah
    STR_MAX   EQU 10h
    STR_BUF   DB  STR_MAX-1
    STR_LEN   DB  ?
    STRING    DB  STR_MAX DUP(?)
DATA ENDS

CODE SEGMENT PARA
              ASSUME CS:CODE, DS:DATA,ES:DATA, SS:STACK
FIND PROC
              PUSH   ES
              PUSH   DS
              POP    ES
              MOV    CH,0
              MOV    CL,STR_LEN
              LEA    DI,SUBSTRING
              MOV    AL,[DI]
    SEARCH:   
              LEA    SI,STRING
              REPNE  SCASB
              JNE    NOT_FOUND

    NOT_FOUND:
              MOV    DX,0
              POP    ES
              RET
              
    RETURN:   
              INC    SI
              INC    DI
              MOV    AL,[DI]
              CMP    AL,[SI]
              JNE    SEARCH
              MOV    DH,0
              MOV    DL,STR_BUF
              SUB    DX,CX
              POP    ES
              RET
FIND ENDP
MAIN PROC
              MOV    AX,STACK
              MOV    SS,AX
              MOV    SP,STACK_TOP
              MOV    AX,DATA
              MOV    DS,AX
              MOV    ES,AX

              LEA    DX,STR_BUF
              MOV    AH,0Ah
              INT    21h
              MOV    DL,0AH
              MOV    AH,2
              INT    21H
              MOV    BH,0
              MOV    BL,STR_LEN
              MOV    BYTE PTR STRING[BX],'$'

              CALL   FIND

              MOV    AX,2
              INT    21H

              MOV    AX,4C00H
              INT    21H
MAIN ENDP
CODE ENDS
END MAIN
