masm
model small

.stack 256
.data
line1 db 'Enter 1st string: $'
line2 db 0ah, 0dh, 'Enter 2nd string: $'
match db 0ah, 0dh, 'OK strings are match$'
fail db 0ah, 0dh, 'Error! String do not match $'
string1 db 31
		db ?
		db 31 dup (?)
len = $ - string1
string2 db 31
		db ?
		db 31 dup (?)

.code

main: 
	mov ax, @data
	mov ds, ax
	mov es, ax
	
	mov ah, 06h
	mov al, 0
	mov bh, 1Ch 
	mov ch, 0
	mov cl, 0
	mov dh, 24
	mov dl, 79
	int 10h 
	
	mov ah, 09h
	lea dx, line1 
	int 21h
	
	mov ah, 10
	lea dx, string1 
	int 21h
	
	mov ah, 09h
	lea dx, line2 
	int 21h
	
	mov ah, 10
	lea dx, string2
	int 21h
	
	cld 
	lea si, string1 + 2 ; передача отн. адреса первой строки со смещением
	lea di, string2 + 2 ; передача отн. адреса второй строки со смещением
	mov cx, len - 2 ; счётчик для цепочечной команды 
	repe cmpsb  ;сравнение байтов si и di и выставление флагов по их результату, если df = 0, то si и di увеличиваются 
				;на 1(количество байт в том, что мы сравнивали), иначе уменьшается
	jcxz correct 
	jne notCorrect
correct: 
	mov ah, 09h
	lea dx, match 
	int 21h
	jmp exit
notCorrect:
	mov ah, 09h
	lea dx, fail
	int 21h
	mov ax, len - 3 
	sub ax, cx
	aam	
	mov dh, ah
	mov dl, al
	
	add dh, 30h
	
	mov ah, 2
	xchg dh, dl
	int 21h

	mov ah, 2
	xchg dh, dl
	add dl, 31h
	int 21h
exit: 
	mov ah, 7
	int 21h
	mov ax, 4c00h
	int 21h
end main