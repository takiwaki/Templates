reset

epsflag=1
if(epsflag==1)set terminal postscript eps color enhanced "Times-Roman, 24"

set view equal
set parametric
set isosample 15,30
set view 75,30,1.5,1
set size ratio 1.5 1.0

set xlabel "x"
set ylabel "y"
set zlabel "z" offset 4.0, 0.0, 0.0
set xtics 2
set ytics 2
set ztics 2

set xrange [-6:6]
set yrange [-6:6]
set zrange [-4:4]

if (exist("n")==0 || n<0) n=0
ofile = sprintf("data/snap%03d.eps",n)
set output ofile
phi(u)=pi*(u - 0.3*n)
amp=0.3
splot [1.0:6.0][0:2*pi] u*cos(v), u*sin(v),amp*sin(phi(u)) notitle

if(n<100)n = n+1;reread

n=0
