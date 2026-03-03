; test.asm - Addition with output
; Calculate 5 + 3 and print result

section .note.GNU-stack noalloc noexec nowrite progbits ; Mark stack as non-executable

section .data
    num1    dq 5          ; First number
    num2    dq 3          ; Second number
    result  dq 0          ; Result storage
    msg     db "5 + 3 = ", 0
    newline db 10         ; Newline character

section .text
    global main

main:
    ; Load numbers and add
    mov rax, [num1]      ; Load 5 into rax
    add rax, [num2]      ; Add 3, result in rax
    mov [result], rax    ; Store result
    
    ; Print message "5 + 3 = "
    mov rax, 1           ; sys_write
    mov rdi, 1           ; stdout
    mov rsi, msg         ; message address
    mov rdx, 7           ; message length
    syscall
    
    ; Convert result to ASCII and print
    ; (This is simplified - result will be exit code)
    mov rdi, [result]    ; Exit with result
    mov rax, 60          ; sys_exit
    syscall