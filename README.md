# asm-2048

`nasm -f elf64 -o move.o move.asm`
`gcc -o myprogram main.c move.o`
`gcc game.c -lSDL2 -lSDL2_ttf -o game`