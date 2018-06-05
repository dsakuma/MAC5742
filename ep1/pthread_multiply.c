#include <stdio.h>
#include <stdlib.h>
#include <time.h>
// #include <string.h>
#include "sequential_multiply.h"
#include <pthread.h>

struct thread_data {
 int thread_id;
 double **matrix_a;
};


void * worker( void *threadarg )
{
  struct thread_data *my_data;
  my_data = (struct thread_data *) threadarg;
  int taskid = my_data->thread_id;
  double **matrix_a = my_data->matrix_a;
  printf("taskid->%d\n", taskid);



  return NULL;
}

double pthreadMultiply(double** matrixA, double** matrixB, double** matrixC, int n_rows_a, int n_cols_a, int n_cols_b)
{
  int i;
  printf("Pthread multiply matrix...\n");
  int num_threads = 2;
  struct thread_data thread_data_array[num_threads];

  pthread_t * threads;
  threads = (pthread_t *) malloc( num_threads * sizeof(pthread_t) );

  for ( i = 0; i < num_threads; ++i ) {
    printf("thread->%d\n", i);
    thread_data_array[i].thread_id = i;
    thread_data_array[i].matrix_a = matrixA;

    pthread_create( &threads[i], NULL, worker, (void *)&thread_data_array[i] );
  }

  for ( i = 0; i < num_threads; ++i ) {
    pthread_join( threads[i], NULL );
  }
  double elapsed = 0;
  return elapsed;
}
