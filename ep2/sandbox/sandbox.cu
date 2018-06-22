#include <cuda.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>



int main(int argc, char *argv[])
{
  int a;
  int *ptx;
  int *pty;
  int *pttmp;

  printf("Pointer Example Program : Print Pointer Address\n");
  a = 10;
  ptx = &a;

  printf("\n[a  ]:Value of A = %d", a);
  printf("\n[*ptx]:Value of A = %d", *ptx);
  printf("\n[&a ]:Address of A = %p", &a);
  printf("\n[ptx ]:Address of A = %p", ptx);
  printf("\n[&ptx]:Address of ptx = %p", &ptx);
  printf("\n[ptx ]:Value of ptx = %p", ptx);
  printf("\n[ptx ]:Value of pty = %p", pty);

  return 0;
}
