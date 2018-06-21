#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>



int main(int argc, char *argv[])
{
    int* x;
    int* y;
    int* tmp;

    printf("The value of x is: %p\n", (void *) x);
    printf("The value of y is: %p\n", (void *) y);
    printf("The value of tmp is: %p\n", (void *) tmp);

    return 0;
}
