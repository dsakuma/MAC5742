#include <stdio.h>
#include <stdlib.h>

// #define BLOCK_SIZE 1024*1024*256

int main()
{
   printf("Hello, main!\n");

   /* initialize matrix a */
   double **matrix_a;

   int n_rows_a = 2;
   int n_cols_a = 2;

   /* allocate memory */
   matrix_a = malloc(n_rows_a*sizeof(double*));
   for(int i = 0; i<n_cols_a; i++)
   {
     matrix_a[i] = malloc(n_rows_a*sizeof(double*));
   }

   /* set matrix a to zero */
   for(int i=0; i<n_rows_a; i++){
     for(int j=0; j<n_cols_a; j++){
         matrix_a[i][j] = 0.0;
       }
   }

   /* print matrix a */
   for(int i=0; i<n_rows_a; i++){
     for(int j=0; j<n_cols_a; j++){
         printf("%f", matrix_a[i][j]);
       }
   }

   return 0;
}
