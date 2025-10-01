section .data
    msg_prime       db " - це просте число", 10
    len_msg_prime   equ $-msg_prime
    msg_not_prime   db " - це не просте число", 10
    len_msg_not_prime equ $-msg_not_prime

section .bss
    num_str resb 20

section .text
global _start

_start:
    mov ax, 17       ; Число для перевірки
    movzx rbx, ax    ; Розширення до 64-біт

    mov rax, rbx
    mov rsi, num_str
    call print_number

    mov rax, rbx
    call is_prime
    cmp rax, 1
    je .is_prime_label

.is_not_prime_label:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_not_prime
    mov rdx, len_msg_not_prime
    syscall
    jmp .exit_program

.is_prime_label:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_prime
    mov rdx, len_msg_prime
    syscall

.exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall

print_number:
    push rbx
    push rcx
    push rdx
    
    mov rdi, rsi
    add rdi, 19
    mov byte [rdi], 0
    dec rdi

    mov rbx, rax
    mov rcx, 0

    cmp rbx, 0
    jne .convert_loop
    mov byte [rdi], '0'
    inc rcx
    jmp .do_print

.convert_loop:
    xor rdx, rdx
    mov rax, rbx
    mov r8, 10
    div r8
    add dl, '0'
    mov [rdi], dl
    dec rdi
    inc rcx
    mov rbx, rax
    test rbx, rbx
    jnz .convert_loop

.do_print:
    inc rdi
    mov rax, 1
    mov rsi, rdi
    mov rdx, rcx
    mov rdi, 1
    syscall
    
    pop rdx
    pop rcx
    pop rbx
    ret

is_prime:
    push rbx
    push rcx
    push rdx
    
    cmp rax, 2
    jl .not_prime ; Числа < 2 не прості
    cmp rax, 3
    jle .prime    ; 2 і 3 - прості

    test al, 1    ; Перевірка на парність (якщо > 3)
    jz .not_prime ; Парні числа > 2 не прості

    mov rbx, rax  ; Число для перевірки
    mov rcx, 3    ; Починаємо ділити з 3

.check_loop:
    mov rax, rcx
    mul rcx           ; rcx * rcx
    cmp rax, rbx      ; Якщо дільник^2 > число, то число просте
    jg .prime

    mov rax, rbx      ; Завантажуємо число для ділення
    xor rdx, rdx      ; Очищаємо rdx для залишку
    div rcx           ; Ділення на rcx
    test rdx, rdx     ; Перевірка залишку
    jz .not_prime     ; Якщо залишок 0, то число не просте

    add rcx, 2        ; Збільшуємо дільник на 2 (перевіряємо тільки непарні)
    jmp .check_loop

.prime:
    mov rax, 1        ; Повертаємо 1 (просте)
    jmp .done

.not_prime:
    mov rax, 0        ; Повертаємо 0 (не просте)

.done:
    pop rdx
    pop rcx
    pop rbx
    ret
