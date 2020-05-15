#!/bin/bash

prename=snap

for i in {0..100} ; do
    prefile=data/${prename}$(printf "%03d" $i).eps
    if [ -e ${prefile} ]; then
	aftfile=data/ani${prename}$(printf "%03d" $i).jpg
	convert -quality 100 ${prefile} ${aftfile}
    fi
done

ffmpeg -r 10 -sameq -i data/ani${prename}%3d.jpg ani${prename}.wmv
#ffmpeg -r 10 -sameq -i ani${prename}%3d.jpg ani${prename}.mov
ffmpeg -r 10 -sameq -i  data/ani${prename}%3d.jpg ani${prename}.mp4
#ffmpeg -sameq -i ani${prename}%3d.jpg ani${prename}.mpg
