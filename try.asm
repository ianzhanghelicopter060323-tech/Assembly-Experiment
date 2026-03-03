; try.asm - DOS .COM format for DOSBox
org 100h          ; .COM文件起始地址

start:
    CLD
    MOV CX, 100
    MOV BX, 0300H
LL: MOV SI, BX
    
    ; Simple loop example
    DEC CX
    JNZ LL
    
    ; Exit to DOS
    MOV AH, 4Ch    ; DOS exit function
    INT 21h        ; Call DOS interrupt