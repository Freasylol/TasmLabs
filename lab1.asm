.model small
.stack 100h
.data
	errorMessage db 'Error! Please enter num$'
	a dw ?
	b dw ?
	c dw ?
	d dw ?
.code
main:
	mov ax, @data	
	mov ds, ax
    call readNum
	mov a, bx 
	call readNum
	mov b, bx
	call readNum
	mov c, bx
	call readNum
	mov d, bx

	;a*c
	mov ax ,a
	mul c
	mov cx, ax

	;b-d
	mov bx, b
	sub bx, d
	mov dx, bx

	;(a * с) == (b - d)) or (a < d)
	cmp cx, dx
	je true
	mov ax, a
	mov bx, d
	cmp ax, bx
	jl true
	jmp false 	
	true:
		;a+b
		mov ax, a
		add ax, b
		mov cx, ax

		;c-d
		mov ax, c
		sub ax, d

		mul cx

		call print
	true2:
		;a * a - b + c
		mov ax, a
		mul a
		sub ax, b
		add ax, c

		call print
	false: 
		;b + c
		mov ax, b
		add ax, c
		mov cx, ax

		;a - d
		mov ax, a
		sub ax, d
		mov dx, ax

		;(b + c) > (a - d)) and (a > b)
		cmp cx, dx
		jg checkCond
		jmp false2
	checkCond: 
		;a > b
		mov ax, a
		mov bx, b
		cmp ax, bx
		jg true2
	false2:
		;3 * c
		mov ax, c
		mul c
		mul c
		mov cx, ax

		;2 * d + 8
		mov ax, d
		mov dx, 2
		mul dx
		add ax, 8

		add ax, cx

		call print
	
print:
    call printNum
exit:
    mov ah, 04Ch
    mov al, 0
    int 21h
read:
	call readNum
readNum:
	mov bx, 0
    mov ah, 01h
    int 21h
    cmp al, 2dh
	je negative
	call analyzeSymb
	ret
negative:
	call nextPos
	not bx 
	inc bx
	ret
nextPos:
    mov ah, 01h
    int 21h
analyzeSymb:
    cmp al, 0dh
    je endl
    cmp al, 10
    je endl
	cmp al, 57
	jnl error
	cmp al, 44
	jng error
	cmp al, 2eh
	je error
	cmp al, 2fh
	je error
    sub al, 48
    mov ah, 0
	push ax
	mov ax, 10
    mul bx
    mov bx, ax
	pop ax
    add bx, ax
    call nextPos
endl:
	ret
printNum:
	cmp ax, 0
	jz printZero
	jnl printPositive
	mov dl, '-'
	push ax
	mov ah, 02h
	int 21h
	pop ax
	not ax 
	inc ax
printPositive:
	cmp ax, 0
	jz endFunc
	mov dx, 0
	mov bx, 10
	div bx    
	add dl, 48
	push dx
	call printPositive
	pop dx
	push ax
	mov ah, 02h
	int 21h
	pop ax
endFunc:
	ret
printZero:
	mov dl, 30h
	mov ah, 02h
	int 21h
	ret
error:
	mov ax, @data
    mov ds, ax

	mov dx, 0ch
	mov ah, 01h
	int 21h

	lea dx, errorMessage
    mov ah, 09h
    int 21h
	call exit
end main