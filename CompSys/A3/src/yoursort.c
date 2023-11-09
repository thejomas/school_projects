#include <stdlib.h>
#include "x86prime_lib.h"

void insertion_sort(long array[], long lo, long hi) {
  long min_val, i, j;
  for (i = lo; i <= hi; i++) {
    min_val = array[i];
    j = i--;
    while (lo <= j && min_val < array[j]) {
      array[j+1] = array[j];
      j--;
    }
    array[j+1] = min_val;
  }
  return;
}

void your_sort(long array[], long lo, long hi) {
  long arr_len = hi - lo;
  if (lo >= hi) return;

  if (arr_len <= 10) {
    insertion_sort(array, lo, hi);
  }
  else {
    long mid = (lo + hi) >> 1;
    long pivot = array[mid];
    long left = lo - 1;
    long right = hi + 1;
    while (left < right) {
      do {
	      left++;
      } while (array[left] < pivot);
      do {
	      right--;
      } while (array[right] > pivot);
      Swap(array, left, right);
    }
    your_sort(array, right + 1, hi);
    your_sort(array, lo, right);
  }
}

long* run() {
  init_allocator();
  // Read it the program should print
  // 0: Silent mode
  // 1: Print sorted list
  // 2: Get input from stdin
  // 3: Test mode (print + input)
  long mode = read_long();
  long is_printing = mode & 1;
  long get_input = mode & 2;
  // Read number of elements in array
  long num_entries = read_long();
  long* p = get_random_array(num_entries);
  // Run the algorithm
  if (get_input) {
    p = read_array(num_entries);
  }
  else {
    p = get_random_array(num_entries);
  }

  // Run the algorithm
  your_sort(p, 0, num_entries - 1);

  if (is_printing) {
    print_array(num_entries, p);
  }
  return p; // <-- prevent optimization
}
