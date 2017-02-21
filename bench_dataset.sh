#!/bin/bash

#No directory with the name benchmark_datasets should already exist in directory the script is executed
[[ -d  "benchmark_datasets" ]]  && { echo \
$'\n'$'\n'$'\t'SCRIPT NOT EXECUTED \!\!$'\n'\
-------------------------------------$'\n'\
A directory called benchmark_datasets exists already.$'\n'\
Please remove it and all its contents before running the script.$'\n'\
E.g. rm -rf benchmark_datasets$'\n'$'\n' ; exit 0 ;  }



#Directory where all the datasets are going to be downloaded
mkdir  benchmark_datasets
cd benchmark_datasets


#HOMFAM_Clustalo  

mkdir homfam_clustalo 
cd homfam_clustalo 

wget -q http://www.clustal.org/omega/homfam-20110613-25.tar.gz 
tar xf homfam-20110613-25.tar.gz
rm -rf homfam-20110613-25.tar.gz

all_ref=`ls *ref.vie`
fam_names=`for i in $all_ref;{ echo $i | awk -F_ref '{ print $1 }'; }`
for i in $fam_names;{  sed -e s/-//g $i\_ref.vie > $i\_ref.fa ; }
for i in $fam_names;{ cat $i\_test* $i\_ref.fa  > $i.fa; rm $i\_ref.fa; mv $i\_ref.vie $i.fa.ref; }

rm -f *.vie
cd .. 
echo "Homfam_clustalo downloaded!"

 
#Prefab

mkdir prefab4
cd prefab4

wget -q http://www.drive5.com/muscle/downloads_prefab/prefab4.tar.gz 
tar xf prefab4.tar.gz 
rm -rf prefab4.tar.gz

cd in  
fam_names=`ls *`
cd .. 
for i in $fam_names;{  mv in/$i $i.fa; mv ref/$i $i.fa.ref; } 

rm -rf info/ in/ ref/ src/ inw/
cd ..
echo "Prefab4 downloaded!"


#BaliBase


mkdir balibase 
cd balibase

wget -q http://www.lbgi.fr/balibase/BalibaseDownload/BAliBASE_R1-5.tar.gz 
tar xf BAliBASE_R1-5.tar.gz 
rm -rf BAliBASE_R1-5.tar.gz

mv bb3_release/* .
rm -rf bb3_release bali_score_src README

group_names=`dir .`
for group in $group_names;{ cd $group ;\
 all_ref=`ls *.msf | cut -d'.' -f1` ; cd .. ; 
fam_names=`for i in $all_ref;{ echo $i | awk -F. '{ print $1 }'; }` ;\
 for i in $fam_names;\
{  mv $group/$i.msf $i\_$group.msf; mv $group/$i.tfa $i\_$group.fa;mview -in msf -out fasta $i\_$group.msf > $i\_$group.fa.ref; } ;\
rm -rf $group ;}

cd ..
echo "Balibase downloaded!"

#HOMFAM_mafft

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
#OXFam

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
