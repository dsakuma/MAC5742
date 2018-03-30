#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>


int counter = 0;
char **arrayStringLake;


void initializeStringLake(int numFrogs, int lakeSize){
  arrayStringLake = malloc(sizeof(char*)*lakeSize);
  for(int i=0; i < lakeSize;i++){
    arrayStringLake[i] = malloc(256*sizeof(char));
  }
  for(int i = 0; i < numFrogs; i++)
  {
    sprintf(arrayStringLake[i], "%c-%d", 'M', i+1);
    sprintf(arrayStringLake[lakeSize-1-i], "%c-%d", 'F', i+1);
  }
  strcpy(arrayStringLake[numFrogs], "_");
}

void seedRand() {
  int seed = time(NULL);
  srand(seed);
}


int main(int argc, char *argv[]){
  printf("=====Initializing=====\n");
  seedRand();

  int numFrogs = 2;
  int lakeSize = (numFrogs * 2) + 1;

  initializeStringLake(numFrogs, lakeSize);
  for(int i = 0; i < lakeSize; i++)
  {
     printf("%s\n", arrayStringLake[i]);
  }

  strcpy(arrayStringLake[0], "M-1");
  printf("======Finished======\n");
};







// pthread_create(&threads[i], NULL, frog, (void *)(*(lake+i)));

//deixar arbitro pro fim


// dentro da função que é executada por threads, eu criei um loop (while) que executa enquanto o count não for grande o suficiente para que todos os sapos possam tentar pular um número satisfatório de vezes.
