#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 8
#define NUM_OPS 10000000
pthread_mutex_t lock;

void *simpleCalcs(void *threadid){
   printf("initializing thread %d\n", threadid);
   long tid = threadid;
   int counter = 0;
   int sum = 0;
   int a = 0;
   int b = 0;
   int c = 0;
   while(counter < NUM_OPS){
     // printf("running %d\n", counter);
     a = rand();
     b = rand();
     c = a + b;
     sum = sum + c;
     counter++;
   };
};

void initializeThreads(){
  if (pthread_mutex_init(&lock, NULL) != 0)
  {
      printf("\n mutex init failed\n");
      return;
  }
  pthread_t threads[NUM_THREADS];
  int error_code;
  for(long t = 0;t < NUM_THREADS; t++){
      error_code = pthread_create(&threads[t], NULL, simpleCalcs, (void *) t);
      if (error_code){
          printf("ERROR; return code from pthread_create() is %d\n", error_code);
          exit(-1);
      };
  };
  for (int i = 0; i < NUM_THREADS; i++)
    pthread_join(threads[i], NULL);

  pthread_mutex_destroy(&lock);
};

int main(){
  clock_t tic = clock();
  initializeThreads();
  clock_t toc = clock();
  printf("Time: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);
  return 0;
};
