all: matrix_sum_normal matrix_sum_coalesced matrix_sum_cpu

include ../common/Makefile.common

matrix_sum_cpu: 
	$(CC) $(CFLAGS) matrix_sum_cpu.cu -o matrix_sum_cpu

matrix_sum_normal.o: matrix_sum_normal.cu
	$(CC) $(CFLAGS) -c matrix_sum_normal.cu

matrix_sum_normal: matrix_sum_normal.o
	$(CC) $(CFLAGS) matrix_sum_normal.o -o matrix_sum_normal

matrix_sum_coalesced.o: matrix_sum_coalesced.cu
	$(CC) $(CFLAGS) -c matrix_sum_coalesced.cu

matrix_sum_coalesced: matrix_sum_coalesced.o 
	$(CC) $(CFLAGS) matrix_sum_coalesced.o -o matrix_sum_coalesced

tests: all 
	./matrix_sum_normal $(sizeM) $(DEVICE_ID)
	./matrix_sum_coalesced $(sizeM) $(DEVICE_ID) 
	./matrix_sum_cpu $(sizeM)

clean:
	rm -rf *.o matrix_sum_normal matrix_sum_coalesced matrix_sum_cpu
