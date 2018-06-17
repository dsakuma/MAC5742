#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MATRIX_ORDER 3 // ordem das matrizes (quadradas)

double randZeroToOne()
{
    return rand() / (RAND_MAX + 1.);
}

int randMToN(int M, int N)
{
    return M + (rand() / ( RAND_MAX / (N-M) ) ) ;
}

// void write_matrix(int n_rows, int n_cols, char filename[])
// {
//   /* open file */
//   FILE *f = fopen(filename, "w");
//   if (f == NULL)
//   {
//       printf("Error opening file!\n");
//       exit(1);
//   }
//   /* print qty rows and cols */
//   fprintf(f, "%d %d\n", n_rows, n_cols);
//
//   /* write matrix */
//   for(int i=1; i<=n_rows; i++)
//   {
//     for(int j=1; j<=n_cols; j++)
//     {
//       double val = randMToN(0,10);
//       if (val >= 0.1)
//         fprintf(f, "%d %d %.1f\n", i, j, val);
//     }
//   }
//   fclose(f);
// }

// void write_matrix()

void write_matrix_list(int n_matrix, char filename[])
{
  /* open file */
  FILE *f = fopen(filename, "w");
  if (f == NULL)
  {
      printf("Error opening file!\n");
      exit(1);
  }
  /* print num matrizes */
  fprintf(f, "%d\n", n_matrix);
  fprintf(f, "***");
  /* write matrix */
  for(int n=0; n<=n_matrix; n++)
  {
    for(int i=1; i<=MATRIX_ORDER; i++)
    {
        fprintf(f, "%d %d %d\n", randMToN(0,10), randMToN(0,10), randMToN(0,10));
    }
    fprintf(f, "***");
  }
  /* close file */
  fclose(f);
}

int main(int argc, char **argv)
{
   printf("Generating matrix list!\n");
   if(argc<=2) {
      printf("Usage: %s <qtd_matrizes> <caminho_list_matrizes>\n", argv[0]);
      exit(1);
   }
   int n_matrix = atoi(argv[1]);
   char* filename = argv[2];
   write_matrix_list(n_matrix, filename);
   return 0;
}
