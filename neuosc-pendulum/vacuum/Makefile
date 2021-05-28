
EXE=pendulum.x

FTEVO=./figures/t-pz.png
DTEVO=./data/t-pz.dat

ANIME=./movies/aniplv.mp4
IZERO=./images/plv00000.png
DZERO=./data/plv00000.dat

.PHONY: all clean cleanall

all: ${FTEVO} ${ANIME}

${FTEVO}: ${DTEVO} t-pz.plt 
	gnuplot t-pz.plt

${DTEVO}: ${DZERO} time-pol.sh 
	sh time-pol.sh

${ANIME}: ${IZERO} anime.sh 
	sh anime.sh

${IZERO}: ${DZERO} vis.plt images.sh
	sh images.sh

${DZERO}: ${EXE}
	./${EXE}

#################
# fortran part
#################

FC=ifort -extend-source
OPT=-g -check all -fpe0

.SUFFIXES: .F.o

.F.o:
	${FC} ${OPT} -c $*.F

OBJ= pend.o

${EXE}: ${OBJ}
	${FC} ${OPT} ${OBJ} -o ${EXE}

pend.o: pend.F 

#################
# phony 
#################

clean:
	rm -fr *~ *.o *.mod ${EXE}

cleanall:
	rm -fr data/* images/* movies/*


