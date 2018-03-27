#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define n_pedras 5
int contador = 0;


void *sapo(void *threadid){
    long tid = threadid;
    int i;
    for(i = 0; i< 300; i++){
      printf("O sapo %d tentando pular!\n", tid);
    }
    pthread_exit(NULL);
};


int main(int argc, char *argv[]){
    int lagoa[n_pedras];

    pthread_t threads[2];
    int error_code;
    long t;
    for(t = 0;t < 2; t++){
        printf("In main: creating thread %ld\n", t);
        error_code = pthread_create(&threads[t], NULL,
                                    sapo, (void *) t);
        if (error_code){
            printf("ERROR; return code from pthread_create() is %d\n", error_code);
            exit(-1);
        };
    };
    pthread_exit(NULL);
};



// pthread_create(&threads[i], NULL, frog, (void *)(*(lake+i)));

//deixar arbitro pro fim


// dentro da função que é executada por threads, eu criei um loop (while) que executa enquanto o count não for grande o suficiente para que todos os sapos possam tentar pular um número satisfatório de vezes.
