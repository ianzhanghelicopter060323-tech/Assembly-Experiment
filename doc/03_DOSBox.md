
# DOSBox 使用教程

在本栏目中，我们将尝试为寄存器赋值，并使用debug工具观察赋值结果

## 指令

在程序中添加`MOV AX, 1680H`指令，其作用为，将1680H送入AX寄存器中。

完整代码如下：

``` asm
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
```



## 运行代码

在Linux终端运行下述命令：
``` bash
# 编译代码
nasm -f bin proj_03.asm -o proj_03.com

# 启动DOSBox(可以用另一个终端穿口)
dosbox
```

在DOSBox中运行下述命令：
``` batch
REM 挂载当前工作区为DOS的C盘, 修改为实际路径
mount C ~/Desktop/assembly

REM 切换文件目录
C:

REM 执行代码
proj_03.com
```

说明：
1. `#`是bash命令的注释，`REM`是dos命令的标准注释命令

2. 该汇编代码本身并没有显示的输出，因此，在执行后控制台并无明显的反馈。


## DOS Debug工具

为了便于调试汇编命令，我们需要dos的debug工具，读者可以从网络平台下载DOS工具，例如：

https://github.com/FDOS/kernel?tab=readme-ov-file FreeDOS

为了方便读者使用，我们在项目的根目录提供了一个调试器，路径为：`debug.exe`，如果不小心删除，也可以解压`backup/DEBUG.zip`文件，并将副本重新放入根目录。


常用的DEBUG语句如下：

#TODO 下述改为表格
常用DEBUG命令
q - 退出 DEBUG（quit）
r - 显示所有寄存器（register）
r ax - 显示特定寄存器（如 AX）
u - 反汇编代码（unassemble）
u 100 - 从地址 100h 开始反汇编
t - 单步执行一条指令（trace）
p - 执行一条指令（proceed，跳过 INT 调用）
g - 运行程序到结束（go）
g 105 - 运行到地址 105h 停止（设置断点）
d - 显示内存内容（dump）
d 100 - 从地址 100h 显示内存


要想debug代码，可以在DOSBox中运行下述命令：

```
REM 采用debug模式执行代码
debug proj_03.com

REM 从地址100h开始反汇编
u 100

REM 单步执行一条命令
t
```

运行效果如下图，可以观察到，`AX`寄存器值为`1680H`，是我们通过`MOV`命令设置的值
![8bbc494f7d698cb2fa121125eba1c10d](./assets/doc01_001.png)