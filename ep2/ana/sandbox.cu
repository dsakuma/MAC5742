/**

Ana Martinazzo (7209231)
Daniel

EP2 - redução em CUDA

**/

#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

#define BLOCK_SIZE 64   // tamanho do bloco
#define D 3             // dimensão das matrizes (quadradas)

void print_matrix(int** matrix, int n_rows, int n_cols);



int main(int argc, char *argv[])
{

    int *x;
    int n_els = 2;

    // (*input)[i] = (int *) calloc(*n_els, sizeof(int));
    cudaError_t err = cudaMallocManaged(&x, n_els * sizeof(int));

    return 0;

}


void print_matrix(int** matrix, int n_rows, int n_cols)
{
  printf("Printing matrix...\n");
  for(int i=0; i<n_rows; i++){
    for(int j=0; j<n_cols; j++){
        printf("%d ", matrix[i][j]);
      }
      printf("\n");
  }
}