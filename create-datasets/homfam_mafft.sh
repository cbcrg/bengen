#metadata 



[[ -d  "homfam_mafft" ]]  && { echo \
$'\n'$'\n'$'\t'SCRIPT NOT EXECUTED \!\!$'\n'\
-------------------------------------$'\n'\
A directory called homfam_mafft exists already.$'\n'\
Please remove it and all its contents before running the script.$'\n'\
E.g. rm -rf homfam_mafft $'\n'$'\n' ; exit 0 ;  }

mkdir homfam_mafft 
cd homfam_mafft

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
