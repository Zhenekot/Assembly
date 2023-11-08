masm 
model small

hex_out macro dd
	local m1
	mov eax, P1
	mov cx, 4
	mov di, 6
m1: push ax
	shr al, 4
	lea bx, tabl
	xlat
	mov result [di], al
	pop ax
	push ax
	and al, 0fh
	xlat
	mov result [di + 1], al
	pop ax
	shr eax, 8
	sub di, 2
	loop m1

	mov ah, 9
	lea dx, result
	int 21h
	
	lea dx, newLine
	int 21h	
endm

bin_out macro dd
	local m1
	mov ebx, P1
	mov cx, 32
m1:	rol ebx, 1
	mov dl, 0h
	adc dl, 30h
	mov ah, 2
	int 21h
	loop m1
	
	mov ah, 9
	lea dx, newLine
	int 21h
	
endm

.stack 256
.data
P1 dd 0
mes1 db 'intial value:$'
mes2 db 'result:$'
newline db 10, 13, '$'
result db '********h$'
tabl db '0123456789ABCDEF'
.stack 256
.code

main:
	mov ax, @data
	mov ds, ax
.486
	mov ah, 9
	lea dx, mes1
	int 21h
	
	mov ah,9
	lea dx, newline
	int 21h 
	

	mov ax, 46h
	mov es, ax
	mov ax, es:[0Ch]
	mov P1, eax

	hex_out P1
	bin_out P1
	
	mov ah, byte ptr P1 + 3 
	xchg byte ptr P1, ah
	mov byte ptr P1 + 3, ah
	
	mov ah, 9
	lea dx, mes2
	int 21h
	
	mov ah,9
	lea dx, newline
	int 21h 
	
	hex_out P1
	bin_out P1
	
	mov ah,7
	int 21h
	
	mov ax, 4c00h
	int 21h
end main




