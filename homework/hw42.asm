section .data
    N_NUM       dq 10      
    MSG_INPUT   db 'Vhidne chyslo: '
    LEN_INPUT   equ $ - MSG_INPUT
    MSG_RESULT  db 'Factorial: '
    LEN_RESULT  equ $ - MSG_RESULT
    NL          db 0Ah     

section .bss
    BUF_NUM     resb 21 

section .text
    global _start

_start:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, MSG_INPUT
    mov     rdx, LEN_INPUT
    syscall

    mov     rax, [N_NUM]
    call    print_number
    call    newline

    mov     rax, [N_NUM]
    call    factorial_rec

    push    rax

    mov     rax, 1
    mov     rdi, 1
    mov     rsi, MSG_RESULT
    mov     rdx, LEN_RESULT
    syscall

    pop     rax
    call    print_number
    call    newline

    mov     rax, 60
    xor     rdi, rdi
    syscall

factorial_rec:
    cmp     rax, 1
    jle     .base
    push    rax
    dec     rax
    call    factorial_rec
    pop     rbx
    mul     rbx
    ret

.base:
    mov     rax, 1
    xor     rdx, rdx
    ret

print_number:
    push    rax
    push    rcx
    push    rdx
    push    rsi

    mov     rcx, 10
    mov     rsi, BUF_NUM + 20
    cmp     rax, 0
    jne     .conv
    dec     rsi
    mov     byte [rsi], '0'
    jmp     .out

.conv:
    xor     rdx, rdx
    div     rcx
    add     dl, '0'
    dec     rsi
    mov     [rsi], dl
    test    rax, rax
    jnz     .conv

.out:
    mov     rdx, BUF_NUM + 20
    sub     rdx, rsi
    mov     rax, 1
    mov     rdi, 1
    syscall

    pop     rsi
    pop     rdx
    pop     rcx
    pop     rax
    ret

newline:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, NL
    mov     rdx, 1
    syscall
    ret
