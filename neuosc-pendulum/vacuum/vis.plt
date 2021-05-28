


pngflag=1
if(pngflag==1) outflag=1
if(outflag==1) set terminal push
if(pngflag ==1) set terminal pngcairo enhanced font "Helvetica, 12"

if (exist("ostp")==0 ) ostp=10
input=sprintf("data/plv%05d.dat",ostp)
outputfile=sprintf("images/plv%05d.png",ostp)
if(pngflag ==1)set output outputfile

command = sprintf(" head -n 1 %s | sed 's/# //' ",input)
time   = system(command)
timetxt="time=".time
print timetxt

set size ratio 1
set view 80, 30, 1, 1
lsize=1.0e0
set xrange [-lsize:lsize]
set yrange [-lsize:lsize]
set zrange [-lsize:lsize]

#set label 1 "{/Symbol n}_e" at first 0,0,1.0
#set label 2 "{/Symbol n}_{/Symbol m}" at first 0,0,-1.0

set label 3 timetxt at screen 0.25, screen 0.85

scale=5.0

splot input u (0):(0):(0):1:2:3 w vect lw 5 title "P" \
,     input u (0):(0):(0):(norm=sqrt($4**2+$5**2+$6**2),$4/norm):($5/norm):($6/norm) w vect lw 5 title "H" \
#,     input u (0):(0):(0):($7*scale):($8*scale):($9*scale) w vect lw 5 title "{/Symbol w}B" \
#,     input u (0):(0):(0):($10*scale):($11*scale):($12*scale) w vect lw 5 title "{/Symbol l}L" \

unset label 3

reset
if(outflag==1) set terminal pop