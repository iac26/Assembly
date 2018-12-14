
global start


%define	SYS_EXIT  0x2000001
%define	SYS_READ  0x2000003
%define	SYS_WRITE  0x2000004
%define	SYS_OPEN  0x2000005
%define	SYS_CLOSE  0x2000006

%define STDIN  0
%define STDOUT  1
%define STDERR 	2


section .text

; calling conventions REGISTERS
; rdi rsi rdx rcx r8 r9
; return in rax rdx
; no need to save rax r10 r11 


start:		mov 	rdi, txt
		mov 	rsi, msg
		call 	conc
		mov 	rdi, txt
		mov 	rsi, endl
		call 	conc

		mov 	rdi, tes
		call 	print
		
		mov 	rdi, 0
		mov 	rax, SYS_EXIT
		syscall


; argument ptr to string in rdi
print:		push 	rbp
		mov 	rbp, rsp
		push 	rdi
		call 	str_len
		mov 	rdx, rax
		mov 	rax, SYS_WRITE
		pop 	rsi
		mov 	rdi, STDOUT
		syscall
		mov 	rsp, rbp
		pop 	rbp
		ret

; argument ptr to string in rdi
str_len:	push 	rbp
		mov 	rbp, rsp
		mov 	rax, 0
		mov 	dl, 0
str_len_loop:	cmp 	dl, [rdi + rax]
		je 	str_len_end
		inc 	rax
		jmp 	str_len_loop
str_len_end:	mov 	rsp, rbp
		pop 	rbp
		ret


; argument int in rdi ptr for string in rsi
str_from_int:	push 	rbp
		mov 	rbp, rsp
		push 	rbx
		mov 	rax, 1
		mov 	rcx, 0
str_f_i_loop1:	mov	rdx, 10
		mul	rdx
		inc 	rcx
		cmp	rdi, rax
		jge 	str_f_i_loop1
		mov 	al, 0
		mov	[rsi+rcx], al
		dec 	rcx
		mov 	rax, rdi
		mov 	rbx, 10
str_f_i_loop2:	mov 	rdx, 0
		div 	rbx
		add 	dl, 48
		mov 	[rsi+rcx], dl
		dec 	rcx
		cmp 	rax, 0
		jnz 	str_f_i_loop2
		pop 	rbx
		mov 	rsp, rbp
		pop 	rbp
		ret


; read number from stdin return in rax
 scan_ui:	push	rbp
 		mov 	rbp, rsp
 		push 	rbx
 		mov 	rax, SYS_READ
 		mov 	rdi, STDIN
 		mov 	rsi, buf
 		mov 	rdx, 10
 		syscall
 		mov 	rbx, 0
 		mov 	rdi, rax
 		mov 	rax, 1
 		mov 	r8, buf
 		sub 	rdi, 2
 scan_loop:	mov 	rcx, 0
 		mov 	cl, [r8+rdi] 
 		sub 	cl, 48
 		mov 	r9, rax
 		mul 	rcx
 		add 	rbx, rax
 		mov 	rcx, 10
 		mov 	rax, r9
 		mul 	rcx
 		dec 	rdi 
 		cmp 	rdi, 0
 		jge 	scan_loop
 		mov 	rax, rbx
 		pop 	rbx
 		mov 	rsp, rbp
 		pop 	rbp
 		ret

; concat two strings ptr a rdi ptr b rsi
conc: 		push 	rbp
		mov 	rbp, rsp
		push 	rdi
conc_lp1:	mov 	al, [rdi]
		cmp 	al, 0
		je 	conc_lp2
		inc 	rdi
		jmp 	conc_lp1
conc_lp2:	mov 	al, [rsi]
		mov 	[rdi], al
		mov 	rdi, rax
		call 	dbug
		inc 	rdi
		inc 	rsi
		cmp 	al, 0
		jne 	conc_lp2
		mov 	rsp, rbp
		pop 	rbp
		ret




dbug:		mov 	rax, SYS_EXIT
 		syscall


section .data
tes: 		db 	"TEST", 0 
msg: 		db 	"hello", 0
endl: 		db 	10, 13, 0


section .bss
buf: 		resb 	100
txt: 		resb	100

	


