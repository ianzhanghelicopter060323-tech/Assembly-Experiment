; proj_03.asm - DOS .COM format
org 100h          ; .COM file starting address (fixed)

; ========== Data Segment ==========
section .data
    ; Define data here

; ========== Code Segment ==========
section .text
start:
    ; Program entry point
    MOV AX, 1680H   ;
    
    ; Program exit
    MOV AH, 4Ch    ; DOS exit function
    MOV AL, 0      ; Return code (optional)
    INT 21h        ; Call DOS interrupt

