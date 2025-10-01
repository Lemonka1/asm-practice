section .data
    msg_prime       db " is prime", 10
    msg_prime_len   equ $-msg_prime
    msg_not_prime   db " is not prime", 10
    msg_not_prime_len equ $-msg_not_prime

section .bss
    num_str resb 20

section .text
global _start

_start:
    ; Вхідне число
    mov rax, 17             ; <- змінити число тут
    mov rbx, rax            ; збережемо для обробки та виводу

    ; Вивід числа
    mov rsi, num_str
    call print_number

    ; Перевірка на простоту
    mov rax, rbx
    call is_prime
    cmp rax, 1
    je .prime

.not_prime:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel msg_not_prime]
    mov rdx, msg_not_prime_len
    syscall
    jmp .exit

.prime:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel msg_prime]
    mov rdx, msg_prime_len
    syscall

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

;------------------------
; Підпрограма виводу числа в консоль
print_number:
    push rbx
    mov rcx, 0          ; лічильник цифр
    mov rdi, rsi
    add rdi, 19
    mov byte [rdi], 0
    dec rdi

    mov rbx, rax
    cmp rbx, 0
    jne .convert_loop
    mov byte [rdi], '0'
    inc rcx
    jmp .print_digits

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

.print_digits:
    inc rdi
    mov rax, 1
    mov rsi, rdi
    mov rdx, rcx
    mov rdi, 1
    syscall
    pop rbx
    ret

;------------------------
; Підпрограма перевірки простоти
; Вхід: rax = число
; Вихід: rax = 1 якщо просте, 0 якщо ні
is_prime:
    push rbx
    cmp rax, 2
    jl .not_prime_flag
    je .prime_flag

    mov rbx, 2

.loop_check:
    mov rdx, 0
    mov rcx, rax
    div rbx
    test rdx, rdx
    je .not_prime_flag
    inc rbx
    cmp rbx, rcx
    jl .loop_check

.prime_flag:
    mov rax, 1
    pop rbx
    ret

.not_prime_flag:
    mov rax, 0
    pop rbx
    ret
