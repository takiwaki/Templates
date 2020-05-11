reset

pngflag=1
if(pngflag==1)set terminal push
if(pngflag==1)set terminal pngcairo enhanced
if(pngflag==1)set encoding utf8

set style line 11 lt 1 lw 6 lc rgb "#ff2800" # universal design red 
set style line 12 lt 2 lw 6 lc rgb "#ff2800" # universal design red 
set style line 13 lt 3 lw 6 lc rgb "#ff2800" # universal design red 

set style line 21 lt 1 lw 6 lc rgb "#0041ff" # universal design blue
set style line 3 lt 3 lw 6 lc rgb "#35a16B" # universal design green

set style line 4 lt 3 lw 6 lc rgb "#faf500" # universal design yellow
set style line 5 lt 3 lw 6 lc rgb "#66ccff" # universal design sky-blue,azure
set style line 6 lt 3 lw 6 lc rgb "#ff99a0" # universal design pink
set style line 31 lt 3 lw 6 lc rgb "#ff9900" # universal design orange
set style line 8 lt 3 lw 6 lc rgb "#9a0079" # universal design purple
set style line 9 lt 3 lw 6 lc rgb "#663300" # universal design brown
 
set style line 91 lt 1 lw 6 lc rgb "black" # 
set style line 92 lt 2 lw 6 lc rgb "black" #

##########################################
# Setup Number
##########################################

if (exist("num")==0 ) num=100
print num

outfile=sprintf("snapshots/out%05d.png",num)
set output outfile

timetext=sprintf("t=%d",num)

set label 1 timetext at graph 0.1,0.2 

set xrange [-pi:pi]
set yrange [-1:1]
 
plot sin(x-0.1*num) w l lw 6 notitle

##########################################
# Finalize
##########################################

reset
if(pngflag==1)set terminal pop

