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

void read_file(char *filename, int ***input, int *n_els);
long time_elapsed (struct timeval t0, struct timeval t1);
void print_matrix(int** matrix, int n_rows, int n_cols);

__global__ void min_reduction(int *input, int *output, int pos)
{
    int tid = threadIdx.x;
    int step_size = 1;
    int number_of_threads = blockDim.x;
    int fst, snd;

    while (number_of_threads > 0)
    {
        if (tid < number_of_threads)
        {
            fst = tid * step_size * 2;
            snd = fst + step_size;
            input[fst] = input[fst] < input[snd] ? input[fst] : input[snd];
        }

        step_size <<= 1;
        number_of_threads >>= 1;
    }

    if(tid == 0)
    {
        output[pos] = input[0];
    }
}


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

    cudaMallocManaged(&host, D*D*sizeof(int *));
    cudaMallocManaged(&result, D*D*sizeof(int));

    // read_file(argv[1], &host, &n_els);
    // print_matrix(host, D*D, n_els);

    gettimeofday(&t0, NULL);

    // Allocate Unified Memory – accessible from CPU or GPU
    // cudaMallocManaged(&x, N*sizeof(float));
    // cudaMallocManaged(&y, N*sizeof(float));

    // Run kernel on 1M elements on the GPU
    // add<<<1, 1>>>(N, x, y);

    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();

    // aloca memoria na gpu
    // cudaMalloc((void**) &dev, D*D * sizeof(int *));
    // cudaMalloc((void**) &dev_result, D*D * sizeof(int));
    // for(i=0; i < D*D; i++)
    // {
    //     cudaMalloc((void**) &dev[i], n_els * sizeof(int));
    // }

    printf("oi 1\n");

    // copiar array 2d pra gpu: http://www.orangeowlsolutions.com/archives/613
    // copia entrada da cpu para a gpu
    // cudaMemcpy2D(devPtr, devPitch, hostPtr, hostPitch, Ncols * sizeof(float), Nrows, cudaMemcpyHostToDevice)
    // cudaMemcpy(dev, host, D*D * n_els * sizeof(int), cudaMemcpyHostToDevice);

    printf("oi 2\n");

    // executa o kernel
    // for(i=0; i<D*D; i++)
    // {
    //     min_reduction<<<1, n_els/2>>>(dev[i], dev_result, i);
    // }

    // copia resultado da gpu para a cpu
    // cudaMemcpy(result, dev_result, D*D * sizeof(int), cudaMemcpyDeviceToHost);

    // limpa memoria
    cudaFree(host);
    cudaFree(result);
    // cudaFree(dev);
    // cudaFree(dev_result);

    cudaThreadExit();

    gettimeofday(&t1, NULL);

    printf("tempo: %ld us\nresultado:\n", time_elapsed(t0, t1));
    for(int i=0; i < D; i++)
        printf("%d %d %d\n", result[D*i], result[D*i+1], result[D*i+2]);

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

    // for(i=0; i < D*D; i++)
    // {
    //     // (*input)[i] = (int *) calloc(*n_els, sizeof(int));
    //     // cudaMallocManaged((*input)[i], *n_nels * sizeof(int));
    // }

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
