OUTPUT=desafio2

CC=gcc
CC_OPT=-std=c11

all: $(OUTPUT).c
	$(CC) -o $(OUTPUT) $(CC_OPT) $(OUTPUT).c
	./$(OUTPUT)

clean:
	-rm -f $(OUTPUT)

sandbox: sandbox.c
	$(CC) -Wall -o sandbox $(CC_OPT) sandbox.c
	./sandbox
