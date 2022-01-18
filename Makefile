SDIR=src
ODIR=out
CFLAGS=-Wall 
LDLIBS=-lXrender -lX11 -lXcomposite -lXdamage -lXfixes -lXext -lconfuse -lxdg-basedir
CC=gcc
EXEC=$(ODIR)/compix
SRC= $(wildcard $(SDIR)/*.c)
OBJ= $(SRC:$(SDIR)/%.c=$(ODIR)/%.o)
SHELL=/bin/bash

all: out $(EXEC)

$(EXEC): $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LDLIBS)

$(ODIR)/%.o: $(SDIR)/%.c
	$(CC) -o $@ $< $(CFLAGS) -c -MMD
	$(CC) -o $@ -c $< $(CFLAGS) $(LDLIBS)

out:
	mkdir $@

run: all
	./$(EXEC) -d :1 -c compix.conf

debug: CFLAGS+=-g -D DEBUG
debug: clean all

check: $(SDIR)/*.c
	cppcheck --enable=all --suppress=missingIncludeSystem $(SDIR)

clean:
	rm -f $(OBJ) $(ODIR)/*.d

cleaner: clean
	rm -f $(EXEC)

-include $(ODIR)/*.d

.PHONY: all clean run
