#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_cuda.h"
#include "reduction_seq.h"

#define MATRIX_ORDER 3

int assert_vector(int* a, int* b, int size)
{
  for(int i=0; i<size; i++){
    if(a[i] != b[i])
      return 1;
  }
  return 0;
}

void print_test_result(int test_number, int result)
{
    if(result == 1){
      printf("Test %d failed!\n", test_number);
      return;
    }
    printf("Test %d passed!\n", test_number);
    return;
}


int main(int argc, char *argv[])
{
  int result;

  /* Test 1: Quantidade ímpar de matrizes */
  //given
  char* filename = "data/teste_impar.txt";
  //when
  int *y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  int *y_seq = reduction_seq(filename, MATRIX_ORDER);
  //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(1, result);



  return 0;
}
