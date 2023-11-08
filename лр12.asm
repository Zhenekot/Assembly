masm 
model small

hex_out macro dw
	mov ax, value
	push ax
	shr al, 4
	lea bx, tabl
	xlat
	mov result + 2, al
	pop ax
	push ax
	and al, 0fh
	xlat
	mov result + 3, al
	pop ax
	push ax
	xchg ah, al
	shr al, 4
	xlat
	mov result, al
	pop ax
	xchg ah, al
	and al, 0fh
	xlat
	mov result + 1, al
	mov ah, 9
	lea dx, result
	int 21h
	
	lea dx, newLine
	int 21h	
endm


bin_out macro dw
	local m1
	mov cx, 16
m1:	rol value, 1
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
mes db 'result:$'
value dw ?
newline db 10, 13, '$'
result db '****h$'
tabl db '0123456789ABCDEF'
.stack 256
.code

main:
	mov ax, @data
	mov ds, ax
.486
	mov ah, 9
	lea dx, mes
	int 21h
	
	mov ah,9
	lea dx, newline
	int 21h 
	
	mov dx, 40h
	mov es, dx
	mov dx, es:[8h]
	
	inc dx
	mov value, dx
	
	hex_out value
	bin_out value

	
	mov ah,7
	int 21h
	
	mov ax, 4c00h
	int 21h
end main