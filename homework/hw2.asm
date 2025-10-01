section .data
    buffer db 20 dup(0)       ; буфер для рядка

section .text
    global _start

; ---------------------------
; int2str:
;  Вхід:  eax = число
;         esi = адреса буфера
;  Вихід: у буфері — рядок з ASCII-цифрами
; ---------------------------
int2str:
    mov ebx, 10           ; дільник (система числення)
    mov edi, esi          ; збережемо адресу буфера
    add edi, 19           ; рухаємося з кінця буфера
    mov byte [edi], 0     ; нуль-термінатор

.convert_loop:
    xor edx, edx          ; обнуляємо залишок
    div ebx               ; ділимо EAX на 10 → EAX=частка, EDX=залишок
    add dl, '0'           ; цифру у ASCII
    dec edi
    mov [edi], dl         ; зберігаємо у буфері
    test eax, eax
    jnz .convert_loop     ; поки ще є цифри

    mov esi, edi          ; на виході ESI → початок рядка
    ret

; ---------------------------
; main
; ---------------------------
_start:
    mov eax, 1234567
    mov esi, buffer
    call int2str

    ; вивести результат
    mov eax, 4            ; sys_write
    mov ebx, 1            ; stdout
    mov ecx, esi          ; вказівник на рядок
    mov edx, 20           ; довжина буфера
    int 0x80

    ; завершення
    mov eax, 1
    xor ebx, ebx
    int 0x80
