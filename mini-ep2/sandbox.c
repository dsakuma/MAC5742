#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_STONES 5
#define NUM_EACH_FROG_TYPE 2
#define NUM_THREADS 4

struct frog
{
    int p;//position
    char type;
};

struct frog lake[(NUM_EACH_FROG_TYPE*2)+1];

void testRand(){
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
}

void testArray(){
  int _lake[10];
  for(int i=0; i < 10; i++){
    _lake[i] = 0;
  }

  for(int i=0; i < 10; i++){
    printf("%d\n", _lake[i]);
  }
}

void testInitializeLake(){
   for(int i = 0; i < 5; i++)
   {
      lake[i].p = 0;
      lake[i].type = 'M';
   }

   for(int i = 0; i < 5; i++)
   {
      printf("%c-%d\n", lake[i].type, lake[i].p);
   }
}




int main(int argc, char *argv[]){
  printf("Test programm started...\n");
  // testRand();
  // testArray();
  testInitializeLake();
  printf("Test programm finished.\n");
};



// pthread_create(&threads[i], NULL, frog, (void *)(*(lake+i)));

//deixar arbitro pro fim


// dentro da função que é executada por threads, eu criei um loop (while) que executa enquanto o count não for grande o suficiente para que todos os sapos possam tentar pular um número satisfatório de vezes.
