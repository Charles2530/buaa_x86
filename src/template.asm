-----数据段------------
DATAS SEGMENT
    string_1 DB 'Please input 10 numbers(0-65536):','$'
    string_2 DB 'ERROR: OVERFLOW! Please input again:','$'
    string_3 DB 'The array you have input is:',0ah,0dh,'$'
    string_4 DB 'After Sort the num is:',0ah,0dh,'$'
    string_5 DB ' ','$'
    DATA     DW 10 DUP(?)
    massege  DB 'The sum of the array is: ',0ah,0DH,'$'
DATAS ENDS

;-----堆栈段------------
STACKS SEGMENT
           DW 256 dup(?)
STACKS ENDS

;-----代码段------------
CODES SEGMENT
            ASSUME CS:CODES,DS:DATAS,SS:STACKS


    ;-----------程序开始------------
    START:  
            MOV    AX,DATAS
            MOV    DS,AX
            MOV    SI, 0                          ;指针初始化
            MOV    CX, 10                         ;循环次数
    ;---------Input----------
            MOV    DX, OFFSET string_1            ;Please input 10 numbers(0-65536)
            MOV    AH, 9
            INT    21H
    Lp:     
            CALL   Input
            ADD    SI, 2
            Loop   Lp
    ;--------结束输入，换行---------------
            CALL   CRLF
            MOV    DX, OFFSET string_3            ;'The array you have input is:'
            MOV    AH, 9                          ;首地址 DS:DX
            INT    21H
    ;-------输出 ----------------
            MOV    CX, 10
            MOV    DI, 0
    Again:  
            CALL   Print
            CALL   Space
            ADD    DI , 2
            Loop   Again
    ;/******************************/
    ;----------Sort-----------
            MOV    CX, 9
            MOV    DI, 0
    
    FOR1:   
            CALL   Sort
            ADD    DI, 2
            LOOP   FOR1

            CALL   CRLF
            MOV    DX, OFFSET string_4            ;'After Sort the num is:'
            MOV    AH, 9
            INT    21H

            MOV    CX, 10
            MOV    DI, 0
    FOR2:   
            CALL   Print
            CALL   Space
            ADD    DI , 2
            LOOP   FOR2
            CALL   CRLF
    ;-------求和输出---------------------
            MOV    DX, OFFSET massege             ;
            MOV    AH, 9
            INT    21H

            CALL   Get_sum
            MOV    DI, 0
            CALL   Print


    EXIT:   
            MOV    AH, 4CH
            INT    21H


    ;/************子程序调用****************/


    ;---------输入函数（单数字输入）------------
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
    L_CRLF:                                       ; 以换行作为一个数的结束标志
            MOV    DX, 0
            MOV    DATA[SI], BX                   ;
            POP    DX
            POP    CX
            POP    BX
            POP    AX
            RET
Input ENDP


    ;----换行子函数（一个数输入完毕）-------
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
    ;---------空格-----------
Space PROC Near
            push   AX
            push   DX
            MOV    DX, OFFSET string_5            ;' '
            MOV    AH, 9
            INT    21H
            pop    DX
            pop    AX
            RET
Space ENDP
    ;----------错误提示-------------
ERROR PROC Near
            push   BX
            push   DX
            MOV    DX, OFFSET string_2            ; ERROR: OVERFLOW! Please input again:
            MOV    AH, 9
            INT    21H
            pop    DX
            pop    BX
            RET
ERROR ENDP

    ;---------输出函数（单数字输出）-------------
Print PROC Near
            PUSH   AX
            PUSH   BX
            PUSH   CX
            PUSH   DX

            MOV    CX, 0
            MOV    BX, 10
            MOV    AX, DATA[DI]
    LAST:   
            MOV    DX, 0
            DIV    BX                             ; DIV商放AX，余数放入DX
            PUSH   DX
            INC    CX
            CMP    AX, 0
            JNZ    LAST
    AGE:    
            POP    DX
            OR     DX, 30H
            MOV    AH, 2
            INT    21H
            LOOP   AGE
            POP    DX
            POP    CX
            POP    BX
            POP    AX
            RET
Print ENDP

    ;---------SORT---------------------
SORT PROC NEAR
            PUSH   BX
            PUSH   DX
            MOV    SI,DI
    LOOP1:  
            ADD    SI,2
            MOV    BX,DATA[DI]
            CMP    BX,DATA[SI]
            JA     CHANGE
            JMP    NEXT
    CHANGE: 
            MOV    DX,DATA[SI]
            MOV    DATA[DI],DX
            MOV    DATA[SI],BX
    NEXT:   
            CMP    SI,18
            JL     LOOP1
            POP    DX
            POP    BX
            RET
SORT ENDP
    ;-------SUM-------------
Get_sum PROC NEAR
            PUSH   BX
            PUSH   CX

            MOV    BX, 0
            MOV    CX , 9
            MOV    DI, 2
    LOP1:   
            MOV    BX, DATA[0]
            ADD    BX, DATA[DI]
            MOV    DATA[0], BX
            ADD    DI , 2
            LOOP   LOP1
            POP    CX
            POP    BX
            RET
Get_sum ENDP

CODES ENDS
    END START
