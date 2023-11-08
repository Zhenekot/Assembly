masm
model small

window macro x1, y1, x2, y2, color
	mov ah, 06h
	mov al, 0
	mov bh, color
	mov ch, x1
	mov cl, y1
	mov dh, x2
	mov dl, y2
	int 10h
endm

cur macro x, y
	mov ah, 2
	mov bh, 0
	mov dl, x
	mov dh, y
	int 10h
endm

messageVideo macro string, lenn, x, y
	local m1
	mov ax, 0b800h
	mov es, ax
	mov bx, (80*x+y)*2
	lea si, string
	mov cx, lenn
m1: 
	mov al, [si]
	mov es:[bx],al
	inc bx
	mov byte ptr es:[bx],4eh
	inc bx
	inc si
loop m1
endm

message macro mes, color
	cur 30, 14
	window 12, 20, 16, 60, color
	mov ah, 9
	lea dx, mes
	int 21h
endm

.data
	count = 25
	buf db count + 1 dup(?)	
	
	password db 'assembler'
	passLen = $ - password
	
	mes1 db 'Enter the password'
	len1 = $ - mes1
		
	correct db 'Correct password$'
	notCorrect db 'Incorrect password$'

.stack 256
.code 
password_input proc

input:
	xor cx, cx
	xor si, si
	
	mov cl, count
	inc si
inpCycle:
	mov ah, 7
	int 21h
	
	cmp al, 13
	je exit
	
	cmp al, 27
	je escc

	cmp al, 8
	je backSp
	
	mov[bx][si], al
	inc si
	inc byte ptr[bx]
	
	mov ah, 02h
	mov dl, '*'
	int 21h
loop inpCycle

exit:
	ret
	
escc:
	xor cx, cx
	xor si, si
	mov cl, count
clear:
	mov byte ptr[bx][si],00h
	inc si
loop clear
	xor si, si

	window 10, 22, 10, 55, 07h
	cur 22, 10
	
	jmp input
	
backSp:
	lea dx, [bx][1]
	cmp si, dx
	je cut
	dec si
cut:
	xor dx, dx
	
	mov dx, [bx]
	cmp dx, 00h
	je skip
	
	mov dh, 10
	mov dl, 22
	add dl, [bx]
	dec dl
	mov ah, 02h
	int 10h
	
	mov ah,02h
	mov dl, ' '
	int 21h
	
	mov dl, 22
	add dl, [bx]
	dec dl
	mov ah, 02h
	int 10h
	
	mov byte ptr[bx][si], 00h
	dec byte ptr[bx]
	inc cx

skip:	
	jmp inpCycle
	
endp	

main:
	mov ax, @data
	mov ds, ax
	
	window 3, 5, 20, 74, 47h
	cur 10, 5
	messageVideo mes1, len1, 5, 30
	
	window 10, 22, 10, 55, 07h
	cur 22, 10

	lea bx, buf
	call password_input
	
	mov ax, ds
	mov es, ax
	
	xor cx, cx
	xor ax, ax
	
	lea si, buf + 1
	lea di, password
	
	mov al, [buf]
	mov ah, passLen
	cmp al, ah
	jne notOk	 
	mov cl, [buf]
	cld
	repz cmpsb
	jcxz ok ;если cx = 1
notOk:	
	message notCorrect, 0C0h
	jmp exit2	
ok:
	message correct, 20h
	
exit2:	
	mov ah, 7
	int 21h

	mov ax, 4c00h
	int 21h
end main