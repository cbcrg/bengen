
#later on comman line param 

#benchmark_datasets="/home/lsantus/bengen/benchmark_datasets"
benchmark_datasets=$1
create_datasets="/home/lsantus/bengen/create-datasets"
cd $benchmark_datasets


all_datasets=`ls `

echo "id,dataset,size,identity"

for dataset in $all_datasets;{

	cd $dataset;
	#cd "all";

	all_test=`ls *.fa` ;
	for id in $all_test ;{ 
		num_seq=`grep ">" $id | wc -l` ;
		id_nofa=${id:0:-3}

	
		cd $create_datasets
		features_datasets=""
		features_datasets=`find  -name "$dataset-*" `
		feature_value=""
		for feature_file in  $features_datasets;{
			
			feature_temp=`cat $feature_file | grep $id_nofa | cut -d"," -f2`
			feature_value=","$feature_temp
			echo $feature_value
		
		}
	
		echo $id_nofa","$dataset","$num_seq""$feature_value;
		cd "$benchmark_datasets/$dataset";
	}
	cd ..
}



