#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_seq.h"


int* reduction_seq(char filename[], int matrix_order)
{
  printf("Start reduction seq\n");
  int **x;
  int* y;
  int n_els = matrix_order*matrix_order;
  int n_mat = get_n_mat(filename);
  int val1, val2, val3;
  FILE *fp;

  /* allocate memory for y */
  y = (int*)malloc(n_els * sizeof(int));


  /* allocate memory for x */
  x = (int**)malloc(n_els*sizeof(int*));
  for(int i = 0; i<n_els; i++)
  {
    x[i] = (int*)malloc(n_mat * sizeof(int));
  }

  /* read matrix list */
  fp = fopen(filename, "r");
  fscanf(fp, "%*s");
  fscanf(fp, "%*s");
  for(int i=0; i < n_mat; i++)
  {
    for(int j=0; j < matrix_order; j++)
    {
        // printf("n_mat->%d, m_order->%d\n", i, j);

        fscanf(fp, "%d %d %d", &val1, &val2, &val3);
        // printf("%d %d %d\n", val1, val2, val3);
        // printf("place: %d %d %d %d\n", matrix_order*j, matrix_order*j+1, matrix_order*j+2, i);
        x[matrix_order*j][i] = val1;
        x[matrix_order*j+1][i] = val2;
        x[matrix_order*j+2][i] = val3;
        // printf("success\n");
    }
    fscanf(fp, "%*s");  // skip line
  }
  fclose(fp);

  /* initialize y with first matrix */
  for(int j=0; j < matrix_order; j++)
  {
      fscanf(fp, "%d %d %d", &val1, &val2, &val3);
      y[matrix_order*j] = val1;
      y[matrix_order*j+1] = val2;
      y[matrix_order*j+2] = val3;
      // printf("success\n");
  }
  fscanf(fp, "%*s");  // skip line

  /* sequential reduction */
  // for(int i=1; i < n_mat; i++)
  // {
  //   for(int j=0; j < matrix_order; j++)
  //   {
  //       fscanf(fp, "%d %d %d", &val1, &val2, &val3);
  //       x[matrix_order*j][i] = val1;
  //       x[matrix_order*j+1][i] = val2;
  //       x[matrix_order*j+2][i] = val3;
  //       // printf("success\n");
  //   }
  //   fscanf(fp, "%*s");  // skip line
  // }

  // print_matrix(x, n_els, n_mat);



  printf("Finish reduction seq\n");
  return y;
}
