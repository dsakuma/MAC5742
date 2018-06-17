#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_seq.h"


int* seqReduction(char filename[], int D)
{
  int* y;

  /* allocate memory */
  y = malloc(n_rows*sizeof(int));

  /* initialize with zero */
  for(int i=0; i<D*D; i++){
    y[i] = 0;
  }

  return y;
}
