#include <stdio.h>
#include <inttypes.h>

uint64_t quaternary_convert(char*);

int main() {
    printf("quaternary_convert ('AD') gives: %lu, expecting 3\n",
           quaternary_convert("AD"));
    printf("quaternary_convert ('C') gives: %lu, expecting 2\n",
           quaternary_convert("C"));
    printf("quaternary_convert ('BB') gives: %lu, expecting 5\n",
           quaternary_convert("BB"));
    printf("quaternary_convert ('BCD') gives: %lu, expecting 27\n",
           quaternary_convert("ABCD"));
    printf("quaternary_convert ('ABCD') gives: %lu, expecting 27\n",
           quaternary_convert("ABCD"));
    printf("quaternary_convert ('AAAA') gives: %lu, expecting 0\n",
           quaternary_convert("AAAA"));
    printf("quaternary_convert ('BAAA') gives: %lu, expecting 64\n",
           quaternary_convert("BAAA"));
    printf("quaternary_convert ('ABChejmeddig') gives: %lu, expecting 0\n",
           quaternary_convert("ABChejmeddig"));
    return 0;
}
// ABCD = 0*4^3 + 1*4^2 + 2*4^1 + 3*4^0
//      =     0 +    16 +     8 +     3 = 27
// ABCD - mov 'A' -> rdx - cmp rdx 'A' - je a - rdi++ - rax += 0 - rax << 1 (rax = 00) - jmp loop
//      - mov 'B'
