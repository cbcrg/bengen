#!/bin/bash


directory=$(pwd)

cd ..

#Directory where all the datasets are going to be downloaded
[[ -d  "benchmark_datasets" ]]  || mkdir  benchmark_datasets

cd benchmark_datasets


#HOMFAM_Clustalo  

bash $directory/create-datasets/homfam_clustalo.sh 

 
#Prefab

bash $directory/create-datasets/prefab4.sh 


#BaliBase

bash $directory/create-datasets/balibase.sh 

#HOMFAM_mafft

bash $directory/create-datasets/homfam_mafft.sh 

#OXFam

bash $directory/create-datasets/oxfam.sh 
