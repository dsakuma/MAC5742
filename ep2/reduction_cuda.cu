#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_cuda.h"

#define THREADS_PER_BLOCK 256

__global__ void min_kernel(int **result, int **input, int n_mat)
{
	__shared__ int mintile[THREADS_PER_BLOCK];

	unsigned int tid = threadIdx.x;
	unsigned int index_x = blockIdx.x;
  unsigned int index_y = blockIdx.y;

  unsigned int start = (index_y*THREADS_PER_BLOCK)+tid;

  if(start >= n_mat)
    return;

	mintile[tid] = input[index_x][start];

	__syncthreads();

	if(tid%2 != 0)
		return;

	for (unsigned int s = 1; s < blockDim.x; s *= 2)
	{
    int idx = tid;
		if (idx+s < blockDim.x  && start+s < n_mat)
		{
			if (mintile[idx + s] < mintile[idx])
        mintile[idx] = mintile[idx + s];
		}
		__syncthreads();
	}

	if (tid == 0)
		result[index_x][index_y] = mintile[0];
}

int* reduction_cuda(const char filename[], int D)
{
  int **x;
  int **y;
	int **tmp;
	int *res;
  int n_els = D*D;
  int n_mat;
	int n_partitions;

  FILE *fp;
  int val1, val2, val3;

  cudaMallocManaged(&x, n_els * sizeof(int*));
  cudaMallocManaged(&y, n_els * sizeof(int*));

  fp = fopen(filename, "r");
  fscanf(fp, "%d", &n_mat);

  for(int i=0; i < n_els; i++)
    cudaMallocManaged(&x[i], n_mat * sizeof(int));

	for(int i=0; i < n_els; i++)
    cudaMallocManaged(&y[i], n_mat * sizeof(int));

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

	do{
		n_partitions = (int)ceil(n_mat/(float)THREADS_PER_BLOCK);
		dim3 numBlocks(n_els, n_partitions);
		dim3 threadsPerBlock(THREADS_PER_BLOCK);
		min_kernel<<<numBlocks, threadsPerBlock>>>(y, x, n_mat); //<<<number_of_blocks, block_size>>>
		cudaDeviceSynchronize();
		n_mat = n_partitions;
		tmp = x;
		x = y;
		y = tmp;
	}while(n_partitions > 1);

	res = (int*) calloc(n_els, sizeof(int));
	for(int i=0; i < n_els; i++)
		res[i] = x[i][0];

	return res;
}
