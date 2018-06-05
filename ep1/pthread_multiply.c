#include <stdio.h>
#include <stdlib.h>
#include <time.h>
// #include <string.h>
#include "sequential_multiply.h"
#include <pthread.h>

int num_threads = 1;

struct thread_data {
 int thread_id;
 double **matrix_a;
 double **matrix_b;
 double **matrix_c;
};

void * worker( void *threadarg )
{
  struct thread_data *my_data;
  my_data = (struct thread_data *) threadarg;
  int tid = my_data->thread_id;
  double **matrix_a = my_data->matrix_a;
  double **matrix_b = my_data->matrix_b;
  double **matrix_c = my_data->matrix_c;

  printf("tid->%d\n", tid);

  int i, j, k, portion_size, row_start, row_end;
  double sum;
  int size = 2;

  portion_size = size / num_threads;
  row_start = tid * portion_size;
  row_end = (tid+1) * portion_size;

  // printf("portion_size->%d\n", portion_size);

  for (i = row_start; i < row_end; ++i) { // hold row index of 'matrix1'
  for (j = 0; j < size; ++j) { // hold column index of 'matrix2'
    sum = 0; // hold value of a cell
    /* one pass to sum the multiplications of corresponding cells
 in the row vector and column vector. */
    for (k = 0; k < size; ++k) {
        sum += matrix_a[ i ][ k ] * matrix_b[ k ][ j ];
    }
    matrix_c[ i ][ j ] = sum;
  }
}


  return NULL;
}

double pthreadMultiply(double** matrixA, double** matrixB, double** matrixC, int n_rows_a, int n_cols_a, int n_cols_b)
{
  int i;
  printf("Pthread multiply matrix...\n");
  struct thread_data thread_data_array[num_threads];

  pthread_t * threads;
  threads = (pthread_t *) malloc( num_threads * sizeof(pthread_t) );

  for ( i = 0; i < num_threads; ++i ) {
    printf("thread->%d\n", i);
    thread_data_array[i].thread_id = i;
    thread_data_array[i].matrix_a = matrixA;
    thread_data_array[i].matrix_b = matrixB;
    thread_data_array[i].matrix_c = matrixC;

    pthread_create( &threads[i], NULL, worker, (void *)&thread_data_array[i] );
  }

  for ( i = 0; i < num_threads; ++i ) {
    pthread_join( threads[i], NULL );
  }
  double elapsed = 0;
  return elapsed;
}
