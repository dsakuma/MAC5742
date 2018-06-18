#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "functions.h"

#define MATRIX_ORDER 3 // ordem das matrizes (quadradas)

// int randMToN(int M, int N)
// {
//     return M + (rand() / ( RAND_MAX / (N-M) ) ) ;
// }
//
// void write_matrix_list(int n_mat, char filename[])
// {
//   /* open file */
//   FILE *f = fopen(filename, "w");
//   if (f == NULL)
//   {
//       printf("Error opening file!\n");
//       exit(1);
//   }
//   /* print num matrizes */
//   fprintf(f, "%d\n", n_mat);
//   fprintf(f, "***\n");
//   /* write matrix */
//   for(int n=1; n<=n_mat; n++)
//   {
//     for(int i=1; i<=MATRIX_ORDER; i++)
//     {
//         fprintf(f, "%d %d %d\n", randMToN(0,10), randMToN(0,10), randMToN(0,10));
//     }
//     fprintf(f, "***\n");
//   }
//   /* close file */
//   fclose(f);
// }

int main(int argc, char **argv)
{
   printf("Generating matrix list!\n");
   if(argc<=2) {
      printf("Usage: %s <qtd_matrizes> <caminho_list_matrizes>\n", argv[0]);
      exit(1);
   }
   int n_mat = atoi(argv[1]);
   char* filename = argv[2];
   write_matrix_list(n_mat, filename, MATRIX_ORDER);
   return 0;
}
