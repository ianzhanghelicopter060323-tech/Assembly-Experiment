# For Assembly Experiment of ZJUT
## Notification

This repository is origined from```https://github.com/sxw-123456/assembly-learning.git``` by *XinWen Suo*

## Project Introduction

This project is developed by students from Zhejiang University of Technology to assist in learning the "Microcomputer Principles" course. It provides a complete DOS 8086 assembly language learning environment, including development tool configuration, program examples, debugging tutorials, and more.

**Reference Textbook:**
- 《新编16/32位微型计算机原理及应用》（第5版，李继灿主编）
- New Edition of 16/32-bit Microcomputer Principles and Applications (5th Edition, edited by Li Jican)

## Features

- 📚 **Complete Tutorial System**: A comprehensive learning path from environment setup to program debugging
- 🛠️ **Practical Tool Configuration**: Setup guide for DOSBox + NASM development environment
- 💡 **Rich Example Code**: Covers COM format programs, register operations, debugging techniques, and more
- 🔍 **Detailed Debugging Tutorials**: Using DEBUG tool to observe program execution
- 📖 **Bilingual Documentation**: Facilitates international communication while maintaining clarity

## Quick Start

### Requirements

- Linux/macOS/Windows operating system
- DOSBox (DOS emulator)
- NASM (Netwide Assembler)

### Installation

1. **Install DOSBox and NASM**

   ```bash
   # Ubuntu/Debian
   sudo apt-get install dosbox nasm
   
   # macOS (using Homebrew)
   brew install dosbox nasm
   ```

2. **Clone the Repository**

   ```bash
   git clone <repository-url>
   cd assembly
   ```

3. **View Documentation**

   For detailed environment configuration and tutorials, please refer to the documents in the `doc/` directory:
   - `doc/01_installtion.md` - Development environment setup
   - `doc/02_DOS_COM.md` - DOS .COM format introduction
   - `doc/03_DOSBox.md` - DOSBox usage tutorial

### First Program

```bash
# Compile the example program
nasm -f bin proj/proj_03.asm -o proj_03.com

# Start DOSBox
dosbox

# Execute in DOSBox
mount c ~/Desktop/assembly
c:
proj_03.com
```

## 实验三代码逐行解释

以下说明对应 `proj/proj_03.asm` 当前版本。空行只用于分隔代码结构，不单独说明。

