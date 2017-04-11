

bengen=$1
benchmarkPath="$bengen/benchmark_datasets"
cd $benchmarkPath
[[ -d  "oxfam-1.0" ]]  && rm -rf oxfam-1.0

wget -q https://mafft.sb.ecei.tohoku.ac.jp/material/dataset/benchmark/oxfam.tgz 
tar xf oxfam.tgz 
rm -rf oxfam.tgz
mv oxfam oxfam-1.0 
cd oxfam-1.0

 


mv large/* .
mv medium/* . 
mv small/* .





all_ref=`ls *.rfa`  
fam_names=`for i in $all_ref;{ echo $i | awk -F. '{ print $1 }'; }`
for i in $fam_names;{  mv $i.rfa $i.fa.ref; mv $i.tfa $i.fa; } 

rm -rf large/ medium/ small/

echo "OXFam downloaded!"
