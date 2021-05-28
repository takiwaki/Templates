#!/bin/bash

dirf=images
prename=n

if [ ! -d $dirf ]; then
    mkdir $dirf
fi

for n in {1..100} ; do 
    gnuplot -e ostp=$n vis.plt
done

exit
