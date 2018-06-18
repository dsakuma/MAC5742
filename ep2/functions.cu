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
