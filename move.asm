extern getRandomNumber

section .data
    GRID_SIZE equ 4
    ELEMENT_SIZE equ 4 ; Assuming each element in the board is a 32-bit integer

section .text
global move
move:
    cmp esi, 0
    je .right

    cmp esi, 1
    je .left

    cmp esi, 2
    je .down

    cmp esi, 3
    je .up

    ret


.up:
    jmp .new_piece


.right:
    jmp .new_piece


.left:
    mov ecx, GRID_SIZE ; Loop counter for columns
    mov r13, 0 ; current column

.column_loop:
    mov r12, 0 ; current row

.row_loop:
    mov rax, r12 ; rax = row
    imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    add rax, r13 ; rax = row * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[row][column]
    mov ebx, dword [rax] ; ebx = board[row][column] (32-bit value)

    cmp ebx, 0
    je .next_row

    mov r14, r13 ; r14 = current position

    cmp r14, 0
    je .next_row

    dec r14 ; Start from j-1

.shift_loop:
    cmp r14, 0
    jl .update_position

    mov rax, r12 ; rax = row
    imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    add rax, r14 ; rax = row * GRID_SIZE + current position
    imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + current position) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[row][current position]

    cmp dword [rax], 0
    jne .update_position

    dec r14
    jmp .shift_loop

.update_position:
    ; mov rax, r12 ; rax = row
    ; imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    ; add rax, r14 ; rax = row * GRID_SIZE + k
    ; imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + k) * ELEMENT_SIZE
    ; add rax, rdi ; rax = address of board[row][k]
    ; mov dword [rax], r10d ; board[row][k] = board[row][column]

    inc r14 ; k += 1
    
    mov rax, r12 ; rax = row
    imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    add rax, r13 ; rax = row * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[row][column]
    mov dword [rax], 0 ; board[row][column] = 0

    mov rax, r12 ; rax = row
    imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    add rax, r14 ; rax = row * GRID_SIZE + k
    imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + k) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[row][k]
    mov dword [rax], ebx ; board[row][k] = board[row][column]


.next_row:
    inc r12
    cmp r12, GRID_SIZE
    jl .row_loop

    inc r13
    cmp r13, GRID_SIZE
    jl .column_loop

    jmp .new_piece

.down:
    jmp .new_piece

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
    jne .done


.done:
    ret