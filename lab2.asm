.model small
.stack 100h
.data
	errorMessage db 'Error! Please enter num$'
	n dw ?
.code
main:
	mov ax, @data
	mov ds, ax

    call readNum
	mov n, bx
	mov bx, n

	mov cx, 1
	cmp cx, n
	jnle print
cycle:
	mov ax, 0
	mov ax, cx
	mul cx
	cmp ax, bx
	jnle print
	inc cx
	call cycle
print:
	mov ax, cx
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