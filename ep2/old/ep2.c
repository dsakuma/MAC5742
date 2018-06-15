/**

Ana Martinazzo (7209231)
Daniel

EP2 - redução em CUDA

**/

#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

#define BLOCK_SIZE 64   // tamanho do bloco
#define D 3             // dimensão das matrizes (quadradas)

void read_file(char *filename, int ***input, int *n_els);
long time_elapsed (struct timeval t0, struct timeval t1);
void print_matrix(int** matrix, int n_rows, int n_cols);


int main(int argc, char *argv[])
{

    if(argc != 2)
    {
        printf("parâmetros requeridos: main <<caminho_matrizes>\n");
        return 1;
    }

    int **host;
    int *result;
    int **dev;
    int *dev_result;
    int n_els;          // quantidade de matrizes
    int i;
    struct timeval t0, t1;

    host = (int **) calloc(D*D, sizeof(int *));
    result = (int *) calloc(D*D, sizeof(int));
    read_file(argv[1], &host, &n_els);

    print_matrix(host, D*D, n_els);
    return 0;

}


void read_file(char *filename, int ***input, int *n_els)
{
    FILE *fp;
    int val1, val2, val3;
    int i, j;

    fp = fopen(filename, "r");
    fscanf(fp, "%d", n_els);
    fscanf(fp, "%*s", NULL); // pula linha

    for(i=0; i < D*D; i++)
    {
        (*input)[i] = (int *) calloc(*n_els, sizeof(int));
    }

    for(j=0; j < *n_els; j++)
    {
      for(i=0; i < D; i++)
        {
            fscanf(fp, "%d %d %d", &val1, &val2, &val3);
            (*input)[D*i][j] = val1;
            (*input)[D*i+1][j] = val2;
            (*input)[D*i+2][j] = val3;
        }
        fscanf(fp, "%*s", NULL); // pula linha
    }

    fclose(fp);
}


long time_elapsed (struct timeval t0, struct timeval t1)
{
    return (t1.tv_sec-t0.tv_sec)*1000000 + t1.tv_usec-t0.tv_usec;
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
