masm
model small

.stack 256
.data
	mes1 db 'Error$'
	fname db 'MYFILE.txt', 0
	fhandle dw ?
	buff db 4 dup (?)
	output db 4 dup (?)
	counter db 4 dup (?)
	newLine db 10, 13, '$'
	maxEl db 0
	indEl db 0
	znak db 0
	;newL db 13
.code

main:
.386
	mov ax, @data
	mov ds, ax
	
	mov ah, 3ch
	xor cx, cx
	lea dx, fname
	int 21h
	jc error
	mov fhandle, ax
	
	mov ah, 3dh
	xor al, 2
	lea dx, fname
	int 21h
	jc error
	mov fhandle, ax
	
	mov si, 1
	mov cx, 3
	mov ah, 1
input:
	int 21h
	cmp al, 13
	je closeInput
	mov counter[si], al
	inc si
	inc [counter]
loop input
closeInput:

	mov bl, 10
	cmp [counter], 2
	ja three
	jb one	
two:
	mov al, counter[1]
	sub al, 30h
	mul bl
	mov bl, counter[2]
	sub bl, 30h
	add al, bl
	mov cl, al
	jmp next1
three:
	mov al, counter[1]
	sub al, 30h
	mul bl
	mov bh, counter[2]
	sub bh, 30h
	add al, bh
	mul bl
	mov bh, counter[3]
	sub bh, 30h
	add al, bh
	mov cl, al
	jmp next1
one:
	mov cl, counter[1]
	sub cl, 30h
next1:
	push cx

	mov ah, 9
	lea dx, newLine
	int 21h
	
inputNumber:
	push cx
	mov cx, 4
	mov si, 0
	cmd_input_number:
		mov ah, 1
		int 21h
		cmp al, 13
		je enterr
		cmp al, '-'
		jne plus
	   minus:
		mov [buff], '-'
		jmp endInput
	   plus:
		inc si
		;sub al, 30h
		mov buff[si], al
		endInput:
	loop cmd_input_number
enterr:	
	
	cmp [buff], '-'
	je skip_znak
	mov [buff], ' '
	skip_znak:
	
	inc si
	mov cx, 4
	sub cx, si
	cmp cx, 0 
	je skipSpace
		space:
			mov buff[si], 20h
			inc si
		loop space
skipSpace:	
	
	mov ah, 9
	lea dx, newLine
	int 21h
	
	mov ah, 40h
	mov cx, si
	lea dx, buff
	mov bx, fhandle
	int 21h
	jc error
	cmp ax, si
	jne error
	
	xor si, si
	mov cx, 4
	clearbuf:
		mov buff[si], ''
		inc si
	loop clearbuf
	pop cx
loop inputNumber

	mov ah, 42h
	mov al, 0
	mov bx, fhandle
	mov cx, 0
	mov dx, 0
	int 21h
	jc error

	pop cx
	push cx
	xor si, si
outputt:
	push cx
	mov ah, 3fh
	lea dx, buff
	mov bx, fhandle
	mov cx, 4
	int 21h
	jc error
	xor si, si
	output2:
		mov ah, 2
		mov dl, buff[si]
		int 21h
		inc si
	loop output2
	pop cx
loop outputt

	mov ah, 42h
	mov al, 0
	mov bx, fhandle
	mov cx, 0
	mov dx, 0
	int 21h
	jc error

	xor si, si
	pop cx	
	push cx
read:
	push cx
	mov ah, 3fh
	lea dx, buff
	mov bx, fhandle
	mov cx, 4
	int 21h
	jc error
	xor si, si
	mov si, 2
	inc indEl
	mov bl, 10
	mov bh, 0
	xor ax, ax
	mov al, buff[1]
	sub al, 30h
	findCycle:
		cmp si, 4
		je m2
		cmp buff[si], 20h
		je m2
		mul bl
		mov bh, buff[si]
		sub bh, 30h
		add al, bh
		inc si
	loop findCycle
	m2:
	mov ah, indEl
	and ah, 1
	cmp ah, 0
	je m3
	cmp al, maxEl
	jb m3
	mov maxEl, al
	cmp [buff], 2Dh
	jne p1
	mov znak, 2Dh
	jmp m3
	p1:
	mov znak, 20h
	m3:
	pop cx
loop read

	pop cx
	mov bx, cx
	shl bx, 2
	mov ah, 42h
	mov al, 0
	mov bx, fhandle
	mov cx, bx
	mov dx, 4
	int 21h
	jc error

	mov ah, 40h
	lea dx, maxEl
	mov bx, fhandle
	mov cx, 2
	mov ah, 2
	mov dl, maxEl
	int 21h
	
	
	
	;mov ah, 3eh
	;mov bx, fhandle
	;int 21h
	;jc error
	
	;mov ah, 3dh
	;xor al, 2
	;lea dx, fname
	;int 21h
	;jc error
	;mov fhandle, ax
	
	jmp next
error:
	mov ah, 9
	lea dx, mes1
	int 21h
	mov ah, 7
	int 21h
next:
	
	mov ah, 7
	int 21h
	mov ax, 4c00h
	int 21h
end main