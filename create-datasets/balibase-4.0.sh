
bengen=$1
benchmarkPath="$bengen/benchmark_datasets"
subsetPath1="$bengen/create-datasets/balibase-subset1.csv"
subsetPath2="$bengen/create-datasets/balibase-subset2.csv"
cd $benchmarkPath
mkdir temp
[[ -d  "balibase-4.0" ]]  && rm -r balibase-4.0
mkdir balibase-4.0
cd balibase-4.0



subsetTemp="$bengen/create-datasets/balibase-subset3.csv"

echo>$subsetTemp


echo >$subsetPath1;
echo >$subsetPath2; 


declare -a array=("1-5" "9" "10")
arraylength=${#array[@]}

for (( j=1; j<${arraylength}+1; j++ ));
do

	wget -q http://www.lbgi.fr/balibase/BalibaseDownload/BAliBASE_R${array[$j-1]}.tar.gz 
	tar xf BAliBASE_R${array[$j-1]}.tar.gz 
	rm -r BAliBASE_R${array[$j-1]}.tar.gz
	[[ -d  "bb3_release" ]]  && { 	mv bb3_release/* . ; rm -r bb3_release ; rm -r bali_score_src ; }

	[[ -f "README" ]] && rm "README"


	group_names=`dir .`
	for group in $group_names; 
	do {    
		all_ref=`ls $group/*.xml | cut -d'.' -f1| cut -d'/' -f2,3` ;\
  		
		fam_names=`for i in $all_ref;{ echo $i | awk -F. '{ print $1 }'; } ` ;\

		for i in $fam_names;\
		do { mv $group/$i.xml $benchmarkPath/temp/$i.xml.ref;\
		     echo $i","$group >> $subsetPath1;\
		     echo  $i",R"${array[$j-1]} >> $subsetTemp; \
		     mv $group/$i.*tfa $benchmarkPath/temp/$i.fa; } ;\
		done
		rm -r $group ;}


	done


done

mv $benchmarkPath/temp/* .
rm -r $benchmarkPath/temp 


cat $subsetTemp | sort | uniq > $subsetPath2

rm $subsetTemp

echo "Balibase downloaded!"
