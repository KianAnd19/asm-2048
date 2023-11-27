section .data
    GRID_SIZE equ 4

section .text
global _move  ; If you're using NASM to compile for a system that uses leading underscores for symbols
; _move:
move:
    ; Parameters: board (rdi), sx (esi), sy (edx), ex (ecx), ey (r8d)
    ; Stack frame setup, etc., depends on your calling convention and system

    ; Check if start and end positions are the same
    cmp esi, ecx  ; Compare sx and ex
    je .end       ; If equal, jump to end
    cmp edx, r8d  ; Compare sy and ey
    je .end       ; If equal, jump to end

    ; ... (Rest of the logic)

.end:
    ; Return from function, stack frame teardown, etc.
    ret
