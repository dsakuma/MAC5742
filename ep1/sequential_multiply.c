#include <stdio.h>
// #include <stdlib.h>
#include <time.h>
// #include <string.h>
#include "sequential_multiply.h"

double sequentialMultiply(double** matrixA, double** matrixB, double** matrixC,
  long long int n_rows_a, long long int n_cols_a, long long int n_cols_b)
{
  printf("Sequential multiply matrix...\n");
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
  printf("sequentialMultiply: %f seconds\n", elapsed);
	return elapsed;
}
