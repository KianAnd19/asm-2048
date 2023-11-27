section .data
    GRID_SIZE equ 4

section .text
extern getRandomNumber  ; Assuming you have a C function to get a random number
global initializeBoard
initializeBoard:
    ; rdi = address of the board

    ; Zero out the board
    mov rcx, GRID_SIZE * GRID_SIZE  ; Total number of cells
    mov rax, rdi                    ; Pointer to the board
    .loop:
        mov dword [rax], 0          ; Set the current cell to 0
        add rax, 4                  ; Move to the next cell
        loop .loop


    ;Add two '2's to random positions
    mov rax, 0  ; Set rax to 0
    imul rax, GRID_SIZE
    add rax, rcx
    imul rax, 4
    add rax, rdi ; Two iterations
    mov dword [rax], 2  ; Set the random position to 2

    mov rax, 2  ; Set rax to 0
    imul rax, GRID_SIZE
    add rax, 3
    imul rax, 4
    add rax, rdi ; Two iterations
    mov dword [rax], 2  ; Set the random position to 2



    ; Add two '2's to random positions
    ; mov rcx, 2  ; Two iterations
    ; .addTwo:
    ;     ; Get a random row and column
    ;     push rcx  ; Save rcx on the stack
    ;     mov edi, GRID_SIZE  ; Set max value for random number
    ;     call getRandomNumber  ; Get random row
    ;     mov ebx, eax  ; Store random row in ebx
    ;     call getRandomNumber  ; Get random column
    ;     mov ecx, eax  ; Store random column in ecx
    ;     pop rcx  ; Restore rcx

    ;     ; Calculate the address of the random position
    ;     mov rax, rbx
    ;     imul rax, GRID_SIZE
    ;     add rax, rcx
    ;     imul rax, 4
    ;     add rax, rdi
    ;     mov dword [rax], 2  ; Set the random position to 2


    ;     loop .addTwo

    ret
