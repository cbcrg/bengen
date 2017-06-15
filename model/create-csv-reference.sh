#Hardcoded NOT MEANT TO BE REUSED BY USERS!


#later on comman line parameter


path=$(cd $(dirname $0);echo $PWD);
file=$(basename "$path");
bengen=`echo $path | sed "s/\/model//g"`;
benchmark_datasets="$bengen/benchmark_datasets"
create_datasets="$bengen/model/extra-info"
cd $benchmark_datasets

ref="$bengen/model/toModel-reference.csv"


all_datasets=`ls `

echo "id,type,extension,format,dataset,version,identity" > $ref

#ATTENTION --> Hardcoded
type="edam:data_1384"







for dataset in $all_datasets;{

	if [ "$dataset" == "balibase-v4.0" ]; then {
		format="edam:format_2555";
		extension=".xml.ref"
	} else  format="edam:format_1984"
		 extension=".fa.ref" ;
	fi

	cd $dataset;
	#cd "all";

	if [ "$dataset" == "balibase-v4.0"  ];  then {
		version="4.0" ;

	} elif [ "$dataset" == "prefab-v4.0" ]; then {
		version="4.0" ;

	} else  version="1.0"   ; fi



	all_test=`ls *.fa` ;

	for id in $all_test ;{
		num_seq=`grep ">" $id | wc -l` ;

		id_nofa=`echo $id | tail -c -4  `
		#extension=`echo $id | tail -c -4 `

		cd $create_datasets
		features_datasets=""
		#find the subset
		features_datasets=`ls| grep $dataset-identitypercentage `
		feature_value=""
		for feature_file in  $features_datasets;{

			feature_temp=`cat $feature_file | grep $id_nofa | cut -d"," -f2`
			feature_value=","$feature_temp

		}

		echo $id_nofa","$type","$extension","$format","$dataset","$version$feature_value >> $ref;
		cd "$benchmark_datasets/$dataset";
	}
	cd ..
}




db="$bengen/model/toModel-db.csv"
headerDB="name,version"

echo $headerDB > $db

for dataset in $all_datasets;{

	v=$(echo $dataset| cut -d"v" -f2)
	echo $dataset, $v >> $db




}
