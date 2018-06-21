CC      = nvcc
CFLAGS  = -Xptxas --opt-level=3 -arch sm_30

sandbox: sandbox.cu
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: clean
clean:
	rm -f *.o sandbox
