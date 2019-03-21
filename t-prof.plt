reset

epsflag=1
if(epsflag==1)set terminal push
if(epsflag==1)set terminal postscript eps color enhanced "Helvetica, 28" fontfile 'cmsy10.pfa'

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

# input file
input="output/t-prof.dat"
modelname="2D"

##########################################
# Evolusiton of shock and Gain Radius
##########################################
if(epsflag==1)set output "t-rsrg.eps"

set xlabel "Time after bounce [ms]"
set xrange [-10:1000]

set ylabel "Radius [km]"
set yrange [*:*]

set key right top

plot NaN notitle \
, input  u ($2*1e3):($3/1e5)              title modelname ls 11 w l \
, input  u ($2*1e3):($2>0.05?$6/1e5:NaN)  notitle  ls 12 w l \
, NaN w l ls 91 title "Shock Radius"  \
, NaN w l ls 92 title  "Gain Radius"  \



if(epsflag==1)set output "t-rs.eps"

set xlabel "Time after bounce [ms]"
set xrange [-10:500]

set ylabel "Shock Radius [km]"
set yrange [*:3000]
set mytics 5

set key right top

plot NaN notitle \
, input  u ($2*1e3):($3/1e5) smooth bezier w l ls 11 title "ave" \
, input  u ($2*1e3):($4/1e5) smooth bezier w l ls 12 title "min" \
, input  u ($2*1e3):($5/1e5) smooth bezier w l ls 13 title "max" \

##########################################
# Evolusiton of Explosion Energy
##########################################
if(epsflag==1)set output "t-Eexp.eps"

set xlabel "Time after bounce [ms]"
xnorm=1e3
set xrange [-10:1000]
set mxtics 2

set ylabel "Explosion Energy [10^{50}erg]"
ynorm=1.0e-50
set yrange [0:*]
set mytics 2

set key right bottom
set key spacing 2.0
set key font "Helvetica, 32"

plot NaN notitle \
, input   u ($2*xnorm):($15*ynorm) smooth bezier title "{/Helvetica:Italic e}_{tot}>0" ls 11 w l \
, input   u ($2*xnorm):($17*ynorm) smooth bezier title "{/Helvetica:Italic e}_{tot}>0, {/Helvetica:Italic v_r}>0" ls 21 w l \

#, input   u ($2*1e3):($16/1e51)  title "Definition 2" ls 21 w l \


##########################################
# Evolusiton of Ni mass
##########################################
if(epsflag==1)set output "t-M_Ni.eps"

set xlabel "Time after bounce [ms]"
xnorm=1e3
set xrange [-10:1000]

set ylabel "Ejected {^{56}Ni} mass [10^{-2} M_{/CMSY10 \014}]
ynorm=1.0e2
set yrange [0:0.03*ynorm]
set format y "%.1f"
set mytics 5

set key right bottom

plot NaN notitle \
, input   u ($2*xnorm):($20*ynorm) smooth bezier title "{/Helvetica:Italic e}_{tot} > 0" ls 11 w l \
, input   u ($2*xnorm):($23*ynorm) smooth bezier title "{/Symbol r} < 10^{11}g/cm^3" ls 31 w l \
#, input   u ($2*1e3):($19)  title "Definition 2" ls 21 w l \


##########################################
# Finalize
##########################################

reset
if(epsflag==1)set terminal pop

