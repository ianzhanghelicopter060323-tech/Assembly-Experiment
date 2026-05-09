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