
[[ -d  "oxfam" ]]  && rm -rf oxfam

wget -q https://mafft.sb.ecei.tohoku.ac.jp/material/dataset/benchmark/oxfam.tgz 
tar xf oxfam.tgz 
rm -rf oxfam.tgz 
cd oxfam 


mkdir all 


mv large/* all/ 
mv medium/* all/ 
mv small/* all/ 

cd all



all_ref=`ls *.rfa`  
fam_names=`for i in $all_ref;{ echo $i | awk -F. '{ print $1 }'; }`
for i in $fam_names;{  mv $i.rfa $i.fa.ref; mv $i.tfa $i.fa; } 
cd ..
rm -rf large/ medium/ small/

echo "OXFam downloaded!"
