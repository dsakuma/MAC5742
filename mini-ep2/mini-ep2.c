#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define MAX_JUMPS 10
#define NUM_FROGS 3
int counter = 0;
char **arrayStringLake;
int lakeSize;
pthread_mutex_t lock;


void initializeStringLake(int numFrogs){
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

void printLakeState(){
  for(int i = 0; i < lakeSize; i++)
  {
     printf("[%s] ", arrayStringLake[i]);
  }
  printf("\n");
}

long tryJump(long position){
  char frogType = arrayStringLake[position][0];
  char frogNumber = arrayStringLake[position][2];


  if(frogType == 'M'){
    if(arrayStringLake[position+1][0] == '_' & position+1 < lakeSize){
      if(counter < MAX_JUMPS){
        printf("O sapo %c-%c pulando 1, no counter %d!\n", frogType, frogNumber, counter);
        sprintf(arrayStringLake[position], "%c", '_');
        sprintf(arrayStringLake[position+1], "%c-%c", 'M', frogNumber);
      }
    }
    else if(arrayStringLake[position+2][0]== '_' & position+2 < lakeSize){
      if(counter < MAX_JUMPS){
        printf("O sapo %c-%c pulando 2, no counter %d!\n", frogType, frogNumber, counter);
        sprintf(arrayStringLake[position], "%c", '_');
        sprintf(arrayStringLake[position+2], "%c-%c", 'M', frogNumber);
      }
    }
  }
  else{

    if(arrayStringLake[position-1][0] == '_' & position-1 >= 0){
      if(counter < MAX_JUMPS){
        printf("O sapo %c-%c pulando 1, no counter %d!\n", frogType, frogNumber, counter);
        sprintf(arrayStringLake[position], "%c", '_');
        sprintf(arrayStringLake[position-1], "%c-%c", 'F', frogNumber);
      }
    }
    else if(arrayStringLake[position-2][0]== '_' & position-2 >= 0){
      if(counter < MAX_JUMPS){
        printf("O sapo %c-%c pulando 2, no counter %d!\n", frogType, frogNumber, counter);
        sprintf(arrayStringLake[position], "%c", '_');
        sprintf(arrayStringLake[position-2], "%c-%c", 'F', frogNumber);
      }
    }

  }
  return position;
}

void *frog(void *threadid){
   // printf("initializing thread %d\n", threadid);

   long tid = threadid;
   long position = tid;
   usleep(rand()%1000);

   while(counter < MAX_JUMPS){

     pthread_mutex_lock(&lock);
     if(counter < MAX_JUMPS){
       position = tryJump(position);
       counter++;
     };
     pthread_mutex_unlock(&lock);
     usleep(rand()%1000);
   }
   // pthread_exit(NULL);
}

void initializeThreads(numFrogs){
  if (pthread_mutex_init(&lock, NULL) != 0)
  {
      printf("\n mutex init failed\n");
      return;
  }

  pthread_t threads[lakeSize];
  int error_code;
  for(long t = 0;t < numFrogs; t++){
      if(t != numFrogs){
        error_code = pthread_create(&threads[t], NULL, frog, (void *) t);
        if (error_code){
            printf("ERROR; return code from pthread_create() is %d\n", error_code);
            exit(-1);
        };
      }
  };

  for(long t = lakeSize-1;t > numFrogs; t--){
      if(t != numFrogs){
        error_code = pthread_create(&threads[t], NULL, frog, (void *) t);
        if (error_code){
            printf("ERROR; return code from pthread_create() is %d\n", error_code);
            exit(-1);
        };
      }
  };


  for (int i = 0; i < lakeSize; i++)
    pthread_join(threads[i], NULL);

  pthread_mutex_destroy(&lock);
}

void checkDeadlock(){
  if(counter >= MAX_JUMPS){
    printf("Ocorreu um deadlock\n");
  }
}

int main(int argc, char *argv[]){
  printf("=====Initializing=====\n");
  seedRand();


  lakeSize = (NUM_FROGS * 2) + 1;
  initializeStringLake(NUM_FROGS);
  initializeThreads(NUM_FROGS);
  checkDeadlock();
  printLakeState();

  pthread_exit(NULL);

  printf("======Finished======\n");
};
