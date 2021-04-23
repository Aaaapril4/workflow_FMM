#!/bin/sh

#  do_tomo.sh
#  
#
#  Created by Yaqi Jie on 1/24/20.
#
parafile=../para.dat
if [ ! -e ../output_tomo ]
then
    mkdir ../output_tomo
fi

for per in 5 7 9 13 17 21 25 29 33 37 41 45
#for per in 5
do
    echo $per
    cp ../gridi."$per".vtx gridi.vtx
    cp ../FMM_input$per otimes.dat
    cp ../sources."$per".dat sources.dat
    cp ../receivers."$per".dat receivers.dat

    damping=`cat $parafile | awk '$1==per {print $2}' per="$per"`
    smoothing=`cat $parafile | awk '$1==per {print $3}' per="$per"`
    sed -i '12c '$damping'' subinvss.in
    sed -i '15c '$smoothing'' subinvss.in

    zsh ttomoss

    tslicess

# plot histogram
    sh PLOT_hist.sh
    mv hist.pdf ../plot/hist."$per".pdf
    cp ../receivers."$per".dat ../plot_raypath
    cp ../sources."$per".dat ../plot_raypath
    mv rays.dat ../plot_raypath/rays."$per".dat
    mv grid2dv.z ../output_tomo/grid2dv."$per".z
   # rm *.out
   # rm *.dat
   # rm *.vtx
done

python3 cal_perturbation.py
sh PLOT_per_int.sh
