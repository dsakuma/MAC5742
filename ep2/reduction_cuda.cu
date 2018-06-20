#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_cuda.h"

#define THREADS_PER_BLOCK 256

__global__ void min_kernel(int *result, int **input, int n_mat)
{
	__shared__ int mintile[9];

	unsigned int tid = threadIdx.x;
	unsigned int index = blockIdx.x;
	mintile[tid] = input[index][tid];

  // printf("index=%d (bloco), tid=%d (n_mat), part_min=%d, blockDim.x-1=%d\n", index, tid, mintile[tid], blockDim.x);

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
		result[index] = mintile[0];
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

  printf("nmat->%d\n", n_mat);
  printf("threads->%d\n", THREADS_PER_BLOCK);
  printf("ceil->%d\n", ceil(n_mat/(float)THREADS_PER_BLOCK));
  dim3 numBlocks(n_els, ceil(n_mat/THREADS_PER_BLOCK));
  dim3 threadsPerBlock(THREADS_PER_BLOCK);

  min_kernel<<<numBlocks, threadsPerBlock>>>(y, x, n_mat); //<<<number_of_blocks, block_size>>>

  cudaDeviceSynchronize();
  return y;
}
