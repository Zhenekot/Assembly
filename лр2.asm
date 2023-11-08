masm
model small

.data
LEN = 5
numberOne db LEN + 1 dup(?)
numberTwo db LEN + 1 dup(?)
numberSum db LEN + 2 dup(?)
IndMax dw ?
mes1 db 'Error!$'
mes2 db 'Number One:$'
mes3 db 'Number Two:$'
mes4 db 'Summa:$'
newLine db 10, 13, '$'
flag db 0
;flazhok db 0
.stack 256

.code
.486

inputNumber proc; в регистре bx хранится эфективный адресс bcd числа
;в нулевом индексе регистра bx записывается кол-во введеных символов

	xor cx, cx
	mov cl, LEN
	mov si, 1
	mov ah, 1
m1:
	int 21h
	cmp al, 13
	je exit

	sub al, 30h
	mov [bx][si], al
	inc si
	inc [bx]

loop m1
	exit:
	cmp [bx], 0 
	jne exit1
	mov flag, 1
	
	mov ah, 9
	lea dx, newLine
	lea dx, mes1
	int 21h
	exit1:
	ret

inputNumber endp

outputNumber proc ;в регистре bx хранится эфективный адресс bcd числа
;в нулевом индексе регистра bx записывается кол-во введеных символов

	mov si, 1
	xor cx, cx
	mov cl, [bx]
	mov ah, 2
m2:
	mov dl, [bx][si]
	inc si
	add dl, 30h
	int 21h
loop m2
	ret
outputNumber endp

Reverse proc
	
	xor cx, cx
	xor ax, ax
	mov al, bx[0]
	mov dl, 2
	div dl
	mov cl, al
	mov si, 1 
	xor ax, ax
	mov al, [bx]
	mov di, ax 
	
ReverseCycle:
	mov al, bx[si]
	mov ah, bx[di]
	mov bx[si], ah
	mov bx[di], al
	inc si
	dec di
loop ReverseCycle
	ret
Reverse endp

main:
	mov ax, @data
	mov ds, ax

	xor di, di

	lea bx, numberOne
	call inputNumber
	call Reverse
	
	cmp flag, 1 
	je endd
	
	mov ah, 9
	lea dx, newLine
	int 21h
	
	lea bx, numberTwo
	call inputNumber
	call Reverse

	cmp flag, 1 
	je endd
	
	xor cx, cx
	xor ax, ax
	
	
	mov al, numberOne[0]
	mov bl, numberTwo[0]
	cmp al, bl
	ja first
	mov cl, bl
	jmp next
	first:
	mov cl, al
	next:
	
	xor ax, ax
	clc
	mov si, 1
	mov bx, 1
m5: 
	mov al, numberOne[si]
	adc al, numberTwo[si]
	aaa
	inc si
	mov numberSum[bx], al
	inc [numberSum]
	inc bx
	mov ax, 0
loop m5
	jnc cf0
	inc numberSum[bx]
	inc [numberSum]
cf0:	

	mov ah, 9
	lea dx, newLine
	int 21h
	
	mov ah, 9
	lea dx, mes2
	int 21h
	
	lea bx, numberOne
	call Reverse
	call outputNumber
	
	mov ah, 9
	lea dx, newLine
	int 21h
	
	mov ah, 9
	lea dx, mes3
	int 21h
	
	lea bx, numberTwo
	call Reverse
	call outputNumber
	
	mov ah, 9
	lea dx, newLine
	int 21h
	
	mov ah, 9
	lea dx, mes4
	int 21h
	
	lea bx, numberSum
	call Reverse
	call outputNumber
	
endd:
	mov ah, 7
	int 21h

	mov ax, 4c00h
	int 21h
end main