#!/bin/bash

dirf=images
dirm=movies
prename=wav

if [ ! -d $dirf ]; then
    echo "cannot find ",$dirf
    exit
fi

if [ ! -d $dirm ]; then
    mkdir $dirm
fi

# first file
fstfile=`ls -1 ${dirf}/${prename}*.png  2>/dev/null | head -1`
echo $fstfile
declare -i fstnum=`echo  ${fstfile##*/} | tr -cd '0123456789\n' |sed -e 's/^0\+\([0-9]\+\)$/\1/'`

ffmpeg -y -r 5  -start_number ${fstnum} -i ${dirf}/${prename}%5d.png -b 6000k -vcodec wmv2 -pass 1 -r 5 -an ${dirm}/ani${prename}.wmv

echo "mp4 format"
ffmpeg -y -r 5  -start_number ${fstnum} -i ${dirf}/${prename}%5d.png -vcodec libx264 -pix_fmt yuv420p -r 10 -an ${dirm}/ani${prename}.mp4

exit
