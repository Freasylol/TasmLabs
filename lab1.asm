.model small
.stack 100h
.data 
	a dw 5
	b dw 2
	c dw 3
	d dw 4
.code

main:
	mov ax, @data
	mov ds, ax 
	
	;a^2
	mov ax ,a
	mul a
	mov cx, ax

	;b*c
	mov bx, b
	mul c
	mov dx, bx

	;a^2 == b*c
	cmp cx, dx
	je true
	jne false 	
	true:
		;c*b
		mov ax, c
		mul b 
		mov cx, ax 

		;d/b
		mov ax, d
		div b
		mov dx, ax

		cmp cx, dx
	true2:
		mov ax, a
		or ax, b
		call print
	false: 
		mov ax, c
		mul a
		sub ax, b
		call print
	false2:
		mov ax, c
		call print
	print:
		call printNum
	exit:
		mov ah, 04Ch
		mov al, 0
		int 21h
	printNum:
		cmp ax, 0
		jz printZero
		jnl printPositive
		mov dl, '-'
		push ax
		mov ah, 02h
		int 21h
		pop ax
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
end main
