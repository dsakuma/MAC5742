CC      = gcc
CFLAGS  = -O3 -flto -Wall -Xpreprocessor -fopenmp -lomp -lpthread

main: main.c sequential_multiply.c openmp_multiply.c pthread_multiply.c functions.c
	$(CC) $(CFLAGS) -o $@ $^

generate_matrix: generate_matrix.c
	$(CC) $(CFLAGS) -o $@ $^

sandbox: sandbox.c
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: test_main
test_main: main generate_matrix
	./generate_matrix 1500 1500 1500 1500
	./main p matrix_a.txt matrix_b.txt matrix_c.txt

.PHONY: test_generate_matrix
test_generate_matrix: generate_matrix
	./generate_matrix 2 2 2 2

test_sandbox: sandbox
	./sandbox

.PHONY: clean
clean:
	rm -f generate_matrix main sandbox matrix_a.txt matrix_b.txt matrix_c.txt
