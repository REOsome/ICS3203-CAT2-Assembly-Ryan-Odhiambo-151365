# Assembly Programs Repository

This repository contains assembly language programs written in NASM for x86 architecture.

## Contents
1. **Code**:
   - `code/Q3.asm`: Computes the factorial of a number.
   - `code/Q2.asm`: Reverses an array in place.
   - `code/Q1.asm`: Classifies a number as positive, negative, or zero.
   - `code/Q4.asm`: Simulates a control system for a water level sensor.

2. **Documentation**:
   - `docs/Q3.md`: Documentation for the factorial program.
   - `docs/Q2.md`: Documentation for the reverse array program.
   - `docs/Q1.md`: Documentation for the classify number program.
   - `docs/Q4.md`: Documentation for the control program.

## Usage
1. Clone the repository:
   ```bash
   git clone <repository_url>
2. Navigate to the code folder to view the assembly programs.
3. Refer to the docs folder for detailed documentation on each program.

Compilation and Execution
Q1:
## Instructions to Compile and Run
1. Save the program as `Q1.asm`.
2. Compile using NASM:
   ```bash
   nasm -f elf32 Q1.asm -o Q1.o
3. Link using ld:
   ```bash
   ld -m elf_i386 Q1.o -o Q1
4. Run:
   ```bash
   ./Q1

Q2:
## Instructions to Compile and Run
1. Save the program as `Q2.asm`.
2. Compile using NASM:
   ```bash
   nasm -f elf32 Q2.asm -o Q2.o
3. Link using ld:
   ```bash
   ld -m elf_i386 Q2.o -o Q2
4. Run:
   ```bash
   ./Q2

Q3:
## Instructions to Compile and Run
1. Save the program as `Q3.asm`.
2. Compile using NASM:
   ```bash
   nasm -f elf32 Q3.asm -o Q3.o
3. Link using ld:
   ```bash
   ld -m elf_i386 Q3.o -o Q3
4. Run:
   ```bash
   ./Q3

Q4:
## Instructions to Compile and Run
1. Save the program as `Q4.asm`.
2. Compile using NASM:
   ```bash
   nasm -f elf32 Q4.asm -o Q4.o
3. Link using ld:
   ```bash
   ld -m elf_i386 Q4.o -o Q4
4. Run:
   ```bash
   ./Q4

Challenges faced in the program for Q1:
Correctly handling signed integers during comparison.
Ensuring the program handles edge cases like very large or small numbers.

Challenges faced in the program for Q3:
Recursive Functionality:
Handling recursive calls required careful management of the stack to ensure the program doesn’t overwrite critical values.
