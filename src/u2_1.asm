STACK SEGMENT PARA STACK
    STACK_AREA DW  100H DUP(?)
    STACK_TOP  EQU $-STACK_AREA
STACK ENDS

DATA SEGMENT PARA PUBLIC 'DATA'                                  ; data segment
    ARRAY_LEN  DW 10
    ARRAY      DW 2137h,7191h,100,200,300,250,150,350,400,500
    space_char DB ' ','$'

DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE'
                     ASSUME CS:CODE, DS:DATA, SS:STACK
    

PRINT_NUM PROC Near
                     PUSH   AX
                     PUSH   BX
                     PUSH   CX
                     PUSH   DX

                     MOV    CX, 0
                     MOV    BX, 10
    ;  MOV    BX, 16
    LAST:            
                     MOV    DX, 0
                     DIV    BX
                     PUSH   DX
                     INC    CX
                     CMP    AX, 0
                     JNZ    LAST
    AGE:             
                     POP    DX
                     OR     DX, 30H
                     CMP    DX, '9'
                     JLE    PRINT_CHAR
                     ADD    DX, 7

    PRINT_CHAR:      
                     MOV    AH, 2
                     INT    21H
                     LOOP   AGE
                     POP    DX
                     POP    CX
                     POP    BX
                     POP    AX
                     RET

PRINT_NUM ENDP
PRINT_ARRAY PROC NEAR
                     PUSH   AX
                     PUSH   BX
                     PUSH   CX
                     PUSH   DX
                     MOV    CX, ARRAY_LEN
                     MOV    BX, OFFSET ARRAY
    PAL1:            
                     MOV    AX, [BX]
                     CALL   PRINT_NUM
    ;  CALL   PRINT_HEX
                     CALL   Space
                     ADD    BX, 2
                     LOOP   PAL1
                     CALL   CRLF
                     POP    DX
                     POP    CX
                     POP    BX
                     POP    AX
                     RET
PRINT_ARRAY ENDP

Space PROC Near
                     push   AX
                     push   DX
                     MOV    DX, OFFSET space_char
                     MOV    AH, 9
                     INT    21H
                     pop    DX
                     pop    AX
                     RET
Space ENDP

CRLF PROC Near
                     push   AX
                     push   DX
                     MOV    DL, 0ah
                     MOV    AH, 2
                     INT    21H
                     pop    DX
                     pop    AX
                     RET
CRLF ENDP

BUBBLE_SORT PROC
    LP1:             MOV    BX,1
                     MOV    CX,ARRAY_LEN
                     DEC    CX
                     MOV    SI,OFFSET ARRAY
    LP2:             MOV    AX,[SI]
                     CMP    AX,[SI+2]
                     JBE    CONTINUE
                     XCHG   AX,[SI+2]
                     MOV    [SI],AX
                     MOV    BX,0
    CONTINUE:        
                     ADD    SI,2
                     LOOP   LP2

                     CMP    BX,1
                     JZ     EXIT
                     JMP    SHORT   LP1
BUBBLE_SORT ENDP

MAIN PROC
    START:           MOV    AX,STACK
                     MOV    SS,AX
                     MOV    SP,STACK_TOP
                     MOV    AX,DATA
                     MOV    DS,AX                         ;SET SS,SP,DS
    PRINT_BEFOR_SORT:
                     CALL   PRINT_ARRAY
    SORT:            
                     CALL   BUBBLE_SORT
    EXIT:            
                     CALL   PRINT_ARRAY
                     MOV    AX,4C00H
                     INT    21H
MAIN ENDP
CODE ENDS
END MAIN

