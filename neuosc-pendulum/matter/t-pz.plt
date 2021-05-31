
pngflag=1
if(pngflag==1) outflag=1
if(outflag==1) set terminal push
if(pngflag ==1) set terminal pngcairo enhanced font "Helvetica, 18"

input="data/t-pz.dat"
outputfile="figures/t-pz.png"
if(pngflag ==1)set output outputfile

set xrange [*:350]
set xlabel "time"
set ylabel "{/Symbol n}_e-{/Symbol n}_{/Symbol m}/{/Symbol n}_e+{/Symbol n}_{/Symbol m}"
set yrange [-1.0:1.0]

plot input u 1:2 w l lw 6 notitle

reset
if(outflag==1) set terminal pop