
dir=$1 

[[ -z $dir ]] && { echo " parameter compulsory : complete path to the benchmark datasets folder " ; exit 0 ; }

cd $dir 

datasets=`ls`

for dataset in $datasets;{

	cd $dataset;
	
	#creates subsets depending on number of the sequences to align 
	verysmall_small_threshold=100;
	small_medium_threshold=3000;
	medium_large_threshold=10000;
	large_ultralarge_threshold=100000;


	# prepare folders 
	rm_create(){
		 [[ -d $1 ]] && rm -r $1 ;
		 mkdir $1 ;

	};


	rm_create very-small
	rm_create small;
	rm_create medium;
	rm_create large;
	rm_create ultra-large; 



	current="$(pwd)/all"; 
	cd "all"; 
	#echo $current; 

	#adds both (linked) fa and ref file in folder
	add(){

			ln -s $current/$i $dir/$dataset/$1/$i 
			name=`echo $i | awk -F. '{ print $1 }' `
			ref=`ls | grep  "$name.*.ref" `
			for ref_j in $ref;{
				ln -s $current/$ref_j $dir/$dataset/$1/$ref_j 
			}



	};



	# create links
	all_test=`ls *.fa` ;

	for i in $all_test ;{ 
		num_seq=`grep ">" $i | wc -l` ;	
		
		if [ $num_seq -gt $large_ultralarge_threshold ];then
	 		add ultra-large

		elif [ $num_seq -gt $medium_large_threshold ];then
	 		add large

		elif [ $num_seq -gt $small_medium_threshold ];then
	 		add medium

		elif [ $num_seq -gt $verysmall_small_threshold ];then
			add small

		else
			add very-small
		fi;
	};

	cd ../..;
}


echo "Preprocessing numbers completed!"

