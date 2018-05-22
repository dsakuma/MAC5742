#include <stdio.h>
#include <stdlib.h>
#include <string.h>

double randZeroToOne()
{
    return rand() / (RAND_MAX + 1.);
}

double randMToN(double M, double N)
{
    return M + (rand() / ( RAND_MAX / (N-M) ) ) ;
}

void write_matrix(int n_rows, int n_cols, char filename[])
{
  printf("Writing matrix...\n");

  /* open file */
  FILE *f = fopen(filename, "w");
  if (f == NULL)
  {
      printf("Error opening file!\n");
      exit(1);
  }
  /* print qty rows and cols */
  fprintf(f, "%d %d\n", n_rows, n_cols);

  /* write matrix */
  for(int i=1; i<=n_rows; i++)
  {
    for(int j=1; j<=n_cols; j++)
    {
      double val = randMToN(0,10);
      if (val >= 0.1)
        fprintf(f, "%d %d %.1f\n", i, j, val);
    }
  }
  fclose(f);
}

int main(int argc, char **argv)
{
   printf("Generating matrix A and B!\n");
   if(argc<=4) {
      printf("You did not feed me arguments, I will die now :( ...");
      exit(1);
   }
   int n_rows_a = atoi(argv[1]);
   int n_cols_a = atoi(argv[2]);
   int n_rows_b = atoi(argv[3]);
   int n_cols_b = atoi(argv[4]);
   write_matrix(n_rows_a, n_cols_a, "matrix_a.txt");
   write_matrix(n_rows_b, n_cols_b, "matrix_b.txt");
   return 0;
}
