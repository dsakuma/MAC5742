#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_STONES 5
#define NUM_EACH_FROG_TYPE 2
#define NUM_THREADS 4


char** globalArray;

struct frog
{
    int p;//position
    char type;
};

struct frog structLake[(NUM_EACH_FROG_TYPE*2)+1];

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
  int arrayLake[10];
  for(int i=0; i < 10; i++){
    arrayLake[i] = 0;
  }

  for(int i=0; i < 10; i++){
    printf("%d\n", arrayLake[i]);
  }
}

void testInitializeLake(){
   for(int i = 0; i < 5; i++)
   {
      structLake[i].p = 0;
      structLake[i].type = 'M';
   }

   for(int i = 0; i < 5; i++)
   {
      printf("%c-%d\n", structLake[i].type, structLake[i].p);
   }
}

void testChar(){
  char s[12];
  sprintf(s, "M_%d", 1);
  printf ("%s\n", s);
  printf("%c\n", s[0]);

}

void testArrayEmptyString(){
  char *arrayStringLake[5];
  for(int i = 0; i < 5; i++)
  {
     if(i==2){
       arrayStringLake[i] = "_";
     }
     else{
       arrayStringLake[i] = "Teste";
     }
   }
  for(int i = 0; i < 5; i++)
  {
     printf("%s\n", arrayStringLake[i]);
  }
}

void testInitializeStringLake(int numFrogs){
  int lakeSize = (numFrogs * 2) + 1;
  printf("lakeSize: %d\n", lakeSize);
  char *arrayStringLake[lakeSize];

  char m[12];
  char f[12];
  for(int i = 0; i < numFrogs; i++)
  {
    sprintf(m, "M-%d", i+1);
    sprintf(f, "F-%d", i+1);

    printf("Passo: %d\n", i);
    printf("valor m: %s\n", m);
    printf("valor f: %s\n", f);

    arrayStringLake[i] = m;
    arrayStringLake[lakeSize-1-i]= f;
  }
  arrayStringLake[numFrogs] = "_";
  for(int i = 0; i < lakeSize; i++)
  {
     printf("%s\n", arrayStringLake[i]);
  }
}

void testInitializeStringLake2(int numFrogs){
  int lakeSize = (numFrogs * 2) + 1;
  char arrayStringLake[lakeSize][50];
  for(int i = 0; i < numFrogs; i++)
  {
    sprintf(arrayStringLake[i], "%c-%d", 'M', i+1);
    sprintf(arrayStringLake[lakeSize-1-i], "%c-%d", 'F', i+1);
  }
  strcpy(arrayStringLake[numFrogs], "_");
  for(int i = 0; i < lakeSize; i++)
  {
     printf("%s\n", arrayStringLake[i]);
  }
  strcpy(arrayStringLake[0], "M-1");
}

void testChangeArray(){
  int numStringsInputted = 2;
  globalArray = malloc(sizeof(char*)*numStringsInputted);
  for(int i=0; i < numStringsInputted;i++){
    globalArray[i] = malloc(256*sizeof(char));
  }

  globalArray[0] = "c-1";
  printf("%s\n", globalArray[0]);
}

int main(int argc, char *argv[]){
  printf("TEST PROGRAM STARTED...\n");
  // testRand();
  // testArray();
  // testInitializeLake();
  // testChar();
  // testArrayEmptyString();
  // testInitializeStringLake(2);
  // testInitializeStringLake2(2);
  testChangeArray();
  printf("%s\n", globalArray[0]);
  printf("TEST PROGRAM FINISHED.\n");
};



// pthread_create(&threads[i], NULL, frog, (void *)(*(structLake+i)));

//deixar arbitro pro fim


// dentro da função que é executada por threads, eu criei um loop (while) que executa enquanto o count não for grande o suficiente para que todos os sapos possam tentar pular um número satisfatório de vezes.
