# This line is a comment
set logging overwrite on
set logging file strange_gdb_debug.output
set logging on
b outer
commands 1
x /s $rdi
c
end
b update
commands 2
# rax holder resultatet af 256*rbx + rbx-1
p /c $rax
# rbx holder ...? og bliver decrementet en gang hver update.
# rbx kommer igennem 63-48, men små omvendte itterationer.
p /c $rbx
c
end
run
q
