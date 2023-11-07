#!/bin/bash

# This script assembles and links an assembly program, then runs it.

# Define the source and the output:
SOURCE="hello_world.asm"
OBJECT="hello_world.o"
EXECUTABLE="hello_world"

# Step 1: Assemble the program with NASM
nasm -f elf64 $SOURCE -o $OBJECT

# Check if NASM succeeded
if [ $? -ne 0 ]; then
    echo "Assembly failed."
    exit 1
fi

# Step 2: Link the object file to create an executable
ld $OBJECT -o $EXECUTABLE

# Check if linking succeeded
if [ $? -ne 0 ]; then
    echo "Linking failed."
    exit 1
fi

# Step 3: Run the program
./$EXECUTABLE

# Check if the program ran successfully
if [ $? -ne 0 ]; then
    echo "Program failed to run."
    exit 1
fi

# If the script reaches this point, everything was successful
echo "Execution complete!"
