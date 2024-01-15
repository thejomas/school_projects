global quaternary_convert

section .text

quaternary_convert:
        mov rax, 0
        ; *** Your code should start here. Below is some dummy code ***
        ;; rdi = char* to the input string. Go through all the chars.
loop:
        mov dl, [rdi]
        cmp dl, 'A'            ; cmp [rdi] A = 65 i dec, burde kunne skrice rdx her
        je a
        cmp dl, 'B'            ; cmp [rdi]
        je b
        cmp dl, 'C'            ; cmp [rdi]
        je c
        cmp dl, 'D'            ; cmp [rdi]
        je d
        cmp dl, 0
        je end
        mov rax, 0
        ret
a:                              ; Brug ascii offset og shifts
        shl rax, 2
        inc rdi
        add rax, 0              ; temp for arithmatic
        jmp loop
b:
        shl rax, 2
        inc rdi
        add rax, 1
        jmp loop
c:
        shl rax, 2
        inc rdi
        add rax, 2
        jmp loop
d:
        shl rax, 2
        inc rdi
        add rax, 3
        jmp loop
end:
        ret

        ;;  cmp null -> end, rdi - 'A', cmp 0 jge -> cmp 3 jle -> ...
        ;;  else mov rax 0, ret.
