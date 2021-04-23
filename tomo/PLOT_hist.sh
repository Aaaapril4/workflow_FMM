#!/bin/bash
gmt gmtset MAP_FRAME_TYPE plain
gmt gmtset FONT_LABEL 18p,Times-Roman
gmt gmtset MAP_TITLE_OFFSET 1.5p
gmt gmtset MAP_TICK_LENGTH_PRIMARY 3p
gmt gmtset MAP_TICK_LENGTH_SECONDARY 2p

R=-20/20/0/2000
J=X3i/5i
PS=hist.ps

paste itimes.dat otimes.dat | awk '$1==1 {print $2-$4}' |\
gmt pshistogram -R$R -J$J -BSWne -Bx5f1+l"Travel Time Residual (s)" -By500+l"Number of Rays" -W1 -Ggrey -K > $PS

paste rtravel.out otimes.dat | awk '$1==1 {print $2-$4}' |\
gmt pshistogram -R$R -J$J  -Gdarkblue -W1 -t70 -O >> $PS

gmt psconvert -A -Tf $PS
rm hist.ps


