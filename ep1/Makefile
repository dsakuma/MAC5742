CC      = gcc
CFLAGS  = -O3 -flto -Wall

main: main.c
	$(CC) $(CFLAGS) -o $@ $^

generate_matrix: generate_matrix.c
	$(CC) $(CFLAGS) -o $@ $^

sandbox: sandbox.c
	$(CC) $(CFLAGS) -o $@ $^


.PHONY: test
test: main generate_matrix
	./generate_matrix 20 20 3 3

test_sandbox: sandbox
	./sandbox

.PHONY: clean
clean:
	rm -f generate_matrix main sandbox matrix_a.txt matrix_b.txt
