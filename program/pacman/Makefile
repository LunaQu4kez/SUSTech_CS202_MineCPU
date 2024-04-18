OBJS   = pacman.o monster.o util.o movie.o
CFLAGS = -W -Wall -Wextra -O2 -T linker_script.ld
LDLIBS = -lcurses
CC = riscv64-unknown-elf-gcc -c

all: pacman

pacman:	$(OBJS)
	$(CC) -o $@ $(OBJS) $(LDLIBS)

pacman.o:  pacman.c  pacdefs.h
monster.o: monster.c pacdefs.h
util.o:    util.c    pacdefs.h
movie.o:   movie.c   pacdefs.h

clean:
	-rm -f *.o

distclean: clean
	-rm -f pacman errs core a.out
