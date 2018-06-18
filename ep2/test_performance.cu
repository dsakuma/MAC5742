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

  /* Teste 1: Redução de 10 mil matrizes */
  description = "Redução de 10 mil matrizes";
  //given
  filename = "data/teste_10k.txt";
  write_matrix_list(10000, filename, MATRIX_ORDER);
  //when
  gettimeofday(&t0, NULL);
  reduction_cuda(filename, MATRIX_ORDER);
  gettimeofday(&t1, NULL);
  reduction_seq(filename, MATRIX_ORDER);
  gettimeofday(&t2, NULL);
  //then
  print_performance_test_result(description, time_elapsed(t0, t1), time_elapsed(t1, t2));

  /* Teste 2: Redução de 100 mil matrizes */
  description = "Redução de 100 mil matrizes";
  //given
  filename = "data/teste_100k.txt";
  write_matrix_list(100000, filename, MATRIX_ORDER);
  //when
  gettimeofday(&t0, NULL);
  reduction_cuda(filename, MATRIX_ORDER);
  gettimeofday(&t1, NULL);
  reduction_seq(filename, MATRIX_ORDER);
  gettimeofday(&t2, NULL);
  //then
  print_performance_test_result(description, time_elapsed(t0, t1), time_elapsed(t1, t2));

  /* Teste 3: Redução de 1M matrizes */
  description = "Redução de 1M matrizes";
  //given
  filename = "data/teste_1M.txt";
  write_matrix_list(1000000, filename, MATRIX_ORDER);
  //when
  gettimeofday(&t0, NULL);
  reduction_cuda(filename, MATRIX_ORDER);
  gettimeofday(&t1, NULL);
  reduction_seq(filename, MATRIX_ORDER);
  gettimeofday(&t2, NULL);
  //then
  print_performance_test_result(description, time_elapsed(t0, t1), time_elapsed(t1, t2));

  /* Teste 4: Redução de 10M matrizes */
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