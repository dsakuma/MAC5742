#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

double sequentialMultiply(double** matrixA, double** matrixB, double** matrixC, int dimension)
{
  clock_t tic = clock();
	for(int i=0; i<dimension; i++){
		for(int j=0; j<dimension; j++){
			for(int k=0; k<dimension; k++){
				matrixC[i][j] += matrixA[i][k] * matrixB[k][j];
			}
		}
	}
  clock_t toc = clock();
  double elapsed = (double)(toc - tic) / CLOCKS_PER_SEC;
  printf("sequentialMultiply: %f seconds\n", elapsed);
	return elapsed;
}

double parallelMultiply(double** matrixA, double** matrixB, double** matrixC, int dimension)
{
  clock_t tic = clock();
	#pragma omp parallel for
	for(int i=0; i<dimension; i++){
		for(int j=0; j<dimension; j++){
			for(int k=0; k<dimension; k++){
				matrixC[i][j] += matrixA[i][k] * matrixB[k][j];
			}
		}
	}
  clock_t toc = clock();
  double elapsed = (double)(toc - tic) / CLOCKS_PER_SEC;
  printf("parallelMultiply: %f seconds\n", elapsed);
	return elapsed;
}

// double openMpMultiply() {}

// double pthreadMultiply() {}

double ** allocate_memory_matrix(long long int n_rows, long long int n_cols)
{
  double** matrix;

  /* allocate memory */
  matrix = malloc(n_rows*sizeof(double*));
  for(int i = 0; i<n_cols; i++)
  {
    matrix[i] = malloc(n_rows*sizeof(double*));
  }

  return matrix;
}

double ** allocate_memory_and_fill_matrix(char filename[], long long int n_rows, long long int n_cols)
{
  double** matrix = allocate_memory_matrix(n_rows, n_cols);

  /* initialize with zero */
  for(int i=0; i<n_rows; i++){
    for(int j=0; j<n_cols; j++){
        matrix[i][j] = 0;
      }
  }

  /* read matrix from file */
  if(strcmp(filename, "") != 0)
  {
    for(int i=0; i<n_rows; i++){
      for(int j=0; j<n_cols; j++){
          matrix[i][j] = 2.0;
        }
    }
  }
  return matrix;
}

void print_matrix(double** matrix, int n_rows, int n_cols)
{
  printf("Printing matrix...\n");
  for(int i=0; i<n_rows; i++){
    for(int j=0; j<n_cols; j++){
        printf("%f\n", matrix[i][j]);
      }
  }
}

int main()
{
   printf("Hello, main!\n");

   /* initialize matrix a */
   long long int n_rows_a = 2;
   long long int n_cols_a = 2;
   long long int n_rows_b = 2;
   long long int n_cols_b = 2;
   long long int n_rows_c = 2;
   long long int n_cols_c = 2;

   double **matrix_a = allocate_memory_and_fill_matrix("matrix_a.txt", n_rows_a, n_cols_a);
   double **matrix_b = allocate_memory_and_fill_matrix("matrix_b.txt", n_rows_b, n_cols_b);
   double **matrix_c = allocate_memory_and_fill_matrix("", n_rows_c, n_cols_c);

   // sequentialMultiply(matrix_a, matrix_b, matrix_c, 2);
   parallelMultiply(matrix_a, matrix_b, matrix_c, 2);

   print_matrix(matrix_a, n_rows_a, n_cols_a);
   print_matrix(matrix_b, n_rows_b, n_cols_b);
   print_matrix(matrix_c, n_rows_c, n_cols_c);



   return 0;
}

// Falta:
// Ler do arquivo
// 3 tipos de multiply
