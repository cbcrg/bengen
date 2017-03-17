# METADATA...



#HOMFAM_Clustalo  


[[ -d  "homfam_clustalo" ]]  && { echo \
$'\n'$'\n'$'\t'SCRIPT NOT EXECUTED \!\!$'\n'\
-------------------------------------$'\n'\
A directory called homfam_clustalo exists already.$'\n'\
Please remove it and all its contents before running the script.$'\n'\
E.g. rm -rf homfam_clustalo $'\n'$'\n' ; exit 0 ;  }

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
