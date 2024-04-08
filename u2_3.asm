STACKS SEGMENT PARA STACK 'STACK'
    STACK_AREA DW  100h DUP(?)
    STACK_TOP  EQU $-STACK_AREA
STACKS ENDS

DATA SEGMENT PARA 'DATA'
    XXH        DW 2137h
    XXL        DW 3191h
    YYH        DW 1234h
    YYL        DW 5678h
    result     DW 4 DUP(0)
    space_char DB ' ','$'
DATA ENDS

CODE SEGMENT PARA 'CODE'
               ASSUME CS:CODE, DS:DATA, SS:STACKS
    START:     
               MOV    AX, DATA
               MOV    DS, AX

               MOV    AX, STACKS
               MOV    SS, AX
               MOV    SP, STACK_TOP

               
    mult_pro:  
               MOV    AX,XXL
               MUL    YYL
               ADD    [result+2],DX
               ADD    [result] ,AX
               MOV    AX,XXH
               MUL    YYL
               ADD    [result+4],DX
               ADD    [result+2],AX
               CLC
               MOV    AX,XXL
               MUL    YYH
               ADD    [result+4],DX
               ADD    [result+2],AX
               CLC
               MOV    AX,XXH
               MUL    YYH
               ADD    [result+6],DX
               ADD    [result+4],AX
               CLC

               MOV    CX,4
               MOV    SI,6
    print_loop:
               MOV    AX,[result+SI]
               CALL   PRINT_NUM
               CALL   Space
               DEC    SI
               DEC    SI
               LOOP   print_loop

    EXIT:      
               MOV    AH, 4CH
               INT    21H

PRINT_NUM PROC Near
               PUSH   AX
               PUSH   BX
               PUSH   CX
               PUSH   DX

               MOV    CX, 0
    ;    MOV    BX, 10
               MOV    BX, 16
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
CODE ENDS
END START