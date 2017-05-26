# BenGen

## Introduction

BenGen is a containerization and ontology-based benchmarking prototype.


### How does it work?

Nextflow is the skeleton of Bengen and defines the Benchmarking workflow.

Aligner tools are stored as Docker images in the Docker hub. A unique ID is assigned to each image. This guarantees the containers immutability and the full replicability of the benchmark over time.  

Docker provides a container runtime for local and cloud environments. Singularity performs the same role in the context of HPC and supercomputers (eg. Marenostrum).

GitHub stores and tracks code changes in consistent manner. It also provides a friendly and well-known user interface that would enable third parties to contribute their own tools with ease. <br> 

Moreover the no-SQl database, which is updated in every run of BenGen, allows to store metadata about the methods and their results.

![alt tag](https://github.com/luisas/prova/blob/master/bengen_img01.png)



## GETTING STARTED

### Dependencies 
In order to run bengen on your machine **Docker** and **Nextlfow** need to be installed.

* [Docker 1.0](http://www.docker.com) 
* [Nextflow 0.18.+](http://www.nextflow.io)

### Setup 

You first need to clone the Bengen repository 
```
git clone https://github.com/cbcrg/bengen
```

Then move in the bengen directory and use make to create all the needed images
```
cd bengen
make
```
Now you are ready to use Bengen!


## Datasets

In order to integrate a dataset in the Project you need to follow these steps: 

1. Download and properly rename the datasets.
2. Upload the Datasets on Zenodo.
3. Add the link to the dataset folder in Zenodo in the datasetList file.

Here you can find more details on how to complete them: 

All the reference and test files have to be downloaded, named and stored following some easy rules :

*	The reference file must have a suffix “-reference”. Eg: “myFileXY-reference.myEnding” 
*	The Test file must have a suffix ”-test”. E.g. “myFileXY-test.myEnding”
*	There must be a folder called “benchmark_dataset” where all the datasets-folders are stored.
* Every folder has to be named "NAME-vVERSION". Eg: "balibase-v4.0"


![alt tag](https://github.com/cbcrg/bengen/blob/master/images/Datasets-organization.png)


The datasets downlad is part of the preprocessing and, as such, can be completed in many different ways.
As refrerence the MSA's datasets downlaod can be found on GitHub. The solution is implemented in bash.

By calling the script [downlaodDatasets.sh](https://github.com/cbcrg/bengen/blob/master/bin/downlaodDatasets.sh) in the bin folder each file 
is correctly named and stored.
The script calls every bash script contained in the folder [create-datasets](https://github.com/cbcrg/bengen/tree/master/create-datasets).
Every script is responsible for downloading one dataset. <br>
If a new Dataset has to be downlaoded the only thing to do is to add the new bash script inside the create-datasets folder.

```
cd bengen/bin
bash downloadDatasets.sh
```

After having organized the datasets locally, these have to be published in order for other users to reproduce the results or even test new methods on them.

So the next step is to upload the datasets on  [Zenodo](http://zenodo.org) and add the link of the dataset in the datasetsList.

By calling "make" every dataset is automatically downloaded and stored so that BenGen can run on them.












