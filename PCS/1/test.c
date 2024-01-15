#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char *argv[]) {
  int n = atoi(argv[1]);
  return argc * pow(n,4);
}
