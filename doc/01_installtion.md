
# 01 Development Environment Setup

## Development Environment Introduction

This project uses two important development tools: DOSBox and NASM.

DOSBox (DOSBox Emulator) is an open-source DOS emulator software based on the x86 architecture, released under the GNU General Public License (GPL). DOSBox supports various operating systems including UNIX-like systems (Linux, macOS, FreeBSD, etc.), Windows, and MS-DOS. It can simulate DOS environments and DOS applications on modern operating systems, and is widely used for running classic DOS games, learning 8086 assembly language, and running legacy software. It is an outstanding representative of cross-platform DOS compatibility solutions.

NASM (Netwide Assembler) is an open-source assembler and disassembler software based on the x86 architecture, released under the Simplified BSD License. Also known as The Netwide Assembler, it supports various operating systems including UNIX-like systems, Windows, and MS-DOS, and is widely regarded as one of the most popular assembly tools on the Linux platform.

Installation instructions:

```bash
sudo apt-get install dosbox

sudo apt-get install nasm
```



## First Program

### Writing Code

Create a `proj_01.asm` file in the project root directory and write the following code:

``` asm
; proj_01.asm - Addition with output
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
```



### Running

``` bash
# Clear cache
clear
rm -f proj_01.o proj_01

# Compile using nasm
nasm -f elf64 proj_01.asm -o proj_01.o

# Link using gcc
gcc -no-pie proj_01.o -o proj_01

# Run
./test

# Check result
echo $?  # Should display 8
```



### Output Example

![8bbc494f7d698cb2fa121125eba1c10d](./assets/doc01_001.png)
