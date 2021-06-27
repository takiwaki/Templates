CC=g++ -std=c++0x
OPTS=

.SUFFIXES: .cpp .o

.cpp.o: 
	${CC} ${OPTS} -c $<

all: ex1.exe

ex1.exe: ex1.o
	${CC} ${OPTS} $^ -o $@

ex2.exe: ex2.o
	${CC} ${OPTS} $^ -o $@
