#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <cuda_profiler_api.h>

// Convenience function for checking CUDA runtime API results
// can be wrapped around any runtime API call. No-op in release builds.
inline
cudaError_t checkCuda(cudaError_t result)
{
#if defined(DEBUG) || defined(_DEBUG)
  if (result != cudaSuccess) {
    fprintf(stderr, "CUDA Runtime Error: %s\n", cudaGetErrorString(result));
    assert(result == cudaSuccess);
  }
#endif
  return result;
}


void matSum(float* S, float* A, float* B, int N) {
for (int i = 0; i < N; ++i) {
    for (int j = 0; j < N; ++j) {
      int tid = i*N+j;
      S[tid] = A[tid] + B[tid];
    }
  }    
}


// Fills a vector with random float entries.
void randomInit(float* data, int N) {
  for (int i = 0; i < N; ++i) {
    for (int j = 0; j < N; ++j) {
      int tid = i*N+j;
      data[tid] = (float)drand48();
    }
  }
}


int main(int argc, char* argv[])
{

  if (argc != 2) {
    fprintf(stderr, "Syntax: %s <matrix size>  \n", argv[0]);
    return EXIT_FAILURE;
  }

  int N = atoi(argv[1]);

  // set seed for drand48()
  srand48(42);

  // allocate host memory for matrices A and B
  //printf("Allocate host memory for matrices A and B...\n");
  float* A = (float*) malloc(N * N * sizeof(float));
  float* B = (float*) malloc(N * N * sizeof(float));
  float* S = (float*) malloc(N * N * sizeof(float));

  // initialize host matrices
  //printf("Initialize host matrices...\n");
  randomInit(A, N);
  randomInit(B, N);

  // execute the kernel
  printf("Execute the kernel...\n");
  struct timeval begin, end;
  gettimeofday(&begin, NULL);

  matSum(S, A, B, N);

  gettimeofday(&end, NULL);
  float cpuTime = 1000000*(float)(end.tv_sec - begin.tv_sec);
  cpuTime +=  (float)(end.tv_usec - begin.tv_usec);
  // print times
  printf("\nExecution Time (microseconds): %9.2f\n\n", cpuTime);


  // clean up memory
  free(A);
  free(B);
  free(S);

  return 0;
}

