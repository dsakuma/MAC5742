CC      = gcc
CFLAGS  = -O3 -flto -Wall -Xpreprocessor -fopenmp -lomp

main: main.c sequential_multiply.c openmp_multiply.c pthread_multiply.c utils.c
	$(CC) $(CFLAGS) -o $@ $^

generate_matrix: generate_matrix.c
	$(CC) $(CFLAGS) -o $@ $^

sandbox: sandbox.c
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: test_main
test_main: main generate_matrix
	./generate_matrix 2 3 3 2
	./main

.PHONY: test_generate_matrix
test_generate_matrix: generate_matrix
	./generate_matrix 20 20 3 3

test_sandbox: sandbox
	./sandbox

.PHONY: clean
clean:
	rm -f generate_matrix main sandbox matrix_a.txt matrix_b.txt
