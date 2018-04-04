#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>


int multiply(){
  int a, b, c;
  printf("Enter a: ");
  scanf("%d", &a);
  printf("Enter b: ");
  scanf("%d", &b);
  c = a*b;
  printf("a=%d, b=%d, a*b=%d\n", a, b, c);
  return 0;
};

int sizeOf(){
  int a = sizeof(long long);
  printf("%d bytes\n", a);
  return 0;
}

int testPointer(){
  int a;
  a = 5;
  int* p = &a;
  printf("Print address stored in p: %p\n", p);
  printf("Print address stored in p: %p\n", p+1);
  printf("Print value stored in address pointed by p: %d\n", *p);
  printf("Print value stored in address pointed by p: %d\n", *(p+1));
  return 0;
};

int testPointerTypes(){
  int a;
  int* p;
  a = 1025;
  p = &a;
  char* pc;
  pc = (char*)p;
  void* pv;
  pv = p;
  printf("Address = %p, value = %d\n", p, *p);
  printf("Address = %p, value = %d\n", pc, *pc);
  printf("Address = %p\n", pv);
  return 0;
};


void increment(int* p){
  printf("Address p = %p\n", p);
  *p = (*p) + 1;
}

int testCallByReference(){
  int a;
  a = 5;
  increment(&a);
  printf("a = %d\n", a);
  return 0;
};

int main(){
  // multiply();
  // sizeOf();
  // testPointer();
  // testPointerTypes();
  testCallByReference();
  return 0;
};








// pthread_create(&threads[i], NULL, frog, (void *)(*(structLake+i)));

//deixar arbitro pro fim


// dentro da função que é executada por threads, eu criei um loop (while) que executa enquanto o count não for grande o suficiente para que todos os sapos possam tentar pular um número satisfatório de vezes.
