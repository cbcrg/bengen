#DEPENDENCY : TARQL (APACHE-JENA)


path=`pwd`/`echo $0`;
file=$(basename "$path");
bengen=`echo $path | sed "s/\/model\/$file//g"`;
metadata="$bengen/metadata"
model="$bengen/model"

family_rdf="$metadata/families_test.ttl"
operations_rdf="$metadata/operations.ttl"



update(){
	bash "$model/create-csv-test.sh"
	bash "$model/create-csv-reference.sh"
};


metadata(){
	tarql mapping-msa.sparql  |sed "s/\"\(edam:.*\)\"/\1/g" |  sed "s/\(SIO_000794.*\)\"\(.*\)\"/\1\2/g" > $operations_rdf
	tarql mapping-sf.sparql |sed "s/\"\(edam:.*\)\"/\1/g"| sed '/^@/ d'  >> $operations_rdf
	tarql mapping-db.sparql |sed "s/\"\(.*:.*\)\"/\1/g"| sed '/^@/ d' | sed "s/\(Version.*\)\"\(.*\)\"/\1\2/g" >> $operations_rdf

	tarql mapping-test.sparql | sed "s/\"\(.*:.*\)\"/\1/g " |  sed "s/\(SIO_000794.*\)\"\(.*\)\"/\1\2/g"  >$family_rdf
	tarql mapping-reference.sparql | sed "s/\"\(.*:.*\)\"/\1/g "| sed '/^@/ d' >>$family_rdf

	
};


filter(){

	perl filterMetadata.pl $operations_rdf
	perl filterMetadata.pl $family_rdf


};



if [[ -f $family_rdf || -f $operations_rdf ]]
then
	read -p "Metadata files already exist. Are you sure you want to overwrite them? " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		read -p "Do you want to update the csv test and reference files?  If yes, toModel-test.csv toModel-reference.csv and toModel-db.csv will be overwritten based on the benchmark_datasets folder. " -n 1 -r
	  echo
	  if [[ $REPLY =~ ^[Yy]$ ]]
	  then
			update
		fi
		cd $model
		metadata
		filter

	fi
	echo "Metadata are ready!"
else
	exit
fi
