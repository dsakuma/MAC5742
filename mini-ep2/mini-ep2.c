#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define MAX_JUMPS 1000
int counter = 0;
char **arrayStringLake;
pthread_mutex_t lock;


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

void printLakeState(lakeSize){
  for(int i = 0; i < lakeSize; i++)
  {
     printf("%s\n", arrayStringLake[i]);
  }
}

void tryJump(long threadid){
  printf("O sapo %d tentando pular, no counter %d!\n", threadid, counter);
}

void *frog(void *threadid){
   long tid = threadid;

   while(counter < MAX_JUMPS){
     pthread_mutex_lock(&lock);
     usleep(rand()%100);
     if(counter < MAX_JUMPS){
       tryJump(threadid);
       counter++;
     };
     pthread_mutex_unlock(&lock);
   }
   pthread_exit(NULL);
}

void initializeThreads(numFrogs, lakeSize){
  if (pthread_mutex_init(&lock, NULL) != 0)
  {
      printf("\n mutex init failed\n");
      return;
  }

  pthread_t threads[lakeSize];
  int error_code;
  for(long t = 0;t < lakeSize; t++){
      if(t != numFrogs+1){
        printf("initializing thread %d\n", t);
        error_code = pthread_create(&threads[t], NULL, frog, (void *) t);
        if (error_code){
            printf("ERROR; return code from pthread_create() is %d\n", error_code);
            exit(-1);
        };
      }
  };

  pthread_mutex_destroy(&lock);
}

int main(int argc, char *argv[]){
  printf("=====Initializing=====\n");
  seedRand();

  int numFrogs = 2;
  int lakeSize = (numFrogs * 2) + 1;

  initializeStringLake(numFrogs, lakeSize);
  // printLakeState(lakeSize);
  initializeThreads(numFrogs, lakeSize);



  pthread_exit(NULL);
  printf("======Finished======\n");
};







// pthread_create(&threads[i], NULL, frog, (void *)(*(lake+i)));

//deixar arbitro pro fim


// dentro da função que é executada por threads, eu criei um loop (while) que executa enquanto o count não for grande o suficiente para que todos os sapos possam tentar pular um número satisfatório de vezes.
