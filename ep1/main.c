#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

void print_matrix(double** matrix, int n_rows, int n_cols)
{
  printf("Printing matrix...\n");
  for(int i=0; i<n_rows; i++){
    for(int j=0; j<n_cols; j++){
        printf("%f\n", matrix[i][j]);
      }
  }
}

double sequentialMultiply(double** matrixA, double** matrixB, double** matrixC, int n_rows_a, int n_cols_a, int n_cols_b)
{
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

double parallelMultiply(double** matrixA, double** matrixB, double** matrixC, int n_rows_a, int n_cols_a, int n_cols_b)
{
  clock_t tic = clock();
	#pragma omp parallel for
	for(int i=0; i<n_rows_a; i++){
		for(int j=0; j<n_cols_b; j++){
			for(int k=0; k<n_cols_a; k++){
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
  for(int i = 0; i<n_rows; i++)
  {
    matrix[i] = malloc(n_cols*sizeof(double*));
  }

  printf ("%lld, %lld\n\n'", n_rows, n_cols);

  /* initialize with zero */
  for(int i=0; i<n_rows; i++){
    for(int j=0; j<n_cols; j++){
        matrix[i][j] = 0;
      }
  }

  return matrix;
}

double ** allocate_memory_and_fill_matrix(char filename[])
{
  int r;
  long long int i;
  long long int j;
  double v;
  long long int n_rows = 0;
  long long int n_cols = 0;

  FILE *fp;
  fp = fopen(filename, "r");

  if (fp == NULL)
  {
      printf ("Error opening the file\n\n'");
      exit(EXIT_FAILURE);
  }

  r = fscanf(fp, "%lld %lld", &n_rows, &n_cols);

  double** matrix = allocate_memory_matrix(n_rows, n_cols);

  /* read matrix from file */
  r = fscanf(fp, "%lld %lld %lf", &i, &j, &v);
  matrix[i-1][j-1] = v;
  while (r != EOF)
  {
      // printf("i: %lld | j: %lld | v: %lf\n", i, j, v);
      matrix[i-1][j-1] = v;
      r = fscanf(fp, "%lld %lld %lf", &i, &j, &v);
  }
  fclose(fp);

  print_matrix(matrix, n_rows, n_cols);
  return matrix;
}

long long int get_n_rows_or_cols(char filename[], char type[])
{
  long long int n_rows;
  long long int n_cols;

  FILE *fp;
  fp = fopen(filename, "r");

  if (fp == NULL)
  {
      printf ("Error opening the file\n\n'");
      exit(EXIT_FAILURE);
  }

  fscanf(fp, "%lld %lld", &n_rows, &n_cols);
  fclose(fp);
  if(strcmp(type, "rows") == 0)
    return n_rows;
  else
    return n_cols;
}

double ** allocate_memory_result_matrix(char filenameA[], char filenameB[])
{
  long long int n_rows = get_n_rows_or_cols("matrix_a.txt", "rows");
  long long int n_cols = get_n_rows_or_cols("matrix_b.txt", "cols");

  double** matrix = allocate_memory_matrix(n_rows, n_cols);

  // print_matrix(matrix, n_rows, n_cols);
  return matrix;
}



int main()
{
   printf("Hello, main!\n");
   char filenameA[] = "matrix_a.txt";
   char filenameB[] = "matrix_b.txt";


   double **matrix_a = allocate_memory_and_fill_matrix(filenameA);
   double **matrix_b = allocate_memory_and_fill_matrix(filenameB);
   double **matrix_c = allocate_memory_result_matrix(filenameA, filenameB);

   long long int n_rows_a = get_n_rows_or_cols("matrix_a.txt", "rows");
   long long int n_cols_a = get_n_rows_or_cols("matrix_a.txt", "cols");
   long long int n_cols_b = get_n_rows_or_cols("matrix_b.txt", "cols");

   sequentialMultiply(matrix_a, matrix_b, matrix_c, n_rows_a,n_cols_a , n_cols_b);
   // parallelMultiply(matrix_a, matrix_b, matrix_c, n_rows_a,n_cols_a , n_cols_b);

   // print_matrix(matrix_a, n_rows_a, n_cols_a);
   // print_matrix(matrix_b, n_rows_b, n_cols_b);
   print_matrix(matrix_c, n_rows_a, n_cols_b);



   return 0;
}

// Falta:
// multiply qualquer dimensao (param type)
// 3 tipos de multiply
// write result matrix
