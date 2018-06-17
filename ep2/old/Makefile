CC      = nvcc
CFLAGS  = -Xptxas --opt-level=3 -arch sm_30
#nvcc ep2.cu -o main -gencode arch=compute_20,code=sm_20 -gencode arch=compute_35,code=sm_35

main: main.cu functions.cu
	$(CC) $(CFLAGS) -o $@ $^

sandbox: sandbox.cu
	$(CC) $(CFLAGS) -o $@ $^

ep2_cuda:
	nvcc ep2.cu -o main -Xptxas --opt-level=3 -arch sm_30

ep2_c:
	gcc ep2.c -o main_c -std=c11
	./main_c teste.txt
