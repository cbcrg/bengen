dir=$1 

cd $dir 


datasets=`ls`
for dataset in $datasets;{

	cd $dataset;
	current=$(pwd)
	#creates subsets depending on number of the sequences to align 

	small_medium_threshold=3000;
	medium_large_threshold=10000;


	# prepare folders 
	rm_create(){
		 [[ -d $1 ]] && rm -r $1 ;
		 mkdir $1 ;

	};



	rm_create small;
	rm_create medium;
	rm_create large;



	
	#adds both (linked) fa and ref file in folder
	add(){

			ln -s $current/$i $dir/$dataset/$1/$i 
			name=`echo $i | awk -F. '{ print $1 }' `
			ref=`ls $name.*.ref`
			ln -s $current/$ref $dir/$dataset/$1/$ref 


	};



	# create links
	all_test=`ls *.fa` ;

	for i in $all_test ;{ 
		num_seq=`grep ">" $i | wc -l` ;	
	
		if [ $num_seq -gt $medium_large_threshold ];then
	 		add large

		elif [ $num_seq -gt $small_medium_threshold ];then
			add medium

		else
			add small
		fi;
	};

	cd ..;
}

