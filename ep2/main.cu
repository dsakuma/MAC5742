/**
Ana Martinazzo (7209231)
Daniel Sakuma (5619562  )
EP2 - Redução em CUDA
**/


#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

#define CUDA_SAFE_CALL(err) __cuda_safe_call(err, __FILE__, __LINE__)

#define D 3 // dimensão das matrizes (quadradas)

void print_matrix(int** matrix, int n_rows, int n_cols);
void print_vector(int* vector, int n_els);

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
	__shared__ int mintile[3];
  // for(int i=0; i<n_mat; i++)
  //   mintile[i] = 99;
	unsigned int tid = threadIdx.x;
	unsigned int index = blockIdx.x;
	mintile[tid] = input[index][tid];
  // if(mintile[tid] > 0)
	//   printf("i=%d, tid=%d, part_min=%d\n", index, tid, mintile[tid]);

  __syncthreads();
  if(tid == 0 && index ==0)
  {
    printf("mintile inicial tid=%d index=%d:\n", tid, index);
    for(int i=0; i<n_mat; i++)
      printf("%d ", mintile[i]);
    printf("\n");
  }

	// strided index and non-divergent branch
	for (unsigned int s = 1; s < blockDim.x; s *= 2)
	{
    int idx = 2*s*tid;
    // if(mintile[tid] > 0)
    //   printf("Dentro for: i=%d, tid=%d, s=%d, blockDim=%d\n",
    //        idx, tid, s, blockDim.x);
		if (idx < blockDim.x-1)
		{
      // if(mintile[tid] > 0)
      //   printf("primeiro if, i=%d, tid=%d, mintile[tid]=%d, input[tid + s]=%d\n", idx, tid, mintile[tid], input[index][2*tid + s]);
			if (mintile[idx + s] < mintile[idx])
      {
        // printf("Dentro if: i=%d, idx=%d, s=%d, mintile[idx]=%d, mintile[idx + s]=%d\n",
        //        idx, idx, s, mintile[idx], input[index][2*idx + s]);
        mintile[idx] = mintile[idx + s];
      }
		}
    // if(mintile[tid] > 0)
    // {
    //   printf("mintile:\n");
    //   for(int i=0; i<n_mat; i++)
    //     printf("%d ", mintile[i]);
    //   printf("\n");
    // }
		__syncthreads();
    if(tid == 0 && index ==0)
    {
      printf("mintile tid=%d index=%d, s=%d\n", tid, index, s);
      for(int i=0; i<n_mat; i++)
        printf("%d ", mintile[i]);
      printf("\n");
    }
	}
  // if(mintile[tid] > 0)
  //   printf("i=%d, tid=%d, part_min=%d\n", index, tid, mintile[tid]);

	if (tid == 0)
	{
		result[index] = mintile[0];
	}
}


int main(int argc, char *argv[])
{
    int **x;
    int *y;
    int n_els = D*D;
    int n_mat;

    FILE *fp;
    int val1, val2, val3;

    CUDA_SAFE_CALL(cudaMallocManaged(&x, n_els * sizeof(int)));
    CUDA_SAFE_CALL(cudaMallocManaged(&y, n_els * sizeof(int)));

    fp = fopen(argv[1], "r");
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

    // print_matrix(x, n_els, n_mat);

    dim3 numBlocks(D*D);
    dim3 threadsPerBlock(n_mat);

	  min_kernel<<<numBlocks, threadsPerBlock>>>(y, x, n_mat); //<<<number_of_blocks, block_size>>>

    cudaDeviceSynchronize();

    printf("y:\n");
    print_vector(y, n_els);

    return 0;

}

void print_matrix(int** matrix, int n_rows, int n_cols)
{
	printf("Printing matrix...\n");
	for(int i=0; i<n_rows; i++)
	{
		for(int j=0; j<n_cols; j++)
		{
			printf("%d ", matrix[i][j]);
		}
		printf("\n");
	}
}

void print_vector(int* vector, int n_els)
{
	printf("Printing vector...\n");
	for(int i=0; i<n_els; i++)
	{
		printf("%d ", vector[i]);
		if((i+1)%D == 0)
			printf("\n");
	}
	printf("\n");
}
