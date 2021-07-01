CC=g++ -std=c++0x
OPTS=

.SUFFIXES: .cpp .o

.cpp.o: 
	${CC} ${OPTS} -c $<

all: ex1.exe ex2.exe ex3.exe

ex1.exe: ex1.o ex1.hpp
	${CC} ${OPTS} $^ -o $@

ex2.exe: ex2.o ex2.hpp
	${CC} ${OPTS} $^ -o $@

ex3.exe: ex3.o ex3.hpp
	${CC} ${OPTS} $^ -o $@

clean:
	rm *.o *.exe
