section .data
msg db "******************************",10
    db "*  *                      *  *",10
    db "*    *                  *    *",10
    db "*      *              *      *",10
    db "*        *          *        *",10
    db "*          *      *          *",10
    db "*            *  *            *",10
    db "*             **             *",10
    db "*           *    *           *",10
    db "*         *        *         *",10
    db "*       *            *       *",10
    db "*     *                *     *",10
    db "*   *                    *   *",10
    db "* *                        * *",10
    db "******************************",10,0

section .text
global _start

_start:
    mov rsi, msg
.next:
    lodsb              ; зчитати наступний байт у AL
    cmp al, 0
    je .done
    mov rax, 1         ; sys_write
    mov rdi, 1         ; stdout
    mov rdx, 1
    syscall
    jmp .next

.done:
    mov rax, 60        ; sys_exit
    xor rdi, rdi
    syscall

