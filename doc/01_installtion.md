
# 01 开发环境配置

## 开发环境简介

本项目中采用DOSBox和NASM两个重要开发工具。

DOSBox（DOSBox Emulator）是一款基于x86架构的开源DOS模拟器软件，采用GNU通用公共许可证（GPL）发布。其外文名为DOSBox，支持类UNIX系统（Linux、macOS、FreeBSD等）、Windows、MS-DOS等多种操作系统，能够在现代操作系统上模拟运行DOS环境和DOS应用程序，被广泛用于运行经典DOS游戏、学习8086汇编语言以及运行历史遗留软件，是跨平台DOS兼容性解决方案的杰出代表。

NASM（Netwide Assembler）是一款基于x86架构的开源汇编与反汇编软件，采用简化版BSD许可证发布。其外文名为Netwide Assembler，别名The Netwide Assembler，支持类UNIX系统、Windows、MS-DOS等多种操作系统，被广泛视为Linux平台最受欢迎的汇编工具之一。

安装方式如下：

```bash
sudo apt-get install dosbox

sudo apt-get install nasm
```



## 第一个程序

### 编写代码

在项目根目录中创建`proj_01.asm`文件，并编写下述代码:

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



### 运行

``` bash
# 清空缓存
clear
rm -f proj_01.o proj_01

# 使用nasm编译
nasm -f elf64 proj_01.asm -o proj_01.o

# 使用gcc链接
gcc -no-pie proj_01.o -o proj_01

# 运行
./test

# 查看结果
echo $?  # 应该显示 8
```



### 输出结果示例

![8bbc494f7d698cb2fa121125eba1c10d](./assets/doc01_001.png)
