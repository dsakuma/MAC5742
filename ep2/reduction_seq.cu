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

  /* allocate memory for y */
  y = (int*)malloc(n_els * sizeof(int));


  /* allocate memory for x */
  x = (int**)malloc(n_mat*sizeof(int));
  for(int i = 0; i<n_mat; i++)
  {
    x[i] = (int*)malloc(n_els * sizeof(int));
  }

  /* initialize with zero */
  for(int i=0; i<matrix_order; i++){
    for(int j=0; j<n_els; j++){
        x[i][j] = 0;
      }
  }

  print_matrix(x, n_mat, n_els);


  // /* initialize with zero */
  // for(int i=0; i<n_els; i++){
  //   y[i] = 0;
  // }

  printf("Finish reduction seq\n");
  return y;
}
