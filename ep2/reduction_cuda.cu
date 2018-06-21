#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_cuda.h"

#define THREADS_PER_BLOCK 2

__global__ void min_kernel(int *result, int **input, int n_mat)
{
	__shared__ int mintile[THREADS_PER_BLOCK];

	unsigned int tid = threadIdx.x;
	unsigned int index_x = blockIdx.x;
  unsigned int index_y = blockIdx.y;

  unsigned int start = (index_y*THREADS_PER_BLOCK)+tid;
	mintile[tid] = input[index_x][start];

  printf("index_x=%d (elem of mat),  index_y=%d (which partition), tid=%d (max 256), mintile[tid]=%d\n",
          index_x, index_y, tid, mintile[tid]);
  //x-> elemento
  //y-> particao
  //idx -> start
  //idx+s -> end

  __syncthreads();

	// strided index and non-divergent branch
	for (unsigned int s = 1; s < blockDim.x; s *= 2)
	{
    int idx = 2*s*tid;
    // if(tid == 2 && index ==1)
    //   printf("index=%d (bloco), tid=%d (n_mat), idx=%d, blockDim.x-1=%d\n", index, tid, idx,blockDim.x);
		if (idx+s < blockDim.x)
		{
      // if(tid == 2 && index ==1)
      //   printf("mintile[idx]=%d, mintile[idx+s]=%d\n", mintile[idx], mintile[idx + s]);

			if (mintile[idx + s] < mintile[idx])
      {
        mintile[idx] = mintile[idx + s];
      }
		}
		__syncthreads();
	}

	if (tid == 0)
	{
    if(mintile[0] < result[index_x])
		  result[index_x] = mintile[0];
	}
}

int* reduction_cuda(const char filename[], int D)
{
  int **x;
  int *y;
  int n_els = D*D;
  int n_mat;

  FILE *fp;
  int val1, val2, val3;

  cudaMallocManaged(&x, n_els * sizeof(int*));
  cudaMallocManaged(&y, n_els * sizeof(int));

  fp = fopen(filename, "r");
  fscanf(fp, "%d", &n_mat);

  for(int i=0; i < n_els; i++){
    cudaMallocManaged(&x[i], n_mat * sizeof(int));
  }

  fscanf(fp, "%*s"); // skip line

  for(int i=0; i < n_mat; i++)
  {
    for(int j=0; j < D; j++)
    {
        fscanf(fp, "%d %d %d", &val1, &val2, &val3);
        x[D*j][i] = val1;
        x[D*j+1][i] = val2;
        x[D*j+2][i] = val3;
    }
      fscanf(fp, "%*s");  // skip line
  }

  //teste
  y[0] = 999999999;
  y[1] = 999999999;
  y[2] = 999999999;
  y[3] = 999999999;
  y[4] = 999999999;
  y[5] = 999999999;
  y[6] = 999999999;
  y[7] = 999999999;
  y[8] = 999999999;
  // printf("nmat->%d\n", n_mat);
  // printf("threads->%d\n", THREADS_PER_BLOCK);
  // printf("ceil->%d\n", (int)ceil(n_mat/(float)THREADS_PER_BLOCK));
  dim3 numBlocks(n_els, (int)ceil(n_mat/(float)THREADS_PER_BLOCK));
  dim3 threadsPerBlock(THREADS_PER_BLOCK);

  min_kernel<<<numBlocks, threadsPerBlock>>>(y, x, n_mat); //<<<number_of_blocks, block_size>>>

  cudaDeviceSynchronize();
  return y;
}
