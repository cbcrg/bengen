#!/bin/bash

#No directory with the name benchmark_datasets should already exist in directory the script is executed
directory=$(pwd)

cd ..

#Directory where all the datasets are going to be downloaded
[[ -d  "benchmark_datasets" ]]  || mkdir  benchmark_datasets

cd benchmark_datasets


#HOMFAM_Clustalo  

bash $directory/homfam_clustalo.sh

 
#Prefab

bash $directory/prefab4.sh


#BaliBase

bash $directory/balibase.sh

#HOMFAM_mafft

bash $directory/homfam_mafft.sh

#OXFam

bash $directory/oxfam.sh
