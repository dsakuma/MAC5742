#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>


void *sapo(void *threadid){

};


int main(int argc, char *argv[]){
  int i;
  int seed = time(NULL);
  srand(seed);
  printf("seed %d\n", seed);
  int sleepTime;
  for(i=0; i<10; i++){
    sleepTime = rand()%1000;
    usleep(sleepTime);
    printf("rand %d\n", sleepTime);
    printf("%d\n", i);
  };

};



// pthread_create(&threads[i], NULL, frog, (void *)(*(lake+i)));

//deixar arbitro pro fim


// dentro da função que é executada por threads, eu criei um loop (while) que executa enquanto o count não for grande o suficiente para que todos os sapos possam tentar pular um número satisfatório de vezes.
