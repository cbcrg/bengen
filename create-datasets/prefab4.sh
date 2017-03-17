#Metadata





[[ -d  "prefab4" ]]  && { echo \
$'\n'$'\n'$'\t'SCRIPT NOT EXECUTED \!\!$'\n'\
-------------------------------------$'\n'\
A directory called prefab4 exists already.$'\n'\
Please remove it and all its contents before running the script.$'\n'\
E.g. rm -rf prefab4 $'\n'$'\n' ; exit 0 ;  }

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
