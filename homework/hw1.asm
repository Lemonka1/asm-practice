section .data
    msg db "Hello World!",0xA   ; строка + перевод строки
    len equ $ - msg             ; довжина строки

section .text
    global _start

_start:
    ; write(1, msg, len)
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; дескриптор stdout
    mov rsi, msg        ; адреса строки
    mov rdx, len        ; длина строки
    syscall

    ; exit(0)
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; код завершення = 0
    syscall
