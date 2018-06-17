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
  int n_els = D*D;

  /* allocate memory */
  y = malloc(n_els*sizeof(int*);

  /* initialize with zero */
  for(int i=0; i<n_els; i++){
    y[i] = 0;
  }

  return y;
}
