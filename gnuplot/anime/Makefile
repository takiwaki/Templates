
dirm=movies
diri=snap
dird=snap
exe=openseqfile.x

all: ${dirm}/anix-r.mp4 ${diri}/t-x-r.png

${diri}/t-x-r.png: ${dird}/t-x-r.dat t-x-r.plt
	gnuplot t-x-r.plt

${dird}/t-x-r.dat: ${dird}/n*.dat unifysnap.sh
	sh unifysnap.sh

${dirm}/anix-r.mp4: ${diri}/x-r*.png MakeImage.sh
	sh MakeAnime.sh

${diri}/x-r*.png: ${dird}/n*.dat MakeImage.sh x-r.plt
	sh MakeImage.sh

${dird}/n*.dat: ${exe}
	./${exe}

CC=icc
COPT=-g 

${exe}: openseqfile.cpp
	${CC} ${COPT} $< -o openseqfile.x

clean:
	rm -fr ${exe} ${dird}/n*.dat ${diri}/*.png ${dirm}/*.mp4
