#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_seq.h"


int* reduction_seq(char filename[], int D)
{
  int* y;
  int n_els = D*D;
  int n_mat = get_n_mat(filename);

  printf("n_mat: %d", n_mat);

  /* allocate memory */
  y = (int*)malloc(n_els * sizeof(int));

  /* initialize with zero */
  for(int i=0; i<n_els; i++){
    y[i] = 0;
  }

  return y;
}
