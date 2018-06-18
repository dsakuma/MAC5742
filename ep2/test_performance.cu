#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_cuda.h"
#include "reduction_seq.h"

#define MATRIX_ORDER 3

int main(int argc, char *argv[])
{
  int result;
  const char* filename;
  const char* description;
  int *y_cuda;
  int *y_seq ;

  /* Test 1: Quantidade ímpar de matrizes */
  description = "Redução de 10 mil matrizes";
  //given
  filename = "data/teste_10k.txt";
  write_matrix_list(10000, filename, MATRIX_ORDER);

  //when
  y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  y_seq = reduction_seq(filename, MATRIX_ORDER);
  // //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(description, result);

  return 0;
}
