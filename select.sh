
for per in 5 7 9 13 17 21 25 29 33 37 41 45
#for per in 5
do

    echo $per
 
    rm temp 
    rm diff."$per".dat
    rm ray."$per".dat

    cp file/dt_Africa_300_100_"$per"_8.dat file/sel_phase_"$per".dat
    paste FMM_input"$per" output_tomo/itimes."$per".dat | awk '{print $1, $2, $5, $2-$5}' >> diff."$per".dat
    for n in `awk '$1==1 && $4>20 || $4<-20 {print NR}' diff."$per".dat | sort -u`
    do
        awk 'NR=='$n' {print $4}' FMM_detail"$per" >> temp
    done
    awk '{print $1}' temp | sort -u > ray."$per".dat
    rm temp

    for ccf in `awk '{print $1}' ray."$per".dat`
    do
        num=`awk '$9=="'$ccf'" {print $1}' file/tomo_phase_10_"$per".dat`
        line=`awk '$1=='$num' {print NR}' file/sel_phase_"$per".dat`
        sed -i ''$line'd' file/sel_phase_"$per".dat
    done
done
