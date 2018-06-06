#include <stdio.h>
// #include <stdlib.h>
// #include <time.h>
#include <sys/time.h>
// #include <string.h>
#include "sequential_multiply.h"

double sequentialMultiply(double** matrixA, double** matrixB, double** matrixC,
  long long int n_rows_a, long long int n_cols_a, long long int n_cols_b)
{
  printf("Sequential multiply matrix...\n");
  struct timeval tstart, tend;
  double exectime;
  gettimeofday( &tstart, NULL );
  // clock_t tic = clock();
	for(int i=0; i<n_rows_a; i++){
		for(int j=0; j<n_cols_b; j++){
			for(int k=0; k<n_cols_a; k++){
				matrixC[i][j] += matrixA[i][k] * matrixB[k][j];
			}
		}
	}
  gettimeofday( &tend, NULL );
  // clock_t toc = clock();
  // double elapsed = (double)(toc - tic) / CLOCKS_PER_SEC;
  // printf("sequentialMultiply: %f seconds\n", elapsed);
  exectime = (tend.tv_sec - tstart.tv_sec) * 1000.0; // sec to ms
  exectime += (tend.tv_usec - tstart.tv_usec) / 1000.0; // us to ms
  printf( "Execution time:%.3lf sec\n", exectime/1000.0);
	return exectime;
}
