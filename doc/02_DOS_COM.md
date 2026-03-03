
# 02 DOS .COM Format

## DOS 8086 Assembly Program Structure

For DOS 8086 assembly, the standard structure is typically:
1. Program description (comments)
2. Memory model/mode definition
3. Stack segment definition
4. Data segment definition
5. Code segment definition
   - Program entry point
   - Initialize segment registers
   - Main program logic
   - Program exit
6. Program end marker

Note that .COM format programs are a special form of DOS assembly that simplifies the above structure. All content is in a single segment, and there is no need to explicitly define multiple segments.



## COM Format Introduction

The .COM format is the simplest executable file format in DOS systems, with the full name "Command format". This format has the following characteristics:

**Characteristics of COM Format:**

1. **Fixed Starting Address**: All .COM programs must start execution at offset address 100h (256 bytes). This is because DOS reserves 256 bytes of PSP (Program Segment Prefix) space before the program when loading .COM files.

2. **Single Segment Structure**: .COM programs use only one segment (code, data, and stack are all in the same segment), with a maximum program size limit of 64KB (including 256 bytes of PSP, the actual available space is approximately 65536-256=65280 bytes).

3. **Simple Loading Mechanism**: DOS directly loads the entire file into memory without complex segment relocation. The program entry point is fixed at 100h.

4. **No Linker Required**: .COM files are usually generated directly by the assembler, without a linking step, making the compilation process simpler.

5. **Suitable for Small Programs**: Due to size limitations, the .COM format is suitable for writing simple utility programs, batch helper programs, etc.

**Differences between COM Format and EXE Format:**

| Feature | COM Format | EXE Format |
|---------|------------|------------|
| File Size Limit | ≤64KB | Unlimited |
| Segment Structure | Single segment | Multiple segments (code, data, stack) |
| Starting Address | Fixed 100h | Configurable |
| Compilation Method | Direct assembly | Assembly + linking |
| Complexity | Simple | Complex |
| Use Cases | Small programs | Large programs |

**COM Format Program Structure:**

``` asm
; program_name.asm - DOS .COM format
org 100h          ; .COM file starting address (fixed)

; ========== Data Segment ==========
section .data
    ; Define data here

; ========== Code Segment ==========
section .text
start:
    ; Program entry point
    ; Write your code here
    
    ; Program exit
    MOV AH, 4Ch    ; DOS exit function
    MOV AL, 0      ; Return code (optional)
    INT 21h        ; Call DOS interrupt
```

**Key Points:**

1. **`org 100h` Instruction**: This is the first required instruction for COM format programs, telling the assembler that the program will start execution at offset address 100h. Without this instruction, address references in the program will be incorrect.

2. **Program Entry Point**: The entry point of a COM program is the first executable instruction in the file (after `org 100h`). There is no need to define a `main` or `_start` label like in EXE programs.

3. **Segment Register Initialization**: In COM programs, CS (code segment), DS (data segment), ES (extra segment), and SS (stack segment) all point to the same segment. SP (stack pointer) is initialized to 0FFFEh. Usually, there is no need to manually initialize segment registers.

4. **Program Exit**: Use DOS interrupt 21h function 4Ch to exit the program. This is the standard DOS program exit method.

**Compiling COM Format Programs:**

When compiling COM format programs with NASM, use the `-f bin` format (binary format) and specify the output file extension as `.com`:

```bash
nasm -f bin program.asm -o program.com
```

After compilation, you can directly run the generated .com file in DOSBox.