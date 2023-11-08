masm
model small

.data
LEN = 7
numberOne db LEN + 1 dup(?)
numberTwo db LEN + 1 dup(?)
numberRes db LEN + 2 dup(?)
sign db ?
IndMax dw ?
mes1 db 'Error!$'
mes2 db 'Number One: $'
mes3 db 'Number Two: $'
mes4 db 'Result: $'
mes5 db 'Input sign: $'
mes6 db 'Difference: $'
count dw 1
minus db '-$'
flazhok db 0
newLine db 10, 13, '$'
flag db 0
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
	inc byte ptr [bx]


loop m1
	exit:
	cmp byte ptr [bx], 0 
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
	mov cx, [bx]
	mov si, count
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

summ macro 
	xor cx, cx
	xor ax, ax
	
	mov al, numberOne[0]
	mov bl, numberTwo[0]
	cmp al, bl
	ja one
	mov cl, bl
	jmp two
	one:
	mov cl, al
	two:
	
	xor ax, ax
	clc
	mov si, 1
	mov bx, 1
m5: 
	mov al, numberOne[si]
	adc al, numberTwo[si]
	aaa
	inc si
	mov numberRes[bx], al
	inc [numberRes]
	inc bx
	mov ax, 0
loop m5
	jnc cf0
	inc numberRes[bx]
	inc [numberRes]
endm

diff macro maxel, minel 
	local d1
	xor ax, ax
	clc
	mov si, 1
	mov bx, 1
d1: 
	mov al, maxel[si]
	sbb al, minel[si]
	aas
	inc si
	mov numberRes[bx], al
	inc [numberRes]
	inc bx
	mov ax, 0
loop d1


endm
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
	
	mov ah, 9
	lea dx, newLine
	int 21h 
	
	mov ah, 9
	lea dx, mes5
	int 21h
	
	mov ah, 1
	int 21h
	mov sign, al
	cmp sign, 43
	je sum
	cmp sign, 45
	jne wrong
	
	xor cx, cx
	xor ax, ax
	
	mov al, numberOne[0]
	mov bl, numberTwo[0]
	cmp al, bl
	je d2
	ja first
	mov cl, bl
	mov flazhok, 1
	diff numberTwo, numberOne
	jmp next
	first:
	mov cl, al
	diff numberOne, numberTwo
	jmp next
d2:
	mov cl, al
	mov si, ax
check:
	mov al, numberOne[si]
	mov ah, numberTwo[si]
	cmp al, ah 
	ja n1
	jb n2
	dec si 
loop check
	mov cl, [numberOne]
n1: 
	diff numberOne, numberTwo
	jmp next
n2:
	mov flazhok, 1
	diff numberTwo, numberOne
next:
	jmp cf0
sum:
	summ
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
	
	mov ah, 9
	lea dx, newLine
	int 21h
	
	cmp flazhok, 1
	jne rezz
	
	mov ah, 9
	lea dx, minus
	int 21h
	
rezz:		
	lea bx, numberRes
	call Reverse
	mov si, 1
	mov cl, [numberRes]
cycle0:
	cmp numberRes[si], 0
	jne no0
	inc count
	inc si
loop cycle0
no0:
	mov al, [numberRes]
	sub ax, count
	mov [numberRes], al
call outputNumber
jmp endd

wrong:
	mov ah, 9
	lea dx, newLine
	int 21h
	
	mov ah, 9
	lea dx, mes1
	int 21h
endd:
	mov ah, 7
	int 21h

	mov ax, 4c00h
	int 21h
end main