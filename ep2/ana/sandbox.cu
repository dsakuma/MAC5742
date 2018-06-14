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
    printf("HELLO!!!!");
    int **x;
    int D = 3;
    int n_els = 9;
    int n_mat = 3;

    FILE *fp;
    int val1, val2, val3;

    // (*input)[i] = (int *) calloc(*n_els, sizeof(int));
    cudaError_t err = cudaMallocManaged(&x, n_els * sizeof(int));

    for(int i=0; i < n_els; i++){
      cudaError_t err = cudaMallocManaged(&x[i], n_mat * sizeof(int));
    }

    // fp = fopen("teste.txt", "r");
    // fscanf(fp, "%d", n_mat);
    // fscanf(fp, "%*s", NULL); // pula linha
    //
    // for(int i=0; i < n_mat; i++)
    // {
    //   for(int j=0; j < D; j++)
    //     {
    //         fscanf(fp, "%d %d %d", &val1, &val2, &val3);
    //         x[D*j][i] = val1;
    //         x[D*j+1][i] = val2;
    //         x[D*j+2][i] = val3;
    //     }
    //     fscanf(fp, "%*s", NULL); // pula linha
    // }
    //
    // print_matrix(x, n_els, n_mat);

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
