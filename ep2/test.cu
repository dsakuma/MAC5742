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

  /* Teste 1: Uma matriz */
  description = "Uma matriz";
  //given
  filename = "data/teste_1.txt";
  //when
  y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  y_seq = reduction_seq(filename, MATRIX_ORDER);
  //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(description, result);

  /* Teste 2: Duas matrizes */
  description = "Duas matrizes";
  //given
  filename = "data/teste_2.txt";
  //when
  y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  y_seq = reduction_seq(filename, MATRIX_ORDER);
  //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(description, result);

  /* Teste 3: Quantidade ímpar de matrizes */
  description = "Quantidade ímpar de matrizes";
  //given
  filename = "data/teste_impar.txt";
  //when
  y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  y_seq = reduction_seq(filename, MATRIX_ORDER);
  //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(description, result);

  /* Teste 4: Quantidade par de matrizes */
  description = "Quantidade par de matrizes";
  //given
  filename = "data/teste_par.txt";
  //when
  y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  y_seq = reduction_seq(filename, MATRIX_ORDER);
  //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(description, result);

  /* Teste 5: 10 matrizes */
  description = "Dez matrizes (a última thread não tem com o que comparar)";
  //given
  filename = "data/teste_10.txt";
  //when
  y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  y_seq = reduction_seq(filename, MATRIX_ORDER);
  //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(description, result);

  /* Teste 6: 10k matrizes */
  description = "Dez matrizes (a última thread não tem com o que comparar)";
  //given
  filename = "data/teste_10k.txt";
  write_matrix_list(10000, filename, MATRIX_ORDER);
  //when
  y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  y_seq = reduction_seq(filename, MATRIX_ORDER);
  //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(description, result);

  return 0;
}
