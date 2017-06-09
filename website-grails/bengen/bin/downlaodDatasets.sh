path=`pwd`/`echo $0`;
file=$(basename "$path");
bengen=`echo $path | sed "s/\/bin\/$file//g"`;

createDataset="$bengen/create-datasets"

scripts=`ls $createDataset | grep ".*.sh"`

for script in $scripts;{ bash $createDataset/$script $bengen ; }
