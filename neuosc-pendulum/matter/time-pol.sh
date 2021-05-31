#! /bin/bash

dir=data
declare -i data_num_sum=0
declare -i data_add=0

output=t-pz.dat

if [ -f ${dir}/temp.dat ]; then 
    rm -f ${dir}/temp.dat
fi

echo > ${dir}/${output}

for file in ${dir}/plv*.dat  ; do
    echo "processing "${file}
# time
    timev=`awk 'NR==1{print($2)}' ${file}`
    echo ${timev}
# space varable
    awk 'NR==2{print('${timev}', $3 )}' ${file} > ${dir}/temp.dat

    cat ${dir}/temp.dat | tr -d \\n  > ${dir}/tempall
    echo -e "" >> ${dir}/tempall

    cat ${dir}/tempall >> ${dir}/${output}
done

rm ${dir}/temp.dat
