#metadata





#Balibase

[[ -d  "balibase" ]]  && { echo \
$'\n'$'\n'$'\t'SCRIPT NOT EXECUTED \!\!$'\n'\
-------------------------------------$'\n'\
A directory called balibase exists already.$'\n'\
Please remove it and all its contents before running the script.$'\n'\
E.g. rm -rf balibase $'\n'$'\n' ; exit 0 ;  }

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
