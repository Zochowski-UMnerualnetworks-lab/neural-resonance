#!/bin/sh

#  simulation_loop.sh
#  
#
#  Created by james roach on 8/25/15.
#


#get current directory


#echo $1
#echo $2
#echo $3
cwd=$(pwd)

#compile code
icpc "${cwd}/resonance_singleCELL.cpp" -O -o run.out

C=$(awk 'BEGIN{for(i=0.2;i<=0.8;i+=0.1)print i}')
D=$(awk 'BEGIN{for(i=0.1;i<=20;i+=0.1)print i}')

for k in $C
do
    for l in $D
    do
        for o in {1..5}
        do
            #sleep `expr $RANDOM % 10`

            #make excecution directory
            newdir=${cwd}"/run-"${i}"_"${j}"_"${k}"_"${l}"run"${o}
            mkdir "$newdir"
            #cd to execution directory
            cd "$newdir"
            #cp "${cwd}/set_I.txt"    "${newdir}/set_I.txt"
            #run code //////// 1st arg gKs_n //////// 2nd P_e ////// 3rd P_i
            "${cwd}/run.out" 1.5 0.3 $l $k
        done
    done
done
