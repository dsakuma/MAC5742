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

void print_test_result(const char description[], int result)
{
    if(result == 1){
      printf("Teste: %s [Falhou]\n", description);
      return;
    }
    printf("Teste: %s [OK]\n", description);
    return;
}

int main(int argc, char *argv[])
{
  int result;
  const char* filename;
  const char* description;
  int *y_cuda;
  int *y_seq ;

  /* Test 1: Quantidade ímpar de matrizes */
  description = "Quantidade ímpar de matrizes";
  //given
  filename = "data/teste_impar.txt";
  //when
  y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  y_seq = reduction_seq(filename, MATRIX_ORDER);
  //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(description, result);

  /* Test 2: Quantidade par de matrizes */
  description = "Quantidade par de matrizes";
  //given
  filename = "data/teste_par.txt";
  //when
  y_cuda = reduction_cuda(filename, MATRIX_ORDER);
  y_seq = reduction_seq(filename, MATRIX_ORDER);
  //then
  result = assert_vector(y_cuda, y_seq, MATRIX_ORDER*MATRIX_ORDER);
  print_test_result(description, result);

  return 0;
}
