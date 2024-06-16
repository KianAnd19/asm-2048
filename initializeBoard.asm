extern getRandomNumber  ; Assuming you have a C function to get a random number

section .data
    GRID_SIZE equ 4
    ELEMENT_SIZE equ 4

section .text
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

    mov r12, 0
.new_piece:
; new block here
    push rdi
    mov edi, GRID_SIZE
    
    call getRandomNumber
    mov ebx, eax

    call getRandomNumber
    mov edx, eax
    pop rdi

    mov rax, rbx ; rax = row index
    imul rax, GRID_SIZE ; rax = row index * GRID_SIZE
    add rax, rdx ; rax = row index * GRID_SIZE + column index
    imul rax, ELEMENT_SIZE ; rax = (row index * GRID_SIZE + column index) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[random_row][random_column]

    ; Check if the random position is empty
    cmp dword [rax], 0
    jne .new_piece ; if it isnt empty try again

    mov dword [rax], 2

    mov rax, 1
    inc r12
    cmp r12, 1
    jle .new_piece

.done:
    ret
