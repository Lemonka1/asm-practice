.MODEL small
.STACK 100h
.DATA
msgPrime     db 13,10,'Просте число$'
msgNotPrime  db 13,10,'Не просте число$'

.CODE
main PROC
    mov ax, @data
    mov ds, ax

    mov ax, 29     ; число в AX (можна змінити)

    call IsPrime
    cmp bl, 1      ; Результат IsPrime тепер у BL
    je PRIME
    
    mov ah,9
    lea dx,msgNotPrime
    int 21h
    jmp EXIT

PRIME:
    mov ah,9
    lea dx,msgPrime
    int 21h

EXIT:
    mov ah,4Ch
    int 21h
main ENDP

IsPrime PROC
    push ax        ; Зберігаємо AX (оригінальне число)
    push cx        ; Зберігаємо CX (лічильник)
    push dx        ; Зберігаємо DX (для DIV)

    ; Вхід: AX - число для перевірки
    ; Вихід: BL = 1, якщо просте; BL = 0, якщо не просте

    cmp ax, 2
    jb  NotPrime_SetResult ; Якщо AX < 2, не просте
    cmp ax, 2
    je  Prime_SetResult    ; Якщо AX = 2, просте

    ; Якщо AX > 2, перевіряємо на парність
    test ax, 1             ; Перевірка молодшого біту
    jz  NotPrime_SetResult ; Якщо парне, не просте (оскільки AX > 2)

    ; Перевірка дільників
    mov cx, 3              ; Починаємо дільник з 3
    mov bx, ax             ; Зберігаємо оригінальне число для ділення

CheckLoop:
    ; Перевіряємо доки cx*cx <= bx
    ; Для чисел WORD (до 65535) це безпечно.
    mov ax, cx
    mul cx                 ; AX = CX * CX
    cmp ax, bx             ; Порівнюємо CX*CX з оригінальним числом BX
    ja  Prime_SetResult    ; Якщо CX*CX > BX, число просте

    mov ax, bx             ; Ділене = BX (оригінальне число)
    xor dx, dx             ; Очистити DX для ділення
    div cx                 ; AX = BX / CX, DX = BX % CX
    cmp dx, 0              ; Перевірити залишок
    je  NotPrime_SetResult ; Якщо залишок 0, не просте

    add cx, 2              ; Перейти до наступного непарного дільника
    jmp CheckLoop

Prime_SetResult:
    mov bl, 1              ; Встановити BL = 1 (просте)
    jmp DoneIsPrime

NotPrime_SetResult:
    mov bl, 0              ; Встановити BL = 0 (не просте)

DoneIsPrime:
    pop dx
    pop cx
    pop ax
    ret
IsPrime ENDP

END main
