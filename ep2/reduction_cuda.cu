#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_cuda.h"

#define BLOCKSIZE 32
#define BLOCKSIZE_Z 1024    // avoid bus error when number of threads > 1024

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

__global__ void partial_min(int **result, int **input)
{
	__shared__ int mintile[BLOCKSIZE];

	unsigned int tid = threadIdx.x;
	unsigned int index_x = blockIdx.x;
  unsigned int index_y = blockIdx.y;
  unsigned int index_z = blockIdx.z;
	mintile[tid] = input[index_x][BLOCKSIZE_Z*index_z + BLOCKSIZE*index_y + tid];

	if(tid==0)
		//printf("index=%d (bloco), tid=%d (n_mat), mintile=%d, blockDim.x=%d\n", index_x, tid, mintile[tid], blockDim.x);

  	__syncthreads();

	for (unsigned int s = 1; s < blockDim.x; s *= 2)
	{
        int idx = 2*s*tid;
		if (idx+s < blockDim.x)
		{
			if (mintile[idx + s] < mintile[idx])
            {
                mintile[idx] = mintile[idx + s];
            }
		}
		__syncthreads();
	}

	if (tid == 0)
	{	
		//printf("result[%d][%d]=%d\n", index_x, (index_z+1)*index_y, mintile[0]);
		result[index_x][index_z*BLOCKSIZE + index_y] = mintile[0];
	}
}


__global__ void final_min(int *result, int **input)
{
    __shared__ int mintile[BLOCKSIZE_Z];

    unsigned int tid = threadIdx.x;
    unsigned int index = blockIdx.x;
    mintile[tid] = input[index][tid];

    __syncthreads();

    // strided index and non-divergent branch
    for (unsigned int s = 1; s < blockDim.x; s *= 2)
    {
        int idx = 2*s*tid;
        if (idx+s < blockDim.x)
        {
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
  int **y;
  int *res;
  int n_els = D*D;
  int n_mat, blocks_y, blocks_z, total_blocks;

  FILE *fp;
  int val1, val2, val3;

  CUDA_SAFE_CALL(cudaMallocManaged(&x, n_els * sizeof(int*)));
  CUDA_SAFE_CALL(cudaMallocManaged(&y, n_els * sizeof(int*)));
  CUDA_SAFE_CALL(cudaMallocManaged(&res, n_els * sizeof(int)));

  fp = fopen(filename, "r");
  fscanf(fp, "%d", &n_mat);
  blocks_z = ceil(n_mat/(float) BLOCKSIZE_Z);
  blocks_y = ceil(n_mat/(float) (blocks_z*BLOCKSIZE));
  total_blocks = blocks_y*blocks_z;

  printf("blocks_z: %d, blocks_y: %d, total: %d\n", blocks_z, blocks_y, total_blocks);  

  for(int i=0; i < n_els; i++){
    CUDA_SAFE_CALL(cudaMallocManaged(&x[i], n_mat * sizeof(int)));
    CUDA_SAFE_CALL(cudaMallocManaged(&y[i], total_blocks * sizeof(int)));
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

  dim3 numBlocks(n_els, blocks_y, blocks_z);
  dim3 threadsPerBlock(BLOCKSIZE);

  partial_min<<<numBlocks, threadsPerBlock>>>(y, x); //<<<number_of_blocks, block_size>>>
  final_min<<<n_els, total_blocks>>>(res, y);

  cudaDeviceSynchronize();

  //print_matrix(y, n_els, total_blocks);
  
  return res;
}
