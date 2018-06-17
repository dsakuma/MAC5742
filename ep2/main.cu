/**
Ana Martinazzo (7209231)
Daniel Sakuma (5619562)
EP2 - Redução em CUDA
**/

#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction_cuda.h"
#include "reduction_seq.h"

#define MATRIX_ORDER 3 // ordem das matrizes (quadradas)

int main(int argc, char *argv[])
{
    char* filename = argv[1];

    int *resultCuda = cudaReduction(filename, MATRIX_ORDER);
    int *resultSeq = seqReduction(filename, MATRIX_ORDER);

    print_vector(resultCuda, MATRIX_ORDER);
    print_vector(resultSeq, MATRIX_ORDER);

    return 0;
}
