bits 64
extern puts
global main
section .text
main:
        sub rsp, 24             ; makes room on the stack for our string
        mov BYTE [rsp + 16], 0
        mov rdi, rsp            ; stores to current place of the sp to rdi
        mov esi, 0
outer:
        mov eax, 0
        mov ecx, 3
inner:
        lea rbx, [4*rsi]
        add bl, 0x30            ; Initialize that we start from char 0
        add bl, cl              ; Now char 3 going down to 0
update:
        shl eax, 8              ; Make room in rax for 8 chars?
        mov al, bl
        dec ecx
        test ecx, ecx
        jns inner
        mov DWORD [rdi + 4*rsi], eax ; Store the 4 chars we've written to the memory starting at where rdi points
        add esi, 1
        cmp esi, 4              ; Vi vil skrive 4 * 4 chars til output
        jl outer
        call puts               ; puts the string pointed to by rdi to stdout
        add rsp, 24             ; resets the sp to what it was before strange
        mov rax, 0              ; return 0
        ret
