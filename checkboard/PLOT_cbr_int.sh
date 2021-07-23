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
PS=../plot/tomo_cbr.ps

# period you should give your own
per=( 5  7  9  13  17  21  25  29  33  37  41  45  49  53  57  61  65)
#id   0  1  2  3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18
CPT=cptfile.cpt

gmt grdcut  @earth_relief_03m.grd  -Gcut.grd  -R$R
gmt grdgradient cut.grd -A45 -Nt -Gcut.grd.gradient
gmt grdsample cut.grd.gradient -Gcut.grd.gradient2  -I0.05 -R$R

for (( i=0; i<=11; i++ ))
do

    # mask the area
    echo ${per[$i]}

    INPUT_FILE=../output_cb/grid2dv."${per[$i]}".z
	gmt xyz2grd $INPUT_FILE -Ginput.grd2 -I0.05/0.05 -ZLB -R25/42/-15/6
        
    gmt makecpt -Cvik -T-0.1/0.1/0.05 -Ic -D -Z > $CPT

	if  (( $i ==  0  )) ; then
       XOFF=1i
       YOFF=12i
       gmt grdimage  input.grd2  -R -J$J -B -C$CPT -K -t80 -X$XOFF -Y$YOFF -Icut.grd.gradient2 > $PS
	   gmt psclip -R$R -J$J ~/Documents/mask.xy -BWseN -S10 -K -O -V >> $PS
       gmt grdimage  input.grd2  -R -J$J -B -C$CPT -O -K -Icut.grd.gradient2 >> $PS
       gmt psclip -C -O -K >> $PS
       gmt pscoast -R$R -J$J -W0.5p,darkgrey -A1000 -K -O >> $PS
       gmt psbasemap -R$R -J$J -B5f1 -BWseN -K -O >> $PS

    elif (( $i == 4 )) || (( $i == 8 )) || (( $i == 12 )) || (( $i == 16 )) ; then
       XOFF=-10.5i
       YOFF=-5.3i
       gmt grdimage  input.grd2  -R -J$J  -B -C$CPT -t80 -Icut.grd.gradient2 -K  -O -X$XOFF -Y$YOFF >> $PS
	   gmt psclip -R$R -J$J ~/Documents/mask.xy -BWseN -S10 -K -O -V >> $PS
       gmt grdimage  input.grd2  -R -J$J  -B -C$CPT -Icut.grd.gradient2 -K  -O >> $PS
       gmt psclip -C -O -K >> $PS
       gmt pscoast -R$R -J$J -W0.5p,darkgrey -A1000 -K -O >> $PS
       gmt psbasemap -R$R -J$J -B4f1 -BWseN -K -O  >> $PS

    else
       XOFF=3.5i
       YOFF=0i
       gmt grdimage  input.grd2  -R -J$J  -B -C$CPT -t80 -K  -O -Icut.grd.gradient2 -X$XOFF -Y$YOFF >> $PS
        gmt psclip -R$R -J$J ~/Documents/mask.xy -BWseN -S10 -K -O -V >> $PS
        gmt grdimage  input.grd2  -R -J$J  -B -C$CPT -Icut.grd.gradient2 -K  -O  >> $PS
        gmt psclip -C -O -K >> $PS
        gmt pscoast -R$R -J$J -W0.5p,darkgrey -A1000 -K -O >> $PS
        gmt psbasemap -R$R -J$J -B5f1 -BwseN -K -O  >> $PS
    fi

    gmt psxy ~/Documents/earifts.xy -R$R -J$J -W1p,black -O -K >> $PS
    gmt psxy ~/Documents/tzcraton.xy -R$R -J$J -W1p,black -O -K>> $PS
    gmt psxy ~/Documents/volcano_africa.txt -R$R -J$J -St8p -Wblack -Gred -O -K >> $PS
    echo 26.25 3 ''${per[$i]}'s' | gmt pstext -J$J -R$R -Gwhite -C0.1c/0.1c -W1p -F+f17p -O -K >> $PS
    
    DSCALE=1.5i/-0.12i/2.6i/0.1ih
	gmt psscale -C$CPT -D$DSCALE -O -K -X0 -B+l"@~\144@~C@-R@- (km/s)" >> $PS

    
done
gmt psconvert -A -Tf $PS
rm $PS
rm cptfile.cpt
rm input.grd2
