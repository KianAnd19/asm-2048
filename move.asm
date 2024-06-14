extern getRandomNumber

section .data
    GRID_SIZE equ 4
    ELEMENT_SIZE equ 4 ; Assuming each element in the board is a 32-bit integer

section .text
global move
move:
    ; Parameters: board (rdi), sx (esi), sy (edx), ex (ecx), ey (r8d)

    ; Calculate source offset (sx, sy)
;     mov rax, rsi            ; rax = sx
;     imul rax, GRID_SIZE     ; rax = sx * GRID_SIZE
;     add rax, rdx            ; rax = sx * GRID_SIZE + sy
;     imul rax, ELEMENT_SIZE  ; rax = (sx * GRID_SIZE + sy) * ELEMENT_SIZE
;     add rax, rdi            ; rax = address of board[sx][sy]
;     mov ebx, dword [rax]    ; ebx = board[sx][sy] (32-bit value)
    cmp esi, 0
    je .right

    cmp esi, 1
    je .left

    cmp esi, 2
    je .down

    cmp esi, 3
    je .up




.up:
    jmp .new_piece


.right:
    jmp .new_piece


.left:
    jmp .new_piece


.down:
    jmp .new_piece



;     ; Clear the source position
;     mov dword [rax], 0      ; board[sx][sy] = 0
;     ; Calculate destination offset (ex, ey)
;     ; Calculate destination offset (ex, ey)
;     mov rax, rcx            ; rax = ex
;     imul rax, GRID_SIZE     ; rax = ex * GRID_SIZE
;     mov r9d, r8d            ; Move ey to r9d (32-bit) and zero-extend to r9
;     add rax, r9             ; rax = ex * GRID_SIZE + ey
;     imul rax, ELEMENT_SIZE  ; rax = (ex * GRID_SIZE + ey) * ELEMENT_SIZE
;     add rax, rdi            ; rax = address of board[ex][ey]

;     ; Check if the destination is empty
;     cmp dword [rax], 0      ; Compare board[ex][ey] with 0
;     jne .combine            ; If not equal, jump to .combine



;     ; Update the board at [ex][ey] with the value from [sx][sy]
;     mov dword [rax], ebx    ; board[ex][ey] = board[sx][sy] (32-bit value)

;                   ; rax = 1 (success)
;     jmp .end

; .combine:
;     ; Check if the destination is equal to the source
;     cmp dword [rax], ebx    ; Compare board[ex][ey] with board[sx][sy]
;     jne .end                ; If not equal, jump to .end

;     ; Update the board at [ex][ey] with the value from [sx][sy]
;     mov dword [rax], ebx    ; board[ex][ey] = board[sx][sy] (32-bit value)

;     ; Multiply the value at [ex][ey] by 2
;     shl ebx, 1              ; ebx = board[ex][ey] * 2

;     ; Update the board at [ex][ey] with the new value
;     mov dword [rax], ebx    ; board[ex][ey] = board[ex][ey] * 2

;     ; rax = 1 (success)
;     jmp .end

; .end:

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


















; This should be in nasm
; This should also check if the move is valid
; int move(int board[GRID_SIZE][GRID_SIZE], int sx, int sy, int ex, int ey) {
;     // Check if the start and end points are the same
;     if (ex == sx && ey == sy) return 0;

;     // Move in a straight line (row or column)
;     if (ex - sx != 0 && ey - sy != 0) return 0;

;     // Check if path is clear
;     int stepX = (ex - sx) != 0 ? (ex - sx) / abs(ex - sx) : 0; // 1, -1 or 0
;     int stepY = (ey - sy) != 0 ? (ey - sy) / abs(ey - sy) : 0; // 1, -1 or 0

;     int x, y;
;     for (x = sx + stepX, y = sy + stepY; x != ex || y != ey; x += stepX, y += stepY) {
;         if (board[x][y] != 0) return 0; // Path is not clear
;     }

;     // Check the end cell
;     if (board[ex][ey] != 0 && board[ex][ey] != board[sx][sy]) return 0;

;     // Move or combine
;     if (board[ex][ey] == 0) {
;         board[ex][ey] = board[sx][sy];
;     } else if (board[ex][ey] == board[sx][sy]) {
;         board[ex][ey] *= 2;
;     }

;     board[sx][sy] = 0;

;     // Add a new tile
;     srand(time(NULL)); // Note: Ideally, srand should be called only once at the start of the main function
;     while (1) {
;         int r = rand() % GRID_SIZE;
;         int c = rand() % GRID_SIZE;
;         if (board[r][c] == 0) {
;             board[r][c] = 2;
;             break;
;         }
;     }

;     return 1; // Indicate a successful move
; }
