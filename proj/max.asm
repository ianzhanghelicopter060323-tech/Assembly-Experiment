ORG 100H

MOV SI, DATA ; SI指向数组起始地址
MOV AL, [SI] ; [SI]：数组第一个元素；AL: 最大值
MOV CX, 19   ; 循环次数19次

NEXT:
    INC SI   ; SI自增
    CMP AL, [SI]
    JA KEEP ; JA: Jump if Above(如果AL > [SI]则跳到KEEP) 
    MOV AL, [SI] ; AL , [SI]则让AL=[SI]

KEEP:
    LOOP NEXT

PUSH AX         ; 中断前，为保证AL不变，先入栈
MOV DX, msg     ; msg = 'Max='
MOV AH, 09H
INT 21H
POP AX

CALL print_al_decimal

MOV AH, 4CH
INT 21H

; =================================================
; 子程序：print_al_decimal
; 功能：把 AL 中的无符号数按十进制输出
; 输入：AL = 0 ~ 255
; 输出：屏幕显示十进制数字
; 破坏：AX, BX, CX, DX
; =================================================
print_al_decimal:
    mov ah, 0        ; AX = AL，保证 AX 是 0~255

    mov bl, 100
    div bl           ; AL = 百位，AH = 余数

    mov cl, al       ; CL 保存百位
    mov al, ah       ; AL = 余数

    mov ah, 0        ; AX = 余数
    mov bl, 10
    div bl           ; AL = 十位，AH = 个位

    mov ch, al       ; CH 保存十位
    mov bh, ah       ; BH 保存个位

    ; 判断是否需要输出百位
    cmp cl, 0
    je check_tens

    mov dl, cl
    add dl, '0'
    mov ah, 02h
    int 21h

    ; 如果输出过百位，那么十位即使是 0 也要输出
    mov dl, ch
    add dl, '0'
    mov ah, 02h
    int 21h

    jmp print_ones

check_tens:
    ; 如果没有百位，再判断十位是否为 0
    cmp ch, 0
    je print_ones

    mov dl, ch
    add dl, '0'
    mov ah, 02h
    int 21h

print_ones:
    mov dl, bh
    add dl, '0'
    mov ah, 02h
    int 21h

    ret


; -------------------------
; 数据区
; -------------------------
msg db 'Max = $'

DATA DB 12, 34, 9, 88, 76, 45, 23, 91, 3, 17
     DB 66, 52, 11, 29, 100, 7, 80, 43, 21, 55
