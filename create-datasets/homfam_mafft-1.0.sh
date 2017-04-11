
bengen=$1
benchmarkPath="$bengen/benchmark_datasets"
cd $benchmarkPath
[[ -d  "homfam_mafft-1.0" ]]  && rm -rf homfam_mafft-1.0

mkdir homfam_mafft-1.0
cd homfam_mafft-1.0



wget -q https://mafft.sb.ecei.tohoku.ac.jp/material/dataset/benchmark/homfam.tgz 
tar xf homfam.tgz 
rm -rf homfam.tgz 

mv homfam/large/* . 
mv homfam/medium/* . 
mv homfam/small/* . 




all_ref=`ls *.rfa` 
fam_names=`for i in $all_ref;{ echo $i | awk -F. '{ print $1 }'; }` 
for i in $fam_names;{  mv $i.rfa $i.fa.ref; mv $i.tfa $i.fa; }  

rm -rf homfam
cd ..
echo "Homfam_mafft downloaded!"
