CC      = nvcc
CFLAGS  = -Xptxas --opt-level=3 -arch sm_30

main: main.cu functions.cu
	$(CC) $(CFLAGS) -o $@ $^

sandbox: sandbox.cu
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: clean
clean:
	rm -f *.o main sandbox
