
bengen=$1
benchmarkPath="$bengen/benchmark_datasets"
cd $benchmarkPath
[[ -d  "prefab-v4.0" ]]  && rm -rf prefab-v4.0

mkdir prefab-v4.0
cd prefab-v4.0



wget -q http://www.drive5.com/muscle/downloads_prefab/prefab4.tar.gz
tar xf prefab4.tar.gz
rm -rf prefab4.tar.gz

cd in
fam_names=`ls *`
cd ..
for i in $fam_names;{  mv in/$i $i.fa; mv ref/$i $i.fa.ref; }

rm -rf info/ in/ ref/ src/ inw/


cd ..
echo "Prefab downloaded!"
