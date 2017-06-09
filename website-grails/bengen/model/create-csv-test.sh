
#ATTENTION --> Hardcoded

##TEST SEQUENCES

path=`pwd`/`echo $0`;
file=$(basename "$path");
bengen=`echo $path | sed "s/\/model\/$file//g"`;
benchmark_datasets="$bengen/benchmark_datasets"
create_datasets="$bengen/create-datasets"
cd $benchmark_datasets

test="$bengen/model/toModel-test.csv"

all_datasets=`ls `

header="id,type,extension,format,dataset,version,count"
echo > $test;

type="edam:data_1233"
extension=".fa"
format="edam:1929"

maxNrsubset=0
for dataset in $all_datasets;{

	cd "$benchmark_datasets/$dataset";


	if [ "$dataset" == "balibase-v4.0"  ];  then {
		version="4.0" ;
	} elif [ "$dataset" == "prefab-v4.0" ]; then {
		version="4.0" ;
	} else  version="1.0"   ; fi



	all_test=`ls *.fa` ;
	for id in $all_test ;{

		num_seq=`grep ">" $id | wc -l` ;
		id_nofa=${id:0:-3}


		cd $create_datasets;
		features_datasets=""

		features_datasets=` find  -name "$dataset-subset*" `
		feature_value=""


		for feature_file in  $features_datasets;{


			feature_temp1=`cat $feature_file | grep $id_nofa | cut -d"," -f2 `
			feature_temp=` echo $feature_temp1 | sed "s/ /,/g"`


			feature_value=$feature_value","$feature_temp
			extra=`echo $feature_value | tr -cd , | wc -c`

			localmaxsub=0
			localmaxsub=$(($localmaxsub+$extra));
			[[ $localmaxsub -gt $maxNrsubset ]] && maxNrsubset=$localmaxsub ;



		}

		echo $id_nofa","$type","$extension","$format","$dataset","$version","$num_seq$feature_value >> $test;

		cd "$benchmark_datasets/$dataset";
	}

}


for ((i=1;i<=$maxNrsubset;i++))
do
	 header=$header",subset";
done

sed -i "1s;^;$header\n;" $test;
