masm
model small

.data
LEN = 50
numberOne db LEN + 1 dup(?)
numberTwo db LEN + 1 dup(?)
numberSum db LEN + 2 dup(?)
IndMax dw ?
mes1 db 'Len:$'
mes2 db 'Number One:$'
mes3 db 'Number Two:$'
mes4 db 'Summa:$'
newLine db 10, 13, '$'
flag db 0
flazhok db 0
.stack 256

.code
.486

inputNumber proc; в регистре bx хранится эфективный адресс bcd числа
;в нулевом индексе регистра bx записывается кол-во введеных символов
	
	mov ah, 9
	lea dx, newLine
	int 21h

	xor cx, cx
	mov cl, LEN
	mov si, cx

	mov ah, 1
m1:
	int 21h
	cmp al, 13
	je exit

	sub al, 30h
	mov [bx][si], al
	dec si
	inc [bx]

loop m1
	exit:
	ret

inputNumber endp

outputNumber proc ;в регистре bx хранится эфективный адресс bcd числа
;в нулевом индексе регистра bx записывается кол-во введеных символов

	cmp [bx], 30h
	je m4

	xor cx, cx
	mov cl, [bx]
	mov si, cx

m2:
	mov ah, 2
	mov dl, [bx][si]
	dec si
	add dl, 30h
	int 21h
loop m2
	m4:
	
		mov ah, 9
		lea dx, newLine
		int 21h
		
		mov ah, 9
		lea dx, mes1
		int 21h

		xor ax, ax

		mov al, [bx]
		aam
		add ax, '00'

		mov dx, ax
		mov ah, 2
		xchg dl, dh
		cmp dl, 30h
		je m3
		int 21h
		m3:
		xchg dl, dh
		int 21h
		
		mov ah, 9
		lea dx, newLine
		int 21h
	ret
outputNumber endp

Reverse proc
	xor ax, ax
	mov al, LEN
	sub al, bx[0]
	mov IndMax, ax
	xor ax, ax
	mov cx, LEN
	mov di, IndMax
	inc di
	
	m7:
	cmp di, cx
	jge ex
	mov si, cx
	mov al, bx[di]
	mov ah, bx[si]
	mov bx[di], ah
	mov bx[si],al
	inc di
	;dec si
loop m7
ex:
	ret
Reverse endp

main:
	mov ax, @data
	mov ds, ax

	xor di, di

	lea bx, numberOne
	call inputNumber
	
	xor ax, ax
	lea bx, numberOne
	call Reverse

	
	lea bx, numberTwo
	call inputNumber
	
	xor ax, ax
	lea bx, numberTwo
	call Reverse

	xor ax, ax
	xor si, si
	mov si, LEN
	mov cx, LEN
m5:
	mov al, numberOne[si]
	adc al, numberTwo[si]
	aaa
	mov numberSum[si], al
	dec si
loop m5
	adc numberSum[si], 0
	xor si, si
	inc si
	mov cx, LEN
m6:
	cmp flazhok, 1
	je k2
	cmp numberSum[si], 0
	je exit2
	k2:
	inc numberSum[0]
	mov flazhok, 1
	exit2:
	inc si
loop m6
	mov ah, 9
	lea dx, newLine
	int 21h
	
	xor ax, ax
	lea bx, numberSum
	call Reverse
	
	lea bx, numberSum
	call outputNumber
	
	mov ah, 9
	lea dx, newLine
	int 21h
	
	mov ah, 9
	lea dx, mes2
	int 21h
	
	xor ax, ax
	lea bx, numberOne
	call Reverse
	
	lea bx, numberOne
	call outputNumber
	
	mov ah, 9
	lea dx, mes3
	int 21h
	
	xor ax, ax
	lea bx, numberTwo
	call Reverse
	
	lea bx, numberTwo
	call outputNumber

	mov ah, 7
	int 21h

	mov ax, 4c00h
	int 21h
end main