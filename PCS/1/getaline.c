#include <stdio.h>
#include <inttypes.h>

uint64_t getaline(FILE*, char*);

int main() {
  FILE *fp = fopen("test.txt", "r");
  char buf[98];
  printf("getaline ('A', *) gives: %lu, expecting 65\n",
         getaline(fp, buf));
  return 0;
}
