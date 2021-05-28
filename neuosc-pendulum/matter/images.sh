#!/bin/bash

dird=data
dirf=images
prename=n

if [ ! -d $dirf ]; then
    mkdir $dirf
fi

# lst file
lstfile=`ls -1 ${dird}/${prename}*.dat  2>/dev/null | tail -1`
echo $lstfile
declare -i lstnum=`echo  ${fstfile##*/} | tr -cd '0123456789\n' |sed -e 's/^0\+\([0-9]\+\)$/\1/'`

for n in {0..500} ; do 
    gnuplot -e ostp=$n vis.plt
done

exit

