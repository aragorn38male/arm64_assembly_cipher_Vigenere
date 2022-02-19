CIPHEROBJS = main.o

all: Vigenere

%.o : %.s
	as -g -o $@ $<

Vigenere: $(CIPHEROBJS)
	ld -g -o Vigenere $(CIPHEROBJS)

