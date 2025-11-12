bits 64
section .data
arr     db 5, 3, 8, 1, 4
len     equ $ - arr
msg     db "Sorted array: ",0
newline db 10,0

section .bss
sorted  resb len

section .text
global _start

_start:
    lea rsi, [rel arr]
    lea rdi, [rel sorted]
    mov rcx, len
    mov rbx, 1
    call sort_array

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel msg]
    mov rdx, 15
    syscall

    lea rsi, [rel sorted]
    mov rcx, len
print_loop:
    mov al, [rsi]
    add al, '0'
    mov [rsi], al
    inc rsi
    loop print_loop

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel sorted]
    mov rdx, len
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel newline]
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

sort_array:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov rdx, rcx
copy_loop:
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rdx
    jnz copy_loop

    lea rsi, [rel sorted]
    mov rcx, len
outer_loop:
    mov rdi, rsi
    mov rdx, len
    dec rdx
inner_loop:
    mov al, [rdi]
    mov bl, [rdi+1]
    cmp al, bl
    jbe no_swap
    mov [rdi], bl
    mov [rdi+1], al
no_swap:
    inc rdi
    dec rdx
    jnz inner_loop
    loop outer_loop

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret
