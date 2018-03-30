#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>


#define NUM_STONES 5
#define NUM_EACH_FROG_TYPE 2
#define NUM_THREADS 4
int counter = 0;


struct body
{
    double p[3];//position
    char type;
};

struct body bodies[(NUM_EACH_FROG_TYPE*2)+1];


// struct thread_data{
//     int	thread_id;
//     int type;
//     int position;
// };
//
// struct thread_data thread_data_array[NUM_THREADS];


void *frog(void *threadid){
  long tid = threadid;
  int i;
  for(i = 0; i< 10; i++){
    usleep(rand()%100);
    printf("O sapo %ld tentando pular!\n", tid);
  }
  pthread_exit(NULL);
};

void seedRand() {
  // Seeding the random number generator used by rand()
  int seed = time(NULL);
  srand(seed);
}


int main(int argc, char *argv[]){
  printf("Initializing...\n");
  seedRand();

  // Initialializng lake
  int lagoa[NUM_STONES];

  // Initializing threads
  pthread_t threads[2];
  int error_code;
  // long t;
  for(long t = 0;t < 1; t++){
      error_code = pthread_create(&threads[t], NULL, frog, (void *) t);
      if (error_code){
          printf("ERROR; return code from pthread_create() is %d\n", error_code);
          exit(-1);
      };
  };

  // Finishing threads
  pthread_exit(NULL);
  printf("Finished.\n");
};



// pthread_create(&threads[i], NULL, frog, (void *)(*(lake+i)));

//deixar arbitro pro fim


// dentro da função que é executada por threads, eu criei um loop (while) que executa enquanto o count não for grande o suficiente para que todos os sapos possam tentar pular um número satisfatório de vezes.
