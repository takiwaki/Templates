reset

pngflag=1

if(pngflag==1) outflag=1
if(outflag==1) set terminal push

if(pngflag ==1) set terminal pngcairo enhanced font "Helvetica, 18" crop

input="snap/t-x-r.dat"

set pm3d map

##########################################
# Space Time Diagram
##########################################
if(pngflag ==1)set output "snap/t-x-r.png"

set xlabel "Time [s]" offset 0,1
set xtic offset 0,0.5

set ylabel "Radius [cm]" offset 1.0, 0.0
set ytic offset 0.5,0.0

set palette defined ( 0 "black", 1.0 "blue", 2.0 "cyan", 3.0 "yellow", 4.0 "red" , 5.0 "white" )
set cbrange [*:*]

splot input  u 1:2:3 notitle \

##########################################
# Finalize
##########################################

reset
if(outflag==1) set terminal pop
