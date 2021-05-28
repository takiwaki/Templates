

FC=ifort -extend-source
OPT=-g -check all -fpe0
EXE=pendulum.x

OBJ= pend.o

${EXE}: ${OBJ}
	${FC} ${OPT} ${OBJ} -o ${EXE}

clean:
	rm -fr *~ *.o *.mod ${EXE}

.SUFFIXES: .F.o

.F.o:
	${FC} ${OPT} -c $*.F
