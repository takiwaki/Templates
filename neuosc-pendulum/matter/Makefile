

FC=ifort -extend-source
OPT=-g -check all -fpe0
EXE=pendulum.x

ANIME="./movies/aniplv.mp4"
IZERO="./images/plv00000.png"
DZERO="./data/plv00000.dat"

${ANIME}: anime.sh ${IZERO}
	sh anime.sh

${IZERO}: vis.plt images.sh ${DZERO}
	sh images.sh

${DZERO}: ${EXE}
	./${EXE}

OBJ= pend.o

${EXE}: ${OBJ}
	${FC} ${OPT} ${OBJ} -o ${EXE}

clean:
	rm -fr *~ *.o *.mod ${EXE}

cleanall:
	rm -fr data/* images/* movies/*

.SUFFIXES: .F.o

.F.o:
	${FC} ${OPT} -c $*.F

pend.o: pend.F 
