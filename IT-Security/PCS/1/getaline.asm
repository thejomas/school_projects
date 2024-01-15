global getaline
extern fgetc
section .text

getaline:
    ;;  rdi = FILE*, rsi = *buffer,
	; *** Your code should start here. Below is some dummy code ***
	mov eax, 0         ; set rax to zero
    mov edx, 0
    ;; call fgetc to take char from rdi, compare with \n or \0
    ;; count number of chars upto 96 in rax. Return.
    call fgetc
    cmp rax, 'A'
    je a
    mov rax, 0
a:
    mov rax, rdx
    ret                ; pop top value from stack, jump there
