#metadata 

[[ -d  "oxfam" ]]  && { echo \
$'\n'$'\n'$'\t'SCRIPT NOT EXECUTED \!\!$'\n'\
-------------------------------------$'\n'\
A directory called oxfam exists already.$'\n'\
Please remove it and all its contents before running the script.$'\n'\
E.g. rm -rf oxfam $'\n'$'\n' ; exit 0 ;  }

wget -q https://mafft.sb.ecei.tohoku.ac.jp/material/dataset/benchmark/oxfam.tgz 
tar xf oxfam.tgz 
rm -rf oxfam.tgz 

cd oxfam 
mv large/* . 
mv medium/* . 
mv small/* . 

all_ref=`ls *.rfa`  
fam_names=`for i in $all_ref;{ echo $i | awk -F. '{ print $1 }'; }`
for i in $fam_names;{  mv $i.rfa $i.fa.ref; mv $i.tfa $i.fa; } 

rm -rf large/ medium/ small/

echo "OXFam downloaded!"
