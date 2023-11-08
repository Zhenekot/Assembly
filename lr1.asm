masm
model small

.stack 256
.data
line1 db 'Alphabet: $'
line2 db 'Word to encrypt: $'
line3 db 'Word encryption: $'
line4 db 'K: $'
alphabet db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
LEN = 26
LEN1 = 100
str_to_en db LEN1 dup(?)
str_en db LEN + 1 dup(?)
newAlphabet db LEN dup(?)
k db 3 dup (?)
newline db 10, 13, '$'
pass db 0
newString db LEN1 dup(?)
newString2 db LEN1 dup(?)
;ABCDEFGHIJKLMNOPQRSTUVWXYZ
; KING
.code

inputStr proc 
	xor si, si
	inc si
inpCycle:
	mov ah, 1
	int 21h
	
	cmp al, 13
	je exit
		
	mov[bx][si], al
	inc si
	inc byte ptr[bx]
	
loop inpCycle

exit:
	ret
	
endp	

main:
.386
	mov ax, @data
	mov ds, ax

	mov ah, 9
	lea dx, line2
	int 21h
	
	lea bx, str_to_en
	xor cx, cx
	mov cl, LEN1
	call inputStr
	
	mov ah, 9
	lea dx, newline
	int 21h
	lea dx, line3
	int 21h
	
	lea bx, str_en
	xor cx, cx
	mov cl, LEN
	call inputStr
	
	mov ah, 9
	lea dx, newline
	int 21h
	lea dx, line4
	int 21h

	xor cx, cx
	mov cx, 2
	mov si, 1
m1:
	mov ah, 1
	int 21h
	cmp al, 13
	je endd
	mov k[si], al
	inc [k]
	inc si
loop m1
endd:
	
	mov ah, 9
	lea dx, newline
	int 21h
	
	cmp [k], 2
	je twoNum
	mov al, k[1]
	sub al, 30h
	jmp endNum
twoNum:	
	mov al, k[1]
	sub al, 30h
	mov bl, 10
	mul bl
	mov ah, k[2]
	sub ah, 30h
	add al, ah
endNum:

	xor ah, ah
	mov si, ax
	mov cl, [str_en]
	mov di, 1
	mov bx, ax
	xor ax, ax
cycle:
	pusha
	mov cl, [str_en]
	mov si, bx
	inc pass
	check1:
		cmp si, len 
		jne next1
		xor si, si
		next1:
		mov al, str_en[di] 
		cmp al, newAlphabet[si] ;Сравнение на одинаковые буквы в шифраторе
		je skip1
		inc si
	loop check1
	dec pass
	popa
	cmp si, len 
	jne next
	xor si, si
next:
	mov al, str_en[di]
	mov newAlphabet[si], al
	inc si
	inc di
	jmp next3
skip1:
	popa
	inc di
next3:
loop cycle

xor di, di
mov cx, LEN
sub cl, [str_en]
add cl, pass
dec di
cycleAlphabet:
	cmp si, LEN
	jne next2
	xor si, si
next2:
	push cx
	push si
	inc di
	mov al, alphabet[di]
	mov cl, [str_en]
	mov si, 1
		check:
			mov ah, str_en[si]
			inc si
			cmp ah, al
			je skip
		loop check
skip:
	pop si
	pop cx
	cmp ah, al
	je cycleAlphabet
	
	mov al, alphabet[di]
	mov newAlphabet[si], al
	inc si
loop cycleAlphabet

	mov cl, [str_to_en]
	mov di, 1
	mov si, 0
cycleEn:
	pusha
	mov cx, LEN
	mov si, 0
	cycleSearch:
		mov al, alphabet[si]
		cmp str_to_en[di], al
		je skipCycle
		inc si
	loop cycleSearch
	skipCycle:
	mov al, newAlphabet[si]
	mov newString[di], al
	popa
	inc di
loop cycleEn

	;mov cl, LEN
	;xor si,si
;cycleOut:
	;mov ah, 2
	;mov dl, newAlphabet[si]
	;int 21h
	;inc si
;loop cycleOut


	mov cl, [str_to_en]
	mov di, 1
	mov si, 0
cycleEn2:
	pusha
	mov cx, LEN
	mov si, 0
	cycleSearch2:
		mov al, newAlphabet[si]
		cmp newString[di], al
		je skipCycle2
		inc si
	loop cycleSearch2
	skipCycle2:
	mov al, alphabet[si]
	mov newString2[di], al
	popa
	inc di
loop cycleEn2

	xor si, si
	mov si, 1
	xor cx, cx
	mov cl, [str_to_en]

cycleOutStr:
	mov ah, 2
	mov dl, newString[si]
	int 21h
	inc si
loop cycleOutStr

	mov ah, 9
	lea dx, newline
	int 21h

	xor si, si
	mov si, 1
	xor cx, cx
	mov cl, [str_to_en]

cycleOutStr2:
	mov ah, 2
	mov dl, newString2[si]
	int 21h
	inc si
loop cycleOutStr2



	mov ah, 7
	int 21h
	mov ax, 4c00h
	int 21h
end main