| 行号 | 代码 | 说明 |
|------|------|------|
| 1 | `ORG 100H` | 指定 `.COM` 程序装入后的起始偏移地址为 `100H`，这是 DOS `.COM` 程序的固定入口位置。 |
| 3 | `JMP START` | 跳过前面的数据区和说明注释，直接转到 `START` 标签开始执行程序。 |
| 5 | `; ==============================` | 注释分隔线，用来划分程序说明区域。 |
| 6 | `; 实验三：DOS中断调用实验` | 注释，说明本程序对应实验三。 |
| 7 | `; 功能：` | 注释，提示下面列出程序主要功能。 |
| 8 | `;   1. 显示提示信息：INPUTSTRING,THE END FLAG IS $` | 注释，说明程序启动后先显示输入提示。 |
| 9 | `;   2. 循环接收键盘字符` | 注释，说明程序会反复等待用户键盘输入。 |
| 10 | `;   3. 遇到'$'结束程序` | 注释，说明 `$` 是输入结束标志。 |
| 11 | `;   4. 输入'0'到'9'时，数字计数器加1，并显示当前计数` | 注释，说明数字字符的处理方法。 |
| 12 | `;   5. 输入非数字字符时，原样显示该字符，但不计数` | 注释，说明非数字字符的处理方法。 |
| 13 | `; ==============================` | 注释分隔线，表示程序说明区域结束。 |
| 15 | `PROMPT  DB 'INPUTSTRING,THE END FLAG IS ', '$'` | 定义提示字符串。最后的 `$` 是 DOS `09H` 字符串输出功能的结束标志，不会被 `09H` 自动显示。 |
| 16 | `CRLF    DB 0DH, 0AH, '$'` | 定义回车换行字符串，`0DH` 是回车，`0AH` 是换行，最后 `$` 作为字符串结束标志。 |
| 17 | `COUNT   DW 0` | 定义 16 位计数器，初值为 0，用来统计已经输入的数字字符个数。 |
| 19 | `START:` | 程序入口标签，`JMP START` 会跳转到这里开始执行。 |
| 20 | `; .COM程序中CS=DS，保险起见仍显式设置DS` | 注释，说明下面两条指令用于初始化数据段寄存器。 |
| 21 | `PUSH CS` | 将代码段寄存器 `CS` 的值压入堆栈。 |
| 22 | `POP DS` | 从堆栈弹出刚才的 `CS` 值到 `DS`，使 `DS` 指向当前程序段，方便访问数据。 |
| 24 | `; DOS 09H功能用'$'作为字符串结束标志，不能直接输出提示中的'$'` | 注释，解释为什么提示中的 `$` 要单独输出。 |
| 25 | `MOV DX, PROMPT` | 将提示字符串 `PROMPT` 的偏移地址送入 `DX`，作为字符串输出的入口参数。 |
| 26 | `CALL PRINT_STRING` | 调用字符串输出子程序，显示 `INPUTSTRING,THE END FLAG IS `。 |
| 27 | `MOV DL, '$'` | 将字符 `$` 的 ASCII 码送入 `DL`，准备单独输出 `$`。 |
| 28 | `CALL PRINT_CHAR` | 调用字符输出子程序，显示 `$`。 |
| 29 | `MOV DX, CRLF` | 将回车换行字符串地址送入 `DX`。 |
| 30 | `CALL PRINT_STRING` | 调用字符串输出子程序，使光标换到下一行。 |
| 32 | `READ_LOOP:` | 输入循环标签，后续每处理完一个字符都会跳回这里继续读取。 |
| 33 | `; AH=08H：从键盘读入一个字符，不自动回显` | 注释，说明 DOS `21H` 中断的 `08H` 功能。 |
| 34 | `MOV AH, 08H` | 设置 DOS 中断功能号为 `08H`，表示从标准输入读取一个字符且不自动显示。 |
| 35 | `INT 21H` | 调用 DOS 中断，读取的字符返回在 `AL` 中。 |
| 37 | `; '$'为结束标志，输入该字符时退出程序` | 注释，说明下面判断结束符。 |
| 38 | `CMP AL, '$'` | 比较输入字符是否为 `$`。 |
| 39 | `JE EXIT_PROGRAM` | 如果等于 `$`，跳转到 `EXIT_PROGRAM` 结束程序。 |
| 41 | `; 判断输入字符是否小于'0'` | 注释，说明下面判断是否小于数字字符范围。 |
| 42 | `CMP AL, '0'` | 将输入字符与字符 `0` 比较。 |
| 43 | `JB NOT_DIGIT` | 如果输入字符的 ASCII 码小于 `0`，说明不是数字，跳转到 `NOT_DIGIT`。 |
| 45 | `; 判断输入字符是否大于'9'` | 注释，说明下面判断是否大于数字字符范围。 |
| 46 | `CMP AL, '9'` | 将输入字符与字符 `9` 比较。 |
| 47 | `JA NOT_DIGIT` | 如果输入字符的 ASCII 码大于 `9`，说明不是数字，跳转到 `NOT_DIGIT`。 |
| 49 | `IS_DIGIT:` | 数字字符处理标签。能执行到这里，说明输入字符在 `0` 到 `9` 之间。 |
| 50 | `; 是数字字符：计数器加1，并显示当前计数值` | 注释，说明数字字符分支的功能。 |
| 51 | `INC WORD [COUNT]` | 将计数器 `COUNT` 加 1。 |
| 52 | `MOV AX, [COUNT]` | 将当前计数值送入 `AX`，作为十进制输出子程序的入口参数。 |
| 53 | `CALL PRINT_DECIMAL` | 调用十进制输出子程序，显示当前数字字符累计个数。 |
| 55 | `; 输出空格，避免连续计数值挤在一起` | 注释，说明输出空格的目的。 |
| 56 | `MOV DL, ' '` | 将空格字符送入 `DL`。 |
| 57 | `CALL PRINT_CHAR` | 调用字符输出子程序，显示空格。 |
| 58 | `JMP READ_LOOP` | 当前字符处理完毕，跳回输入循环继续读取下一个字符。 |
| 60 | `NOT_DIGIT:` | 非数字字符处理标签。 |
| 61 | `; 若输入回车，则输出回车换行，便于观察结果` | 注释，说明对回车键进行特殊处理。 |
| 62 | `CMP AL, 0DH` | 判断输入字符是否为回车，回车的 ASCII 码为 `0DH`。 |
| 63 | `JE PRINT_ENTER` | 如果是回车，跳转到 `PRINT_ENTER` 输出回车换行。 |
| 65 | `; 非数字字符：原样显示，不改变计数器` | 注释，说明普通非数字字符的处理方式。 |
| 66 | `MOV DL, AL` | 将输入字符从 `AL` 送入 `DL`，作为字符输出参数。 |
| 67 | `CALL PRINT_CHAR` | 调用字符输出子程序，原样显示该非数字字符。 |
| 68 | `JMP READ_LOOP` | 处理完非数字字符后，继续读取下一个字符。 |
| 70 | `PRINT_ENTER:` | 回车处理标签。 |
| 71 | `MOV DX, CRLF` | 将回车换行字符串地址送入 `DX`。 |
| 72 | `CALL PRINT_STRING` | 调用字符串输出子程序，完成换行显示。 |
| 73 | `JMP READ_LOOP` | 换行后继续读取下一个字符。 |
| 75 | `EXIT_PROGRAM:` | 程序退出标签。 |
| 76 | `; AH=4CH：返回DOS` | 注释，说明下面使用 DOS 的程序结束功能。 |
| 77 | `MOV AH, 4CH` | 设置 DOS `21H` 中断功能号为 `4CH`，表示终止程序并返回 DOS。 |
| 78 | `MOV AL, 00H` | 设置程序返回码为 `00H`，表示正常结束。 |
| 79 | `INT 21H` | 调用 DOS 中断，结束程序。 |
| 81 | `; ==============================` | 注释分隔线，用来划分字符串输出子程序。 |
| 82 | `; 子程序：输出以'$'结尾的字符串` | 注释，说明 `PRINT_STRING` 的功能。 |
| 83 | `; 入口：DS:DX 指向字符串` | 注释，说明调用该子程序前需要将字符串地址放入 `DS:DX`。 |
| 84 | `; ==============================` | 注释分隔线。 |
| 85 | `PRINT_STRING:` | 字符串输出子程序入口标签。 |
| 86 | `MOV AH, 09H` | 设置 DOS `21H` 中断功能号为 `09H`，用于输出以 `$` 结尾的字符串。 |
| 87 | `INT 21H` | 调用 DOS 中断，显示 `DS:DX` 指向的字符串。 |
| 88 | `RET` | 子程序返回，回到调用 `PRINT_STRING` 的下一条指令。 |
| 90 | `; ==============================` | 注释分隔线，用来划分字符输出子程序。 |
| 91 | `; 子程序：输出单个字符` | 注释，说明 `PRINT_CHAR` 的功能。 |
| 92 | `; 入口：DL = 待输出字符的ASCII码` | 注释，说明调用前需要把字符 ASCII 码放入 `DL`。 |
| 93 | `; ==============================` | 注释分隔线。 |
| 94 | `PRINT_CHAR:` | 字符输出子程序入口标签。 |
| 95 | `MOV AH, 02H` | 设置 DOS `21H` 中断功能号为 `02H`，用于输出 `DL` 中的单个字符。 |
| 96 | `INT 21H` | 调用 DOS 中断，显示 `DL` 中的字符。 |
| 97 | `RET` | 子程序返回，回到调用 `PRINT_CHAR` 的下一条指令。 |
| 99 | `; ==============================` | 注释分隔线，用来划分十进制输出子程序。 |
| 100 | `; 子程序：输出AX中的无符号十进制数` | 注释，说明 `PRINT_DECIMAL` 用来输出 `AX` 中的数值。 |
| 101 | `; 入口：AX = 待输出数值` | 注释，说明调用前需要将待显示数值放入 `AX`。 |
| 102 | `; 思路：反复除以10，将余数压栈，再逆序弹出显示` | 注释，说明十进制转换算法。 |
| 103 | `; ==============================` | 注释分隔线。 |
| 104 | `PRINT_DECIMAL:` | 十进制输出子程序入口标签。 |
| 105 | `MOV BX, 10` | 将除数 10 放入 `BX`，用于把二进制数转换成十进制各位。 |
| 106 | `XOR CX, CX` | 将 `CX` 清零，`CX` 用来统计压入堆栈的数字位数。 |
| 108 | `DIV_LOOP:` | 除法循环标签。 |
| 109 | `XOR DX, DX` | 将 `DX` 清零，因为 `DIV BX` 使用 `DX:AX` 作为被除数。 |
| 110 | `DIV BX` | 用 `DX:AX` 除以 10，商保存在 `AX`，余数保存在 `DX`。 |
| 111 | `PUSH DX` | 将余数压入堆栈。余数就是当前最低位十进制数字。 |
| 112 | `INC CX` | 数字位数加 1。 |
| 113 | `CMP AX, 0` | 判断商是否为 0。 |
| 114 | `JNE DIV_LOOP` | 如果商不为 0，继续除以 10，提取下一位数字。 |
| 116 | `PRINT_DIGIT_LOOP:` | 数字显示循环标签。 |
| 117 | `POP DX` | 从堆栈弹出一个余数。由于堆栈后进先出，所以可以从高位到低位显示。 |
| 118 | `ADD DL, '0'` | 将 0 到 9 的数值转换成对应 ASCII 数字字符。 |
| 119 | `CALL PRINT_CHAR` | 调用字符输出子程序，显示当前十进制数字字符。 |
| 120 | `LOOP PRINT_DIGIT_LOOP` | `CX` 减 1，如果还没有显示完所有数字位，则继续循环。 |
| 121 | `RET` | 十进制输出子程序返回。 |

