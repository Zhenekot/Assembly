masm 
model small
.data
value1 dd 0AAEE6688h
value2 dd 775544FFh
mes1 db 'Initial values:$'
mes2 db 'Result:$'
newline db 10, 13, '$'
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
	
	mov cx, 32
	mk: rol value1, 1
		mov dl, 0h
		adc dl, '0'
		mov ah, 2
		int 21h
	loop mk
	
	mov cx, 32
	mn: rol value2, 1
		mov dl, 0h
		adc dl, '0'
		mov ah, 2
		int 21h
	loop mn
		
	mov eax, value1
	mov edx, value2
	push ax
	push dx
	and dl, 0fh
	and al, 0f0h
	or al, dl
	mov value1, eax

	pop dx
	pop ax
	and al, 0fh
	and dl, 0f0h
	or dl, al
	mov value2, edx
	ror value1, 4
	ror value2, 4
	
	mov ah,9
	lea dx, newline
	int 21h 
	
	mov ah,9
	lea dx, mes2
	int 21h 
	
	mov ah,9
	lea dx, newline
	int 21h 
	
	mov cx, 32
	mt: rol value1, 1
		mov dl, 0h
		adc dl, '0'
		mov ah, 2
		int 21h
	loop mt
		
	mov cx, 32
	mi: rol value2, 1
		mov dl, 0h
		adc dl, '0'
		mov ah, 2
		int 21h
	loop mi
	 
	mov ah,7
	int 21h

	mov ax, 4c00h
	int 21h
end main