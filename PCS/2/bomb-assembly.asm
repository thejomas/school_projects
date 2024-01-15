[0x00002a63]> pdf sym.phase_1
┌ fcn.00002a19 ();
│           0x00002a19      push rbp
│           0x00002a1a      mov rbp, rsp
│           0x00002a1d      movzx eax, word [0x000063c0]
│           0x00002a24      test ax, ax
│       ┌─< 0x00002a27      jne 0x2a35
│       │   0x00002a29      lea rdi, str.I_ll_never_sink_so_low ; 0x34b9 ; int64_t arg1
│       │   0x00002a30      call fcn.0000299f
│       └─> 0x00002a35      movzx eax, word [0x000063c0]
│           0x00002a3c      sub eax, 1
│           0x00002a3f      mov word [0x000063c0], ax
│           0x00002a46      movzx eax, word [0x000063c0]
│           0x00002a4d      cwde
│           0x00002a4e      cdqe
│           0x00002a50      lea rdx, [rax*8]
│           0x00002a58      lea rax, [0x000063e0]
│           0x00002a5f      mov rax, qword [rdx + rax]
│           0x00002a63      pop rbp
└           0x00002a64      ret
[0x00002a63]> pdf sym.phase_2
┌ fcn.00002a19 ();
│           0x00002a19      push rbp
│           0x00002a1a      mov rbp, rsp
│           0x00002a1d      movzx eax, word [0x000063c0]
│           0x00002a24      test ax, ax
│       ┌─< 0x00002a27      jne 0x2a35
│       │   0x00002a29      lea rdi, str.I_ll_never_sink_so_low ; 0x34b9 ; int64_t arg1
│       │   0x00002a30      call fcn.0000299f
│       └─> 0x00002a35      movzx eax, word [0x000063c0]
│           0x00002a3c      sub eax, 1
│           0x00002a3f      mov word [0x000063c0], ax
│           0x00002a46      movzx eax, word [0x000063c0]
│           0x00002a4d      cwde
│           0x00002a4e      cdqe
│           0x00002a50      lea rdx, [rax*8]
│           0x00002a58      lea rax, [0x000063e0]
│           0x00002a5f      mov rax, qword [rdx + rax]
│           0x00002a63      pop rbp
└           0x00002a64      ret
[0x00002a63]> pdf sym.phase_3
┌ fcn.00002a19 ();
│           0x00002a19      push rbp
│           0x00002a1a      mov rbp, rsp
│           0x00002a1d      movzx eax, word [0x000063c0]
│           0x00002a24      test ax, ax
│       ┌─< 0x00002a27      jne 0x2a35
│       │   0x00002a29      lea rdi, str.I_ll_never_sink_so_low ; 0x34b9 ; int64_t arg1
│       │   0x00002a30      call fcn.0000299f
│       └─> 0x00002a35      movzx eax, word [0x000063c0]
│           0x00002a3c      sub eax, 1
│           0x00002a3f      mov word [0x000063c0], ax
│           0x00002a46      movzx eax, word [0x000063c0]
│           0x00002a4d      cwde
│           0x00002a4e      cdqe
│           0x00002a50      lea rdx, [rax*8]
│           0x00002a58      lea rax, [0x000063e0]
│           0x00002a5f      mov rax, qword [rdx + rax]
│           0x00002a63      pop rbp
└           0x00002a64      ret
[0x00002a63]> pdf sym.phase_4
┌ fcn.00002a19 ();
│           0x00002a19      push rbp
│           0x00002a1a      mov rbp, rsp
│           0x00002a1d      movzx eax, word [0x000063c0]
│           0x00002a24      test ax, ax
│       ┌─< 0x00002a27      jne 0x2a35
│       │   0x00002a29      lea rdi, str.I_ll_never_sink_so_low ; 0x34b9 ; int64_t arg1
│       │   0x00002a30      call fcn.0000299f
│       └─> 0x00002a35      movzx eax, word [0x000063c0]
│           0x00002a3c      sub eax, 1
│           0x00002a3f      mov word [0x000063c0], ax
│           0x00002a46      movzx eax, word [0x000063c0]
│           0x00002a4d      cwde
│           0x00002a4e      cdqe
│           0x00002a50      lea rdx, [rax*8]
│           0x00002a58      lea rax, [0x000063e0]
│           0x00002a5f      mov rax, qword [rdx + rax]
│           0x00002a63      pop rbp
└           0x00002a64      ret
[0x00002a63]> pdf sym.phase_5
┌ fcn.00002a19 ();
│           0x00002a19      push rbp
│           0x00002a1a      mov rbp, rsp
│           0x00002a1d      movzx eax, word [0x000063c0]
│           0x00002a24      test ax, ax
│       ┌─< 0x00002a27      jne 0x2a35
│       │   0x00002a29      lea rdi, str.I_ll_never_sink_so_low ; 0x34b9 ; int64_t arg1
│       │   0x00002a30      call fcn.0000299f
│       └─> 0x00002a35      movzx eax, word [0x000063c0]
│           0x00002a3c      sub eax, 1
│           0x00002a3f      mov word [0x000063c0], ax
│           0x00002a46      movzx eax, word [0x000063c0]
│           0x00002a4d      cwde
│           0x00002a4e      cdqe
│           0x00002a50      lea rdx, [rax*8]
│           0x00002a58      lea rax, [0x000063e0]
│           0x00002a5f      mov rax, qword [rdx + rax]
│           0x00002a63      pop rbp
└           0x00002a64      ret
[0x00002a63]> pdf sym.phase_6
┌ fcn.00002a19 ();
│           0x00002a19      push rbp
│           0x00002a1a      mov rbp, rsp
│           0x00002a1d      movzx eax, word [0x000063c0]
│           0x00002a24      test ax, ax
│       ┌─< 0x00002a27      jne 0x2a35
│       │   0x00002a29      lea rdi, str.I_ll_never_sink_so_low ; 0x34b9 ; int64_t arg1
│       │   0x00002a30      call fcn.0000299f
│       └─> 0x00002a35      movzx eax, word [0x000063c0]
│           0x00002a3c      sub eax, 1
│           0x00002a3f      mov word [0x000063c0], ax
│           0x00002a46      movzx eax, word [0x000063c0]
│           0x00002a4d      cwde
│           0x00002a4e      cdqe
│           0x00002a50      lea rdx, [rax*8]
│           0x00002a58      lea rax, [0x000063e0]
│           0x00002a5f      mov rax, qword [rdx + rax]
│           0x00002a63      pop rbp
└           0x00002a64      ret
