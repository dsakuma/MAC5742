
#nvcc ep2.cu -o main -gencode arch=compute_20,code=sm_20 -gencode arch=compute_35,code=sm_35
CC=gcc
CC_OPT=-std=c11

all:
	nvcc ep2.cu -o main -Xptxas --opt-level=3 -arch sm_30

c:
	$(CC) ep2.c -o main_c $(CC_OPT)
	./main_c teste.txt

sandbox: sandbox.cu
	nvcc -o $@ $^
