#!/bin/bash

# Compile the NASM code
echo "Compiling NASM code..."
nasm -f elf64 -o move.o move.asm
nasm -f elf64 -o initializeBoard.o initializeBoard.asm

# Check if NASM compilation was successful
if [ $? -ne 0 ]; then
    echo "NASM compilation failed."
    exit 1
fi

# Compile the C code and link with the NASM object file
echo "Compiling C code and linking..."
gcc -o game game.c move.o initializeBoard.o -lSDL2 -lSDL2_ttf

# Check if GCC compilation was successful
if [ $? -ne 0 ]; then
    echo "GCC compilation failed."
    exit 1
fi

# Run the program
echo "Running the program..."
./game

# Cleanup: remove object files and executable
echo "Cleaning up..."
rm move.o initializeBoard.o game 

echo "Done."
