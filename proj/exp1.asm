ORG 100H

JMP START

    ; ==============================
    ; 数据段定义：用于实验内容1：1325 + 9839
    ; 注意：低位在前，高位在后，便于从个位开始相加
    ; 1325 存为 '5','2','3','1'
    ; 9839 存为 '9','3','8','9'
    ; ==============================
    DATA1 DB '5','2','3','1'
    DATA2 DB '9','3','8','9'
    RESULT TIMES 5 DB 0

    MSG1 DB 0DH,0AH,'1325 + 9839 = $'

    ; ==============================
    ; 数据段定义：用于实验内容2：判断正数、零、负数
    ; ==============================
    NUMS DB 5,-4,0,3,100,-51

    ; 用于字符串输出
    MSG2 DB 0DH,0AH,0DH,0AH,'SIGN JUDGE RESULT:',0DH,0AH,'$'
    MSG_POS DB 'Y=+1',0DH,0AH,'$'
    MSG_ZERO DB 'Y=0',0DH,0AH,'$'
    MSG_NEG DB 'Y=-1',0DH,0AH,'$'

START:
    PUSH CS
    POP DS

    ; ==============================
    ; 实验内容1：ASCII码加法
    ; ==============================

    MOV DX, MSG1
    MOV AH, 09H
    INT 21H

    MOV SI, DATA1             ; SI指向第一个加数
    MOV DI, DATA2             ; DI指向第二个加数
    MOV BX, RESULT            ; BX指向结果缓冲区
    MOV CX, 4                 ; 共4位

    CLC                       ; 清除进位标志CF

ADD_LOOP:
    PUSHF                     ; 保存上一位产生的进位CF
    MOV AL, [SI]              ; 取DATA1中的一位ASCII码
    SUB AL, 30H               ; ASCII码转为数字

    MOV DL, [DI]              ; 取DATA2中的一位ASCII码
    SUB DL, 30H               ; ASCII码转为数字

    POPF                      ; 恢复CF，供当前位ADC使用
    ADC AL, DL                ; 当前位相加，同时加上进位CF
    AAA                       ; 非压缩BCD加法调整，个位放在AL，进位放AH

    PUSHF                     ; 保存AAA调整后的CF
    OR AL, 30H                ; 数字转回ASCII码
    MOV [BX], AL              ; 保存当前位结果
    POPF                      ; 恢复CF，供下一位ADC使用

    INC SI                    ; SI DI BX自增指向下一位
    INC DI
    INC BX

    LOOP ADD_LOOP

    JNC NO_LAST_CARRY         ; 若最高位无进位，则不补'1'

    MOV BYTE [BX], '1'        ; 最高位有进位，补最高位字符'1'
    INC BX

NO_LAST_CARRY:
    DEC BX                    ; BX指向结果最高有效位

PRINT_SUM:
    MOV DL, [BX]              ; 逆序输出结果
    MOV AH, 02H
    INT 21H

    CMP BX, RESULT
    JE ADD_DONE

    DEC BX
    JMP PRINT_SUM

ADD_DONE:

    ; ==============================
    ; 实验内容2：判断每个数 >0、=0、<0
    ; ==============================

    MOV DX, MSG2
    MOV AH, 09H
    INT 21H

    MOV SI, NUMS              ; SI指向数据表首地址
    MOV CX, 6                 ; 共有6个数据

JUDGE_LOOP:
    MOV AL, [SI]              ; 取一个有符号的字节数据
    CMP AL, 0                 ; 与0比较

    JZ IS_ZERO                ; 等于0，转到IS_ZERO
    JS IS_NEG                 ; 符号位为1，说明小于0，则跳到IS_NEG

IS_POS:
    PUSH CX
    MOV DX, MSG_POS
    MOV AH, 09H
    INT 21H
    POP CX
    JMP NEXT_NUM

IS_ZERO:
    PUSH CX
    MOV DX, MSG_ZERO
    MOV AH, 09H
    INT 21H
    POP CX
    JMP NEXT_NUM

IS_NEG:
    PUSH CX
    MOV DX, MSG_NEG
    MOV AH, 09H
    INT 21H
    POP CX

NEXT_NUM:
    INC SI                    ; 指向下一个数据
    LOOP JUDGE_LOOP           ; CX减1，若CX不为0则继续循环

    MOV AH, 4CH               ; 返回DOS
    INT 21H



IS_POS:
    PRINT_STR MSG_POS
    JMP NEXT_NUM

IS_ZERO:
    PRINT_STR MSG_ZERO
    JMP NEXT_NUM

IS_NEG:
    PRINT_STR MSG_NEG

