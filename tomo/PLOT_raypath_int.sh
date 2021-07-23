#!/bin/bash
gmt gmtset MAP_FRAME_TYPE plain
gmt gmtset FONT_LABEL 18p, Times-Roman
gmt gmtset FONT_ANNOT_PRIMARY 17p,Times-Roman
gmt gmtset PS_MEDIA a2
gmt gmtset MAP_TITLE_OFFSET 1.5p
gmt gmtset MAP_TICK_LENGTH_PRIMARY 10p
gmt gmtset MAP_TICK_LENGTH_SECONDARY 5p
gmt gmtset MAP_TICK_PEN_PRIMARY 1.5p
gmt gmtset MAP_TICK_PEN_SECONDARY 1p

R=25/40/-15/4
J=m0.2i
PS=../plot/raypath.ps
# period you should give your own
per=( 5  7  9  13  17  21  25  29  33  37  41  45  49  53 )
#id   0  1  2  3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18
CPT=cptfile.cpt

gmt makecpt -Cetopo1 -T-3000/3000 -D -Z  > 123.cpt

gmt grdcut  @earth_relief_03m.grd  -Gcut.grd  -R$R
gmt grdgradient cut.grd -A45 -Nt -Gcut.grd.gradient
gmt grdsample cut.grd.gradient -Gcut.grd.gradient2  -I0.05 -R$R

for (( i=0; i<=11; i++ ))
do
    echo ${per[$i]}
    raypath=../plot_raypath/rays."${per[$i]}".dat
    receivers=../plot_raypath/receivers."${per[$i]}".dat
    sources=../plot_raypath/sources."${per[$i]}".dat
    
	if  (( $i ==  0  )) ; then
       XOFF=1i
       YOFF=12i
       gmt grdimage  -R$R -J$J cut.grd -Icut.grd.gradient -C123.cpt -K -t80 -X$XOFF -Y$YOFF > $PS
       gmt psclip -R$R -J$J ~/Documents/mask.xy -S10 -K -O -V >> $PS
        gmt grdimage  -R$R -J$J cut.grd -Icut.grd.gradient -C123.cpt -K -O >> $PS
        gmt psclip -C -O -K >> $PS  

        gmt pscoast -R$R -J$J -W0.5p,darkgrey -A1000 -K -O >> $PS

        gmt psbasemap -R$R -J$J -B5f1 -BWseN -K -O  >> $PS

    elif (( $i == 4 )) || (( $i == 8 )) || (( $i == 12 )) || (( $i == 16 )) ; then
        XOFF=-10.5i
        YOFF=-5.3i
        gmt grdimage  -R$R -J$J cut.grd -Icut.grd.gradient -C123.cpt -K -O -t80 -X$XOFF -Y$YOFF >> $PS
        gmt psclip -R$R -J$J ~/Documents/mask.xy -S10 -K -O -V >> $PS
        gmt grdimage  -R$R -J$J cut.grd -Icut.grd.gradient -C123.cpt -K -O >> $PS
        gmt psclip -C -O -K >> $PS  

        gmt pscoast -R$R -J$J -W0.5p,darkgrey -A1000 -K -O >> $PS

        gmt psbasemap -R$R -J$J -B5f1 -BWseN -K -O  >> $PS

    else
       XOFF=3.5i
       YOFF=0i
       gmt grdimage  -R$R -J$J cut.grd -Icut.grd.gradient -C123.cpt -K -O -t80 -X$XOFF -Y$YOFF >> $PS
       gmt psclip -R$R -J$J ~/Documents/mask.xy -S10 -K -O -V >> $PS
        gmt grdimage  -R$R -J$J cut.grd -Icut.grd.gradient -C123.cpt -K -O >> $PS
        gmt psclip -C -O -K >> $PS  

	    gmt pscoast -R$R -J$J -W0.5p,darkgrey -A1000 -K -O >> $PS

        gmt psbasemap -R$R -J$J -B5f1 -BwseN -K -O  >> $PS
       
    fi

    

    gmt psxy $raypath  -J$J -R$R -K -O -W1p,black >>$PS
    
    awk 'NR>1 {print $2,$1}' $receivers |
    gmt psxy -R$R -J$J -St8p -Wblack -Ggray -O -K >> $PS
    
    awk 'NR>1 {print $2,$1}' $sources |
    gmt psxy -R$R -J$J -St8p -Wblack -Ggray -O -K >> $PS

    

    echo 26.25 3 ''${per[$i]}'s' | gmt pstext -J$J -R$R -Gwhite -C0.1c/0.1c -W1p -F+f17p -O -K >> $PS

done
gmt psconvert -A -P -Tf $PS
rm $PS
