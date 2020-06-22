#!/bin/bash

dirf=snap
prename=n

if [ ! -d $dirf ]; then
    mkdir $dirf
fi

for n in {1..100} ; do 
    gnuplot -e num=$n x-r.plt
done

exit
