#include <stdio.h>
#include <stdlib.h>
#include <string.h>

double randZeroToOne()
{
    return rand() / (RAND_MAX + 1.);
}

double randMToN(double M, double N)
{
    return M + (rand() / ( RAND_MAX / (N-M) ) ) ;
}

int main()
{
   // printf() displays the string inside quotation
   printf("%f\n", randMToN(0,1));
   printf("%f\n", randMToN(0,10));
   printf("%f\n", randMToN(0,10));
   printf("%f\n", randMToN(0,10));
   printf("%f\n", randMToN(0,10));

   if(0.0 != 0){
     printf("its equals\n");
   }

   if(strcmp("example1", "example2") == 0)
   {
     printf("same string");
   }

   return 0;
}
