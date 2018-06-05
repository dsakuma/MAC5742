#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "sequential_multiply.h"
#include "openmp_multiply.h"
#include "pthread_multiply.h"

#include "utils.h"



int main()
{
   printf("Hello, main!\n");
   char filenameA[] = "matrix_a.txt";
   char filenameB[] = "matrix_b.txt";

   long long int n_rows_a = get_n_rows_or_cols("matrix_a.txt", "rows");
   long long int n_cols_a = get_n_rows_or_cols("matrix_a.txt", "cols");
   long long int n_cols_b = get_n_rows_or_cols("matrix_b.txt", "cols");

   double **matrix_a = allocate_memory_and_fill_matrix(filenameA);
   double **matrix_b = allocate_memory_and_fill_matrix(filenameB);
   double **matrix_c = allocate_memory_matrix(n_rows_a, n_cols_b);

   // sequentialMultiply(matrix_a, matrix_b, matrix_c, n_rows_a,n_cols_a , n_cols_b);
   // openmpMultiply(matrix_a, matrix_b, matrix_c, n_rows_a,n_cols_a , n_cols_b);
   pthreadMultiply(matrix_a, matrix_b, matrix_c, n_rows_a,n_cols_a , n_cols_b);

   // print_matrix(matrix_a, n_rows_a, n_cols_a);
   // print_matrix(matrix_b, n_rows_b, n_cols_b);
   // print_matrix(matrix_c, n_rows_a, n_cols_b);

   printf("Finished!\n");

   return 0;
}

// Falta:
// pthreads
// write result matrix
