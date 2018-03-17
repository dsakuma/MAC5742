#include <time.h>
#include <stdio.h>
#include <stdlib.h>


int rowmajor()
{
  #define n 500

  int a[n][n];

  clock_t tic = clock();
  int sum=0;
  for(int i=0;i<n;i++){
    for(int j=0;j<n;j++){
        sum=sum+a[i][j];
    }
  } 
  clock_t toc = clock();

  printf("Row-Major: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);

  return 0;
}


int columnmajor()
{
  #define n 500

  int a[n][n];

  clock_t tic = clock();
   int sum=0;
   for(int i=0;i<n;i++){
      for(int j=0;j<n;j++){
         sum=sum+a[j][i];
      }
   }  
  clock_t toc = clock();

  printf("Column-Major: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);

  return 0;
}



int main()
{
  printf("\n");
  columnmajor();
  rowmajor();
}
