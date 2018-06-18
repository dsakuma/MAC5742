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
  struct timeval t0, t1;

  /* Teste 1: Redução de 10 mil matrizes */
  description = "Redução de 10 mil matrizes";
  //given
  filename = "data/teste_10k.txt";
  write_matrix_list(10000, filename, MATRIX_ORDER);
  //when
  gettimeofday(&t0, NULL);
  y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  y_seq = reduction_seq(filename, MATRIX_ORDER);
  gettimeofday(&t1, NULL);
  // //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(description, result);
  printf("tempo: %ld us\nresultado:\n", time_elapsed(t0, t1));

  return 0;
}
