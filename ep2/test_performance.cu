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
  const char* filename;
  const char* description;
  struct timeval t0, t1, t2;

  /* Teste 1: Redução de 512 matrizes */
  description = "Redução de 512 matrizes";
  //given
  filename = "data/teste_512.txt";
  write_matrix_list(1<<9, filename, MATRIX_ORDER);
  //when
  gettimeofday(&t0, NULL);
  reduction_cuda(filename, MATRIX_ORDER);
  gettimeofday(&t1, NULL);
  reduction_seq(filename, MATRIX_ORDER);
  gettimeofday(&t2, NULL);
  //then
  print_performance_test_result(description, time_elapsed(t0, t1), time_elapsed(t1, t2));

  /* Teste 2: Redução de 2048 matrizes */
  description = "Redução de 2048 matrizes";
  //given
  filename = "data/teste_2k.txt";
  write_matrix_list(1<<11, filename, MATRIX_ORDER);
  //when
  gettimeofday(&t0, NULL);
  reduction_cuda(filename, MATRIX_ORDER);
  gettimeofday(&t1, NULL);
  reduction_seq(filename, MATRIX_ORDER);
  gettimeofday(&t2, NULL);
  //then
  print_performance_test_result(description, time_elapsed(t0, t1), time_elapsed(t1, t2));

  /* Teste 3: Redução de 8192 matrizes */
  description = "Redução de 8192 matrizes";
  //given
  filename = "data/teste_8k.txt";
  write_matrix_list(1<<13, filename, MATRIX_ORDER);
  //when
  gettimeofday(&t0, NULL);
  reduction_cuda(filename, MATRIX_ORDER);
  gettimeofday(&t1, NULL);
  reduction_seq(filename, MATRIX_ORDER);
  gettimeofday(&t2, NULL);
  //then
  print_performance_test_result(description, time_elapsed(t0, t1), time_elapsed(t1, t2));

  /* Teste 4: Redução de 1M matrizes */
  description = "Redução de 1M matrizes";
  //given
  filename = "data/teste_1M.txt";
  write_matrix_list(1<<20, filename, MATRIX_ORDER);
  //when
  gettimeofday(&t0, NULL);
  reduction_cuda(filename, MATRIX_ORDER);
  gettimeofday(&t1, NULL);
  reduction_seq(filename, MATRIX_ORDER);
  gettimeofday(&t2, NULL);
  //then
  print_performance_test_result(description, time_elapsed(t0, t1), time_elapsed(t1, t2));

  /* Teste 5: Redução de 10B matrizes */
  description = "Redução de 10M matrizes";
  //given
  filename = "data/teste_10M.txt";
  write_matrix_list(10000000, filename, MATRIX_ORDER);
  //when
  gettimeofday(&t0, NULL);
  reduction_cuda(filename, MATRIX_ORDER);
  gettimeofday(&t1, NULL);
  reduction_seq(filename, MATRIX_ORDER);
  gettimeofday(&t2, NULL);
  //then
  print_performance_test_result(description, time_elapsed(t0, t1), time_elapsed(t1, t2));

  return 0;
}
