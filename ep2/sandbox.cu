#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include "functions.h"
#include "reduction.h"

#define D 3 // ordem das matrizes (quadradas)

int main(int argc, char *argv[])
{
    char* filename = argv[1];
    int n_els = D*D;

    int *result = cudaReduction(filename, D);

    print_vector(result, n_els, D);

    return 0;
}
