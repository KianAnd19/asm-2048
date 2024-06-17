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
    mov ecx, GRID_SIZE ; Loop counter for rows
    mov r12, 0 ; current row

.row_loop_up:
    mov r13, 0 ; current column

.column_loop_up:
    mov rax, r12 ; rax = row
    imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    add rax, r13 ; rax = row * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[row][column]
    mov ebx, dword [rax] ; ebx = board[row][column] (32-bit value)

    cmp ebx, 0
    je .next_column_up

    mov r14, r12 ; r14 = current position
    cmp r14, 0
    je .next_column_up

    dec r14 ; Start from i-1

.shift_loop_up:
    cmp r14, 0
    jl .update_position_up

    mov rax, r14 ; rax = current position
    imul rax, GRID_SIZE ; rax = current position * GRID_SIZE
    add rax, r13 ; rax = current position * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (current position * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[current position][column]

    cmp dword [rax], 0
    jne .update_position_up

    dec r14
    jmp .shift_loop_up

.update_position_up:
    inc r14 ; k += 1

    mov rax, r12 ; rax = row
    imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    add rax, r13 ; rax = row * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[row][column]
    mov dword [rax], 0 ; board[row][column] = 0

    mov rax, r14 ; rax = k
    imul rax, GRID_SIZE ; rax = k * GRID_SIZE
    add rax, r13 ; rax = k * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (k * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[k][column]
    mov dword [rax], ebx ; board[k][column] = board[row][column]

    ; check to merge
    dec r14
    mov r15, r14 ; rax = k
    imul r15, GRID_SIZE ; rax = k * GRID_SIZE
    add r15, r13 ; rax = k * GRID_SIZE + column
    imul r15, ELEMENT_SIZE ; rax = (k * GRID_SIZE + column) * ELEMENT_SIZE
    add r15, rdi ; rax = address of board[k][column]
    cmp dword [r15], ebx
    jne .next_column_up
    imul ebx, 2
    mov dword [r15], ebx
    mov dword [rax], 0

.next_column_up:
    inc r13
    cmp r13, GRID_SIZE
    jl .column_loop_up

    inc r12
    cmp r12, GRID_SIZE
    jl .row_loop_up

    jmp .new_piece


.right:
    mov ecx, GRID_SIZE ; Loop counter for columns
    mov r13, GRID_SIZE - 1 ; current column (starting from the rightmost column)

.column_loop_right:
    mov r12, 0 ; current row

.row_loop_right:
    mov rax, r12 ; rax = row
    imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    add rax, r13 ; rax = row * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[row][column]
    mov ebx, dword [rax] ; ebx = board[row][column] (32-bit value)

    cmp ebx, 0
    je .next_row_right

    mov r14, r13 ; r14 = current position
    cmp r14, GRID_SIZE - 1
    je .next_row_right

    inc r14 ; Start from j+1

.shift_loop_right:
    cmp r14, GRID_SIZE - 1
    jg .update_position_right

    mov rax, r12 ; rax = row
    imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    add rax, r14 ; rax = row * GRID_SIZE + current position
    imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + current position) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[row][current position]

    cmp dword [rax], 0
    jne .update_position_right

    inc r14
    jmp .shift_loop_right

.update_position_right:
    dec r14 ; k -= 1

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

    ; check to merge
    inc r14
    mov r15, r12 ; rax = row
    imul r15, GRID_SIZE ; rax = row * GRID_SIZE
    add r15, r14 ; rax = row * GRID_SIZE + k
    imul r15, ELEMENT_SIZE ; rax = (row * GRID_SIZE + k) * ELEMENT_SIZE
    add r15, rdi ; rax = address of board[row][k]
    cmp dword [r15], ebx
    jne .next_row_right
    imul ebx, 2
    mov dword [r15], ebx
    mov dword [rax], 0

.next_row_right:
    inc r12
    cmp r12, GRID_SIZE
    jl .row_loop_right

    dec r13
    cmp r13, 0
    jge .column_loop_right

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

;check to merge
    dec r14
    mov r15, r12 ; rax = row
    imul r15, GRID_SIZE ; rax = row * GRID_SIZE
    add r15, r14 ; rax = row * GRID_SIZE + k
    imul r15, ELEMENT_SIZE ; rax = (row * GRID_SIZE + k) * ELEMENT_SIZE
    add r15, rdi ; rax = address of board[row][k]

    cmp dword [r15], ebx
    jne .next_row

    imul ebx, 2
    mov dword [r15], ebx
    mov dword [rax], 0


.next_row:
    inc r12
    cmp r12, GRID_SIZE
    jl .row_loop

    inc r13
    cmp r13, GRID_SIZE
    jl .column_loop

    jmp .new_piece

.down:
    mov ecx, GRID_SIZE ; Loop counter for rows
    mov r12, GRID_SIZE - 1 ; current row (starting from the bottom row)

.row_loop_down:
    mov r13, 0 ; current column

.column_loop_down:
    mov rax, r12 ; rax = row
    imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    add rax, r13 ; rax = row * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[row][column]
    mov ebx, dword [rax] ; ebx = board[row][column] (32-bit value)

    cmp ebx, 0
    je .next_column_down

    mov r14, r12 ; r14 = current position
    cmp r14, GRID_SIZE - 1
    je .next_column_down

    inc r14 ; Start from i+1

.shift_loop_down:
    cmp r14, GRID_SIZE - 1
    jg .update_position_down

    mov rax, r14 ; rax = current position
    imul rax, GRID_SIZE ; rax = current position * GRID_SIZE
    add rax, r13 ; rax = current position * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (current position * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[current position][column]

    cmp dword [rax], 0
    jne .update_position_down

    inc r14
    jmp .shift_loop_down

.update_position_down:
    dec r14 ; k -= 1

    mov rax, r12 ; rax = row
    imul rax, GRID_SIZE ; rax = row * GRID_SIZE
    add rax, r13 ; rax = row * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (row * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[row][column]
    mov dword [rax], 0 ; board[row][column] = 0

    mov rax, r14 ; rax = k
    imul rax, GRID_SIZE ; rax = k * GRID_SIZE
    add rax, r13 ; rax = k * GRID_SIZE + column
    imul rax, ELEMENT_SIZE ; rax = (k * GRID_SIZE + column) * ELEMENT_SIZE
    add rax, rdi ; rax = address of board[k][column]
    mov dword [rax], ebx ; board[k][column] = board[row][column]

    ; check to merge
    inc r14
    mov r15, r14 ; rax = k
    imul r15, GRID_SIZE ; rax = k * GRID_SIZE
    add r15, r13 ; rax = k * GRID_SIZE + column
    imul r15, ELEMENT_SIZE ; rax = (k * GRID_SIZE + column) * ELEMENT_SIZE
    add r15, rdi ; rax = address of board[k][column]
    cmp dword [r15], ebx
    jne .next_column_down
    imul ebx, 2
    mov dword [r15], ebx
    mov dword [rax], 0

.next_column_down:
    inc r13
    cmp r13, GRID_SIZE
    jl .column_loop_down

    dec r12
    cmp r12, 0
    jge .row_loop_down

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

    mov rcx, GRID_SIZE * GRID_SIZE  ; Total number of cells
    mov r15, rdi                    ; Pointer to the board
    .loop:
        cmp dword [r15], 0          ; Set the current cell to 0
        je .done
        add r15, 4                  ; Move to the next cell
        loop .loop

    mov rax, 0

.done:
    ret