## Project Structure

```
assembly/
├── backup/          # Important file backups
│   └── DEBUG.zip
├── doc/             # Documentation directory
│   ├── 01_installtion.md    # Development environment setup
│   ├── 02_DOS_COM.md        # DOS .COM format
│   ├── 03_DOSBox.md         # DOSBox usage tutorial
│   └── assets/              # Documentation resources (images, etc.)
├── proj/            # Project code directory
│   ├── proj_03.asm  # Example program
│   └── test.asm     # Test program
├── kernel-master/   # FreeDOS kernel source code (reference)
└── README.md        # This file
```

## License

This project is licensed under the **MIT License**.

This project is open source and **not for commercial use**. If you encounter any issues, please leave feedback on GitHub, including but not limited to:

1. Bug reports
2. Development suggestions
3. Other content related to this project or microcomputer principles

## Language Note

To facilitate international communication and provide better support for systems like Linux that may not natively support Chinese, this project uses a bilingual approach:
- **Code Comments**: English
- **Documentation**: Bilingual (Chinese and English), primarily in Chinese
- **README**: English version

## AI Usage Statement

The code and documentation of this project are primarily developed/written by humans with AI assistance, and AI is used for document polishing when necessary.

## Contributing

Welcome to submit Issues and Pull Requests! Before submitting, please ensure:

1. Code follows project standards
2. Documentation uses bilingual format (Chinese and English)
3. Code comments are in English

## Contact

For questions or suggestions, please contact us through GitHub Issues.
