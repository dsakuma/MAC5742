#include <time.h>
#include <stdio.h>
#include <stdlib.h>

#define max 100000000


int patterAllTrue()
{
  int sum = 0;
  clock_t tic = clock();
  for (int i = 0; i < max; i++) {
    if (i>-1) {
      sum = sum+1;
    }
  }
  clock_t toc = clock();
  printf("patterAllTrue: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);

  return 0;
}


int patterAllFalse()
{
  int sum = 0;
  clock_t tic = clock();
  for (int i = 0; i < max; i++) {
    if (i<-1) {
      sum = sum+1;
    }
  }
  clock_t toc = clock();
  printf("patterAllFalse: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);
  return 0;
}

int patternOnlyOdd()
{
  int sum = 0;
  clock_t tic = clock();
  for (int i = 0; i < max; i++) {
    if (i%2 == 1) {
      sum = sum+1;
    }
  }
  clock_t toc = clock();
  printf("patternOnlyOdd: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);

  return 0;
}

int patternRand()
{
  int sum = 0;
  clock_t tic = clock();
  int r;
  for (int i = 0; i < max; i++) {
    r = rand();
    if (r%2 == 1) {
      sum = sum+1;
    }
  }
  clock_t toc = clock();
  printf("patternRand: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);

  return 0;
}

int patternFirstHalfTrueLastHalfFalse()
{
  int sum = 0;
  clock_t tic = clock();
  for (int i = 0; i < max; i++) {
    if (i < max/2) {
      sum = sum+1;
    }
  }
  clock_t toc = clock();
  printf("patternFirstHalfTrueLastHalfFalse: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);

  return 0;
}


int main()
{
  printf("\n");
  // patterAllTrue();
  // patterAllFalse();
  patternFirstHalfTrueLastHalfFalse();
  patternOnlyOdd();
  patternRand();
}
