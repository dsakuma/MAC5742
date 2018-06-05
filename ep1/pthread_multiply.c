#include <stdio.h>
// #include <stdlib.h>
#include <time.h>
// #include <string.h>
#include "sequential_multiply.h"

double pthreadMultiply(double** matrixA, double** matrixB, double** matrixC, int n_rows_a, int n_cols_a, int n_cols_b)
{
  printf("Pthread multiply matrix...\n");
  clock_t tic = clock();
	for(int i=0; i<n_rows_a; i++){
		for(int j=0; j<n_cols_b; j++){
			for(int k=0; k<n_cols_a; k++){
				matrixC[i][j] += matrixA[i][k] * matrixB[k][j];
			}
		}
	}
  clock_t toc = clock();
  double elapsed = (double)(toc - tic) / CLOCKS_PER_SEC;
  printf("pthreadlMultiply: %f seconds\n", elapsed);
	return elapsed;
}
