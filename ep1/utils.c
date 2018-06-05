#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "utils.h"

void print_matrix(double** matrix, int n_rows, int n_cols)
{
  printf("Printing matrix...\n");
  for(int i=0; i<n_rows; i++){
    for(int j=0; j<n_cols; j++){
        printf("%f\n", matrix[i][j]);
      }
  }
}

double ** allocate_memory_matrix(long long int n_rows, long long int n_cols)
{
  double** matrix;

  /* allocate memory */
  matrix = malloc(n_rows*sizeof(double*));
  for(int i = 0; i<n_rows; i++)
  {
    matrix[i] = malloc(n_cols*sizeof(double*));
  }

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

  // print_matrix(matrix, n_rows, n_cols);
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
