ORG 100H    ;  汇编器从100h偏移地址开始

MOV DX, MSG ; DX寄存器用于乘除法、中断
MOV AH, 09H ; 表示“显示字符串”
INT 21H     ; 调用21H的中断（用于字符串）

; 表示程序结束，返回DOS
MOV AH, 4CH
INT 21H

MSG DB 'hello world again!$' ; 字符串用$结尾