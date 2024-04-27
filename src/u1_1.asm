STACK SEGMENT	PARA STACK
    STACK_AREA DW  100h DUP(?)     ;initial stack area
    STACK_TOP  EQU $-STACK_AREA    ;the top of stack
STACK ENDS

DATA SEGMENT	PARA
    TABLE_LEN DW 16
    TABLE     DW 200,300,400,10,20,0,1,8
              DW 41H,40,42H,3321h,60,0FFFFH,2,3

    MY_NAME   DB 'My name is 210612_21373191_DuJinyang','$'

    ADD1      DD 20003000H
    ADD2      DD 12345678h
DATA ENDS

CODE SEGMENT
             ASSUME CS:CODE,DS:DATA
             ASSUME SS:STACK

MAIN PROC	FAR
		
    START:   MOV    AX,STACK
             MOV    SS,AX                ;init stack ,because of segment register can't be assigned directly,so we need to use AX as a transfer
             MOV    SP,STACK_TOP
             MOV    AX,DATA
             MOV    DS,AX                ;SET SS,SP,DS

             JMP    START1
             LDS    SI,ADD1              ;LDS is load double word pointer to DS:SI
             LES    DI,ADD2              ;LES is load double word pointer to ES:DI
    ;part below is for jump instruction,which need to set CS:IP
             JMP    short l1             ;JMP is unconditional jump instruction,short is short jump,range is -128~127
             JMP    NEAR ptr  l1
             JMP    FAR ptr   l1         ;short,NEAR,FAR are jump type,FAR is far jump,range is -2^31~2^31-1,NEAR is near jump,range is -32768~32767,short is short jump,range is -128~127
             JMP    BX
             JMP    BX
             JMP    Word PTR  [BX]       ;Word PTR is to specify the size of the operand,Word is 16 bits,DWORD is 32 bits
             JMP    [BX]
             JMP    DWORD PTR [BX]
             JMP    DWORD PTR ADD1
             CALL   BX                   ;CALL is call instruction,which is used to call a function,will push return address into stack,when meet RET instruction,pop return address
             CALL   [BX]
             CALL   WORD PTR [BX]
             CALL   DWORD PTR ADD1
             CALL   ADD1
    l1:      NOP
    START1:  NOP
    ;part below is bubble sort code
    LP1:     MOV    BX,1
             MOV    CX,TABLE_LEN
             DEC    CX
             LEA    SI,TABLE             ;MOV SI,offset Table used to set SI as the offset address of Table,LEA is load effective address
    LP2:     MOV    AX,[SI]
             CMP    AX,[SI+2]
             JBE    CONTINUE
             XCHG   AX,[SI+2]
             MOV    [SI],AX
             MOV    BX,0
    CONTINUE:
             ADD    SI,2
             LOOP   LP2

             CMP    BX,1                 ;BX==1 means no exchange,sort is finished,can exit bubble sort
             JZ     EXIT                 ;JZ is jump if zero,if the result of CMP
             JMP    SHORT   LP1
    EXIT:    MOV    DX,OFFSET MY_NAME
             MOV    AH,9
             INT    21H                  ;display string

             MOV    AX,4C00H
             INT    21H                  ;exit program
MAIN ENDP
CODE ENDS

		END     START               
END
