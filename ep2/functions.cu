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

void print_vector(int* vector, int n_els, int D)
{
	printf("Printing vector...\n");
	for(int i=0; i<n_els; i++)
	{
		printf("%d ", vector[i]);
		if((i+1)%D == 0)
			printf("\n");
	}
	printf("\n");
}
