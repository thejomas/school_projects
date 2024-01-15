.PHONY: all
all: strange quaternary.o getaline.o

quaternary.o: quaternary.asm
	nasm -f elf64 -o quaternary.o quaternary.asm

getaline.o: getaline.asm
	nasm -f elf64 -o getaline.o getaline.asm

strange.o: strange.asm
	nasm -f elf64 -g -o strange.o strange.asm

strange: strange.o
	gcc -no-pie strange.o -o strange

# Some rules to start off for submitting code for OnlineTA
# Remember to add your report
handin.zip: Makefile quaternary.asm getaline.asm strange_debug.gdb
	@echo "!!! Remember to update the Makefile to include your report !!!"
	zip -MM $@ $^

.PHONY: onlineta
onlineta: handin.zip
	curl -F handin=@handin.zip https://pcs.incorrectness.dk/grade/week1

.PHONY: clean
clean:
	rm -f *.o strange
