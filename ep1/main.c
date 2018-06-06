#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "sequential_multiply.h"
#include "openmp_multiply.h"
#include "pthread_multiply.h"

#include "functions.h"

int main(int argc, char* argv[])
{
   printf("Hello, main!\n");

   if (argc != 5)
   {
       printf("Usage: %s <implementação> <caminho_matr_A> <caminho_matr_B> <caminho_matr_C>\n", argv[0]);
       return 1;
   }

   char* implementation = argv[1];
   char* filenameA = argv[2];
   char* filenameB = argv[3];
   char* filenameC = argv[4];

   long long int n_rows_a = get_n_rows_or_cols(filenameA, "rows");
   long long int n_cols_a = get_n_rows_or_cols(filenameA, "cols");
   long long int n_cols_b = get_n_rows_or_cols(filenameB, "cols");

   double **matrix_a = allocate_memory_and_fill_matrix(filenameA);
   double **matrix_b = allocate_memory_and_fill_matrix(filenameB);
   double **matrix_c = allocate_memory_matrix(n_rows_a, n_cols_b);

   switch (*implementation)
   {
     case 's':
       sequentialMultiply(matrix_a, matrix_b, matrix_c, n_rows_a,n_cols_a , n_cols_b);
     break;

     case 'o':
      openmpMultiply(matrix_a, matrix_b, matrix_c, n_rows_a,n_cols_a , n_cols_b);
     break;

     case 'p':
       pthreadMultiply(matrix_a, matrix_b, matrix_c, n_rows_a,n_cols_a , n_cols_b);
     break;

     default:
       printf("Invalid implementation\n");
       return 1;
   }

   write_matrix(matrix_c, n_rows_a, n_cols_b, filenameC);

   printf("Finished!\n");
   return 0;
}
