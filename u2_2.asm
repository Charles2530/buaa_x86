STACKS SEGMENT PARA STACK 'STACK'
    STACK_AREA DW  100h DUP(?)
    STACK_TOP  EQU $-STACK_AREA
STACKS ENDS

DATA SEGMENT PARA 'DATA'
    ARRAY        DW 10 DUP(?)
    space_char   DB ' ','$'
    Error_string DB 'ERROR: OVERFLOW! Please input again:','$'
DATA ENDS

CODE SEGMENT PARA 'CODE'
               ASSUME CS:CODE, DS:DATA, SS:STACKS
    START:     
               MOV    AX, DATA
               MOV    DS, AX

               MOV    AX, STACKS
               MOV    SS, AX
               MOV    SP, STACK_TOP

               MOV    SI,0
               MOV    CX,2
    Input_pro: 
               CALL   Input
               INC    SI
               INC    SI
               LOOP   Input_pro
               CALL   CRLF

               MOV    SI,0
               MOV    AX,ARRAY[SI]
               MOV    BX,ARRAY[SI+2]
               MUL    BX
               CALL   PRINT_NUM
               CALL   CRLF
    EXIT:      
               MOV    AH, 4CH
               INT    21H

Input PROC Near
               push   AX
               push   BX
               push   CX
               push   DX


               MOV    BX, 0
               CLC
               MOV    DX, 0
    ;----------输入数字--------------
    Lp_0:      
               MOV    AH, 1
               INT    21H
               CMP    AL, 20H                        ;空格
               JE     L_CRLF

    ;-----   x belong to [0,9]   ----------
               SUB    AL, 30H                        ; ASCII -> int
               JL     L_ERROR
               CMP    AL, 9
               JG     L_ERROR
    ;-------  string -> int   -----------
               MOV    AH, 0                          ;将 AL扩展成 AX
               XCHG   AX, BX                         ;保护 AX值
               MOV    CX, 10
               MUL    CX                             ; bx *= 10
               ADD    AX , BX
               JC     L_ERROR                        ; OVERFLOW处理
               XCHG   AX, BX
               JMP    Lp_0
    L_ERROR:   
               MOV    DX, 0
               MOV    BX, 0
               CALL   CRLF                           ; 换行
               CALL   ERROR                          ; 输出错误提示
               JMP    Lp_0
    L_CRLF:                                          ; 以换行作为一个数的结束标志
               MOV    DX, 0
               MOV    ARRAY[SI], BX                  ;
               POP    DX
               POP    CX
               POP    BX
               POP    AX
               RET
Input ENDP
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
ERROR PROC Near
               push   BX
               push   DX
               MOV    DX, OFFSET Error_string
               MOV    AH, 9
               INT    21H
               pop    DX
               pop    BX
               RET
ERROR ENDP
CODE ENDS
END START