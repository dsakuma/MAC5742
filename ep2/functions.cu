#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "functions.h"

void print_matrix(int** matrix, int n_rows, int n_cols)
{
	printf("Printing matrix...\n");
	for(int i=0; i<n_rows; i++)
	{
		for(int j=0; j<n_cols; j++)
		{
			printf("%d ", matrix[i][j]);
		}
		printf("\n");
	}
}

void print_vector(int* vector, int D)
{
	int n_els = D*D;
	printf("Printing vector...\n");
	for(int i=0; i<n_els; i++)
	{
		printf("%d ", vector[i]);
		if((i+1)%D == 0)
			printf("\n");
	}
	printf("\n");
}

int get_n_mat(const char filename[])
{
  int n_mat;

  FILE *fp;
  fp = fopen(filename, "r");

  if (fp == NULL)
  {
      printf ("Error opening the file\n\n'");
      exit(EXIT_FAILURE);
  }

  fscanf(fp, "%d", &n_mat);
  fclose(fp);
  return n_mat;
}

int assert_vector(int* a, int* b, int size)
{
  for(int i=0; i<size; i++){
    if(a[i] != b[i])
      return 1;
  }
  return 0;
}

void print_test_result(const char description[], int result)
{
    if(result == 1){
      printf("Teste: %s [Falhou]\n", description);
      return;
    }
    printf("Teste: %s [OK]\n", description);
    return;
}

int randMToN(int M, int N)
{
    return M + (rand() / ( RAND_MAX / (N-M) ) ) ;
}

void write_matrix_list(int n_mat, char filename[], int matrix_order)
{
  /* open file */
  FILE *f = fopen(filename, "w");
  if (f == NULL)
  {
      printf("Error opening file!\n");
      exit(1);
  }
  /* print num matrizes */
  fprintf(f, "%d\n", n_mat);
  fprintf(f, "***\n");
  /* write matrix */
  for(int n=1; n<=n_mat; n++)
  {
    for(int i=1; i<=matrix_order; i++)
    {
        fprintf(f, "%d %d %d\n", randMToN(0,10), randMToN(0,10), randMToN(0,10));
    }
    fprintf(f, "***\n");
  }
  /* close file */
  fclose(f);
}
