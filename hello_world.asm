section .data
    hello_message db 'Hello, World!', 0x0A ; The string to print, 0x0A is newline

section .text
    global _start ; The entry point for the program

_start:
    ; Write our string to stdout
    mov rax, 1                  ; The syscall number for sys_write
    mov rdi, 1                  ; File descriptor 1 is stdout
    mov rsi, hello_message      ; Address of the string to output
    mov rdx, 13                 ; The number of bytes to write
    syscall                     ; Invoke the kernel

    ; Exit the program
    mov rax, 60                 ; The syscall number for sys_exit
    xor rdi, rdi                ; Exit code 0
    syscall                     ; Invoke the kernel
