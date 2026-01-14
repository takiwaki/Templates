reset

set style line 1 lt 1 lw 6 lc rgb "#ff2800" # universal design red 
set style line 2 lt 1 lw 6 lc rgb "#0041ff" # universal design blue
set style line 3 lt 1 lw 6 lc rgb "#35a16B" # universal design green
set style line 4 lt 1 lw 6 lc rgb "#faf500" # universal design yellow
set style line 5 lt 1 lw 6 lc rgb "#66ccff" # universal design sky-blue,azure
set style line 6 lt 1 lw 6 lc rgb "#ff99a0" # universal design pink
set style line 7 lt 1 lw 6 lc rgb "#ff9900" # universal design orange
set style line 8 lt 1 lw 6 lc rgb "#9a0079" # universal design purple
set style line 9 lt 1 lw 6 lc rgb "#663300" # universal design brown


pngflag=1

if(pngflag==1)set terminal push
if(pngflag==1)set terminal pngcairo color dashed enhanced font "Helvetica, 18"

inputM="../../ANAQ0-etam7M/1DSNAPS_and_AVGs/OUPDATA/time_evolution.dat"
inputL="../../ANAQ0-etam7v1/1DSNAPS_and_AVGs/OUPDATA/time_evolution.dat"

set log y
set format y "10^{%L}"

set xlabel "time"

set ylabel "v_{rms}"
if(pngflag==1) outputfile="t-v.png"
if(pngflag==1) print(outputfile)
if(pngflag==1) set output outputfile

plot inputL u 1:2 title "60^3"  w l ls 2 \
    ,inputM u 1:2 title "120^3" w l ls 1 

if(pngflag==1) outputfile="t-b.png"
if(pngflag==1) print(outputfile)
if(pngflag==1) set output outputfile

set ylabel "b_{rms}"
plot inputL u 1:3 title "60^3"  w l ls 2 \
    ,inputM u 1:3 title "120^3" w l ls 1

if(pngflag==1) outputfile="t-EmovEk.png"
if(pngflag==1) print(outputfile)
if(pngflag==1) set output outputfile

set ylabel "E_{mag}/E_{kin}"

plot inputL u 1:($5/$4) title "60^3"  w l ls 2  \
    ,inputM u 1:($5/$4) title "120^3" w l ls 1 

