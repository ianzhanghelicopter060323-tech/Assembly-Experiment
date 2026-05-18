ORG 100H

JMP START

; ==============================
; 实验三：DOS中断调用实验
; 功能：
;   1. 显示提示信息：INPUTSTRING,THE END FLAG IS $
;   2. 循环接收键盘字符
;   3. 遇到'$'结束程序
;   4. 输入'0'到'9'时，数字计数器加1，并显示当前计数
;   5. 输入非数字字符时，原样显示该字符，但不计数
; ==============================

PROMPT  DB 'INPUTSTRING,THE END FLAG IS ', '$'
CRLF    DB 0DH, 0AH, '$'
COUNT   DW 0

START:
    ; .COM程序中CS=DS，保险起见仍显式设置DS
    PUSH CS
    POP DS

    ; DOS 09H功能用'$'作为字符串结束标志，不能直接输出提示中的'$'
    MOV DX, PROMPT
    CALL PRINT_STRING
    MOV DL, '$'
    CALL PRINT_CHAR
    MOV DX, CRLF
    CALL PRINT_STRING

READ_LOOP:
    ; AH=08H：从键盘读入一个字符，不自动回显
    MOV AH, 08H
    INT 21H

    ; '$'为结束标志，输入该字符时退出程序
    CMP AL, '$'
    JE EXIT_PROGRAM

    ; 判断输入字符是否小于'0'
    CMP AL, '0'
    JB NOT_DIGIT

    ; 判断输入字符是否大于'9'
    CMP AL, '9'
    JA NOT_DIGIT

IS_DIGIT:
    ; 是数字字符：计数器加1，并显示当前计数值
    INC WORD [COUNT]
    MOV AX, [COUNT]
    CALL PRINT_DECIMAL

    ; 输出空格，避免连续计数值挤在一起
    MOV DL, ' '
    CALL PRINT_CHAR
    JMP READ_LOOP

NOT_DIGIT:
    ; 若输入回车，则输出回车换行，便于观察结果
    CMP AL, 0DH
    JE PRINT_ENTER

    ; 非数字字符：原样显示，不改变计数器
    MOV DL, AL
    CALL PRINT_CHAR
    JMP READ_LOOP

PRINT_ENTER:
    MOV DX, CRLF
    CALL PRINT_STRING
    JMP READ_LOOP

EXIT_PROGRAM:
    ; AH=4CH：返回DOS
    MOV AH, 4CH
    MOV AL, 00H
    INT 21H

; ==============================
; 子程序：输出以'$'结尾的字符串
; 入口：DS:DX 指向字符串
; ==============================
PRINT_STRING:
    MOV AH, 09H
    INT 21H
    RET

; ==============================
; 子程序：输出单个字符
; 入口：DL = 待输出字符的ASCII码
; ==============================
PRINT_CHAR:
    MOV AH, 02H
    INT 21H
    RET

; ==============================
; 子程序：输出AX中的无符号十进制数
; 入口：AX = 待输出数值
; 思路：反复除以10，将余数压栈，再逆序弹出显示
; ==============================
PRINT_DECIMAL:
    MOV BX, 10
    XOR CX, CX

DIV_LOOP:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE DIV_LOOP

PRINT_DIGIT_LOOP:
    POP DX
    ADD DL, '0'
    CALL PRINT_CHAR
    LOOP PRINT_DIGIT_LOOP
    RET
