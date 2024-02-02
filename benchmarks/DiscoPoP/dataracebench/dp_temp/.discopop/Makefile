.DEFAULT_GOAL=all
.PHONY: all
CFLAGS="-c"
all: prog

prog: prog.o
	$(CC) prog.o -o prog

prog.o: DRB007-indirectaccess3-orig-yes.c 
	$(CC) $(CFLAGS)  DRB007-indirectaccess3-orig-yes.c  -o prog.o
