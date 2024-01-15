global quaternary_convert

section .text

quaternary_convert:
        mov eax, 0
        mov edx, 0
        ; *** Your code should start here. Below is some dummy code ***
        ;; rdi = char* to the input string. Go through all the chars.
loop:
        mov dl, [rdi]
        cmp dl, 0               ; if NULL byte
        je end
        sub rdx, 'A'
        cmp dl, ('D'-'A')
        ja bad
        shl rax, 2
        inc rdi
        add rax, rdx
        jmp loop
bad:
        mov rax, 0
end:
        ret
