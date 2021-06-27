FC=ifort -extend-source
FOPTS=-g -traceback

.SUFFIXES: .f .o

.f.o: 
	${FC} ${OPTS} -c $<

all: ex1.exe ex2.exe

ex1.exe: ex1.o mod1.o
	${FC} ${OPTS} $^ -o $@

ex1.o: mod1.o

ex2.exe: ex2.o mod2.o
	${FC} ${OPTS} $^ -o $@

ex2.o: mod2.o
