#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// #include <emmintrin.h>
// #include <smmintrin.h>

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


// double sequentialMultiply(double** matrixA, double** matrixB, double** matrixC,
//   long long int n_rows_a, long long int n_cols_a, long long int n_cols_b) {
//     printf("Sequential multiply matrix...\n");
//     struct timeval tstart, tend;
//     double exectime;
//     gettimeofday( &tstart, NULL );
//
//     int i, j, k;
//     __m128i vA, vB, vR;
//     for(i = 0; i < n_rows_a; ++i) {
//         for(k = 0; k < n_cols_b; ++k) {
//             vA = _mm_set1_epi32(matrixA[i][k]);
//             for(j = 0; j < n_cols_a; j += 4) {
//                 //result[i][j] += mat1[i][k] * mat2[k][j];
//                 vB = _mm_loadu_si128((__m128i*)&matrixB[k][j]);
//                 vR = _mm_loadu_si128((__m128i*)&matrixC[i][j]);
//                 vR = _mm_add_epi32(vR, _mm_mullo_epi32(vA, vB));
//                 _mm_storeu_si128((__m128i*)&matrixC[i][j], vR);
//             }
//         }
//     }
//     gettimeofday( &tend, NULL );
//     exectime = (tend.tv_sec - tstart.tv_sec) * 1000.0; // sec to ms
//     exectime += (tend.tv_usec - tstart.tv_usec) / 1000.0; // us to ms
//     printf( "Execution time:%.3lf sec\n", exectime/1000.0);
//     return exectime;
// }
