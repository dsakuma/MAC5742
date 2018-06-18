#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_cuda.h"

#define CUDA_SAFE_CALL(err) __cuda_safe_call(err, __FILE__, __LINE__)

inline void
__cuda_safe_call (cudaError err, const char *filename, const int line_number)
{
  if (err != cudaSuccess)
    {
      printf ("CUDA error %i at %s:%i: %s\n",
          err, filename, line_number, cudaGetErrorString (err));
      exit (-1);
    }
}

__global__ void min_kernel(int *result, int **input, int n_mat)
{
	__shared__ int mintile[9];

	unsigned int tid = threadIdx.x;
	unsigned int index = blockIdx.x;
	mintile[tid] = input[index][tid];

  printf("index=%d (bloco), tid=%d (n_mat), part_min=%d\n", index, tid, mintile[tid]);


  // if(mintile[tid] > 0)
  // {
  //   printf("mintile:\n");
  //   for(int i=0; i<n_mat; i++)
  //     printf("%d ", mintile[i]);
  //   printf("\n");
  // }

  __syncthreads();

	// strided index and non-divergent branch
	for (unsigned int s = 1; s < blockDim.x; s *= 2)
	{
    int idx = 2*s*tid;
		if (idx < blockDim.x-1)
		{
			if (mintile[idx + s] < mintile[idx])
      {
        mintile[idx] = mintile[idx + s];
      }
		}
    if(tid == 0 && index ==1)
      printf("mintile[tid]=%d\n", mintile[tid]);
		__syncthreads();
    // if(mintile[tid] > 0)
    // {
    //   printf("mintile:\n");
    //   for(int i=0; i<n_mat; i++)
    //     printf("%d ", mintile[i]);
    //   printf("\n");
    // }
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

  CUDA_SAFE_CALL(cudaMallocManaged(&x, n_els * sizeof(int*)));
  CUDA_SAFE_CALL(cudaMallocManaged(&y, n_els * sizeof(int)));

  fp = fopen(filename, "r");
  fscanf(fp, "%d", &n_mat);

  for(int i=0; i < n_els; i++){
    CUDA_SAFE_CALL(cudaMallocManaged(&x[i], n_mat * sizeof(int)));
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

  dim3 numBlocks(D*D);
  dim3 threadsPerBlock(n_mat);

  min_kernel<<<numBlocks, threadsPerBlock>>>(y, x, n_mat); //<<<number_of_blocks, block_size>>>

  cudaDeviceSynchronize();
  return y;
}
