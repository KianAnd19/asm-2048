section .text
global draw_pixel

; This function expects:
; - `color` in AL (the color to set)
; - `x` in SI (the x coordinate)
; - `y` in DI (the y coordinate)
; - `pixels` in RDI (the pointer to the pixel buffer)
; Assumes 32-bit color depth and a window width of 800 pixels.
draw_pixel:
    push rbx             ; Save RBX register on the stack
    mov rbx, rdi         ; Move pixels pointer into RBX
    imul rdi, rdi, 800   ; Calculate row offset
    add rdi, rsi         ; Add column offset
    shl rdi, 2           ; Multiply by 4 for 32-bit color depth
    add rbx, rdi         ; Add offset to pixels pointer
    mov [rbx], al        ; Set the pixel
    pop rbx              ; Restore RBX register
    ret
