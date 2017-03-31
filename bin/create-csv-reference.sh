#Hardcoded NOT MEANT TO BE REUSED BY USERS! 


#later on comman line parameter 

##REF SEQUENCES

benchmark_datasets="/home/lsantus/bengen/benchmark_datasets"
#benchmark_datasets=$1
create_datasets="/home/lsantus/bengen/create-datasets"
cd $benchmark_datasets


all_datasets=`ls `

echo "id,type,extension,format,dataset,version,identity"

#ATTENTION --> Hardcoded
type="edam:data_1384"







for dataset in $all_datasets;{
	
	if [ "$dataset" == "balibase" ]; then { 
		format="edam:format_2555"; 
		extension=".xml.ref"
	} else  format="edam:format_1984" 
		 extension=".fa.ref" ;
	fi

	cd $dataset;
	#cd "all";

	if [ "$dataset" == "balibase"  ];  then {
		version="4.0" ; 

	} elif [ "$dataset" == "prefab" ]; then {
		version="4.0" ;
		
	} else  version="1.0"   ; fi 



	all_test=`ls *.fa` ;
	
	for id in $all_test ;{ 
		num_seq=`grep ">" $id | wc -l` ;
		id_nofa=${id:0:-3}
		#extension=`echo $id | tail -c -4 `
	
		cd $create_datasets
		features_datasets=""
		#find the subset
		features_datasets=`find  -name "$dataset-identitypercentage*" `
		feature_value=""
		for feature_file in  $features_datasets;{
			
			feature_temp=`cat $feature_file | grep $id_nofa | cut -d"," -f2`
			feature_value=","$feature_temp
		
		}
	
		echo $id_nofa","$type","$extension","$format","$dataset","$version","$num_seq$feature_value;
		cd "$benchmark_datasets/$dataset";
	}
	cd ..
}



