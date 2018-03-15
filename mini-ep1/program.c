#include <time.h>
#include <stdio.h>
#include <stdlib.h>

//https://stackoverflow.com/questions/22145037/matrix-multiplication-as-column-major

int columnmajor()
{
  #define M 700
  #define N 800
  #define L 700

  int A[M * L];
  int B[L * N];
  int res[M * N];

  int i, j, k;

  clock_t tic = clock();
  for (i = 0; i < M; i++) {
      for (j = 0; j < N; j++) {
          res[j * M + i] = 0;

          for (k = 0; k < L; k++) {
              res[j * M + i] += A[k * M + i] * B[j * L + k];
          }
      }
  }
  clock_t toc = clock();

  printf("Column-Major: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);

  return 0;
}

int rowmajor()
{
  #define M 700
  #define N 800
  #define L 700

  int A[M * L];
  int B[L * N];
  int res[M * N];

  int i, j, k;

  clock_t tic = clock();
  for (i = 0; i < M; i++) {
      for (j = 0; j < N; j++) {
          res[j + i * N] = 0;

          for (k = 0; k < L; k++) {
              res[j + i * N] += A[k + i * L] * B[j + k * N];
          }
      }
  }
  clock_t toc = clock();

  printf("Row-Major: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);

  return 0;
}

int main()
{
  columnmajor();
  rowmajor();
}
