ORG 100H

; 做加法
MOV AL, 3
ADD AL, 5

; 将加法变成字符串输出
ADD AL, '0'
MOV DL, AL  ; 放在DL待输出
MOV AH, 02H ; 02H表示输出一个字符
INT 21H

MOV AH, 4CH
INT 21H