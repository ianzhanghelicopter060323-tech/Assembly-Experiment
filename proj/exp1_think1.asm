ORG 100H

JMP START

    ; ==============================
    ; 数据段定义：用于实验内容1：键盘输入两个4位数
    ; 注意：输入时从高位到低位输入，保存时低位在前
    ; 例如输入1325，则存为 '5','2','3','1'
    ; ==============================
    DATA1 TIMES 4 DB 0
    DATA2 TIMES 4 DB 0
    RESULT TIMES 5 DB 0

    MSG_IN1 DB 0DH,0AH,'INPUT FIRST  4-DIGIT NUMBER: $'
    MSG_IN2 DB 0DH,0AH,'INPUT SECOND 4-DIGIT NUMBER: $'
    MSG1 DB 0DH,0AH,'SUM RESULT = $'

    ; ==============================
    ; 数据段定义：用于实验内容2：键盘输入6个有符号数
    ; ==============================
    NUMS TIMES 6 DB 0

    ; 用于字符串输出
    MSG_IN_NUM DB 0DH,0AH,'INPUT SIGNED NUMBER: $'
    MSG2 DB 0DH,0AH,0DH,0AH,'SIGN JUDGE RESULT:',0DH,0AH,'$'
    MSG_POS DB 'Y=+1',0DH,0AH,'$'
    MSG_ZERO DB 'Y=0',0DH,0AH,'$'
    MSG_NEG DB 'Y=-1',0DH,0AH,'$'

    TEN DB 10

START:
    PUSH CS
    POP DS

    ; ==============================
    ; 实验内容1：键盘输入ASCII码加数
    ; ==============================

    MOV DX, MSG_IN1
    MOV AH, 09H
    INT 21H

    MOV DI, DATA1 + 3         ; DI指向第一个加数最高位保存位置
    CALL READ_4_DIGITS

    MOV DX, MSG_IN2
    MOV AH, 09H
    INT 21H

    MOV DI, DATA2 + 3         ; DI指向第二个加数最高位保存位置
    CALL READ_4_DIGITS

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
    ; 实验内容2：键盘输入数据并判断 >0、=0、<0
    ; ==============================

    MOV DI, NUMS              ; DI指向数据表首地址
    MOV CX, 6                 ; 共有6个数据

INPUT_NUM_LOOP:
    PUSH CX

    MOV DX, MSG_IN_NUM
    MOV AH, 09H
    INT 21H

    CALL READ_SIGNED_NUM      ; 从键盘输入一个有符号数，结果保存在AL
    MOV [DI], AL
    INC DI

    POP CX
    LOOP INPUT_NUM_LOOP

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

; ==============================
; 子程序：读取4个数字字符，并按低位在前保存
; 入口：DI 指向保存区最后一个字节
; ==============================
READ_4_DIGITS:
    MOV CX, 4                 ; 读取4个数字

READ_DIGIT_LOOP:
    MOV AH, 01H               ; 从键盘输入一个字符并显示
    INT 21H

    CMP AL, '0'
    JB READ_DIGIT_LOOP
    CMP AL, '9'
    JA READ_DIGIT_LOOP

    MOV [DI], AL              ; 保存当前输入数字
    DEC DI                    ; 由高位向低位保存，形成低位在前
    LOOP READ_DIGIT_LOOP

WAIT_ENTER:
    MOV AH, 01H               ; 等待回车，结束本次输入
    INT 21H
    CMP AL, 0DH
    JNE WAIT_ENTER

    RET

; ==============================
; 子程序：读取一个有符号十进制数
; 出口：AL 保存输入结果
; ==============================
READ_SIGNED_NUM:
    XOR BL, BL                ; BL保存数值大小
    XOR BH, BH                ; BH为0表示正数，为1表示负数

READ_NUM_CHAR:
    MOV AH, 01H               ; 从键盘输入一个字符并显示
    INT 21H

    CMP AL, 0DH
    JE READ_NUM_DONE

    CMP AL, '-'
    JNE CHECK_NUM_DIGIT

    MOV BH, 1                 ; 记录负号
    JMP READ_NUM_CHAR

CHECK_NUM_DIGIT:
    CMP AL, '0'
    JB READ_NUM_CHAR
    CMP AL, '9'
    JA READ_NUM_CHAR

    SUB AL, 30H               ; ASCII码转为数字
    MOV DL, AL                ; DL保存当前位数字

    MOV AL, BL                ; 原数值乘以10
    MUL BYTE [TEN]
    ADD AL, DL                ; 加上当前位数字
    MOV BL, AL

    JMP READ_NUM_CHAR

READ_NUM_DONE:
    MOV AL, BL
    CMP BH, 0
    JE READ_NUM_RET

    NEG AL                    ; 若输入负号，则转换为补码形式

READ_NUM_RET:
    RET
