
#later on comman line parameter 

##TEST SEQUENCES

benchmark_datasets="/home/lsantus/bengen/benchmark_datasets"
#benchmark_datasets=$1
create_datasets="/home/lsantus/bengen/create-datasets"
cd $benchmark_datasets


all_datasets=`ls `

echo "id,type,extension,format,dataset,version,count,subset"

#ATTENTION --> Hardcoded
type="edam:data_1233"
extension=".fa"


format="edam:1929"

for dataset in $all_datasets;{

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

	
		cd $create_datasets
		features_datasets=""
		#find the subset
		features_datasets=`find  -name "$dataset-subset*" `
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



