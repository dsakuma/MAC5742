#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_cuda.h"

#define BLOCKSIZE 256

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

__global__ void min_reduction(int **result, int **input, int n_mat)
{
	__shared__ int mintile[BLOCKSIZE];

    unsigned int n_elements = n_mat;
    unsigned int tid = threadIdx.x;
    unsigned int index_x = blockIdx.x;
    unsigned int index_y = blockIdx.y * blockDim.y;
    unsigned int last_pos;
    
    // for(int n_elements = n_mat; n_elements > BLOCKSIZE; n_elements /= ceil(n_elements/(float)BLOCKSIZE))
    while(n_elements > 1)
    {
        for(int i = index_y + tid; i < n_elements; i += BLOCKSIZE)
        {
        	mintile[tid] = input[index_x][i];

            __syncthreads();

        	// if(tid==0)
        	// 	printf("index_x=%d, index_y=%d, tid=%d, mintile=%d, blockDim.x=%d, blockDim.y=%d, gridDim.x=%d, gridDim.y=%d\n",
         //            index_x, index_y, tid, mintile[tid], blockDim.x, blockDim.y, gridDim.x, gridDim.y);

            // if(blockIdx.y == gridDim.y-1) {
            //     last_pos = n_elements < BLOCKSIZE ? n_elements : BLOCKSIZE; // ultimo bloco em y
            // } else {
            //     last_pos = stride*BLOCKSIZE;
            // }

            last_pos = n_elements < BLOCKSIZE ? n_elements : BLOCKSIZE;

        	for (unsigned int s = 1; s < last_pos; s *= 2)
        	{
                int idx = 2*s*tid;
        		if (idx+s < last_pos)
        		{
        			if (mintile[idx+s] < mintile[idx])
                        mintile[idx] = mintile[idx+s];
        		}
        		__syncthreads();
        	}

        	if (tid == 0)
        	{	
        		// printf("last_pos=%d, i=%d, mintile[0]=%d\n", last_pos, i, mintile[0]);
        		input[index_x][index_y] = mintile[0];
        	}
        }
        n_elements = ceil(n_elements/(float)BLOCKSIZE);
    }
}


int* reduction_cuda(const char filename[], int D)
{
    int **x, **y, *res;
    int n_mat, ysize, numSMs;
    int n_els = D*D;

    FILE *fp;
    int val1, val2, val3;

    CUDA_SAFE_CALL(cudaMallocManaged(&x, n_els * sizeof(int*)));
    CUDA_SAFE_CALL(cudaMallocManaged(&y, n_els * sizeof(int*)));

    fp = fopen(filename, "r");
    fscanf(fp, "%d", &n_mat);
    ysize = ceil(n_mat/(float)BLOCKSIZE);

    for(int i=0; i < n_els; i++)
    {
        CUDA_SAFE_CALL(cudaMallocManaged(&x[i], n_mat * sizeof(int)));
        CUDA_SAFE_CALL(cudaMallocManaged(&y[i], ysize * sizeof(int)));
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

    cudaDeviceGetAttribute(&numSMs, cudaDevAttrMultiProcessorCount, 0);
    dim3 numBlocks(n_els, 32*numSMs);
    dim3 threadsPerBlock(BLOCKSIZE);

    printf("n_els=%d, numSMs=%d, BLOCKSIZE=%d\n", n_els, numSMs, BLOCKSIZE);

    // a funcao sobrescreve x e nao usa y
    min_reduction<<<numBlocks, threadsPerBlock>>>(y, x, n_mat); //<<<number_of_blocks, block_size>>>
    // min_reduction<<<2,2>>>(y, x, n_mat);

    cudaDeviceSynchronize();

    res = (int*) calloc(n_els, sizeof(int));
    for(int i=0; i < n_els; i++)
        res[i] = x[i][0];

    return res;
}
