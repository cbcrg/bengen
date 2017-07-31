# BENGEN

### Introduction

BenGen is a fully reproducible, automatic and scalable benchmarking prototype, which provides consistently annotated and community-sharable results.

BenGen is functional for the benchmarking of multiple sequence aligners, yet can be easily adapted for the benchmarking of other bioinformatics methods.

### How does it work?

Nextflow is the skeleton of Bengen and defines the Benchmarking workflow.

Aligner tools are stored as Docker images and available through the Docker Hub. 
A unique ID is assigned to each image. This guarantees the containers immutability and 
the full replicability of the benchmark over time.  

[Docker](https://www.docker.com/) provides a container runtime for local and cloud environments. 
[Singularity](http://singularity.lbl.gov/) performs the same role in the context of HPC clusters.

An RDF database, based on the EDAM ontology vocabulary, contains metadata information about each component of the benchmark, making possible to automatize the benchmark and provide a consistent and machine-readable description of the incorporated data, algorithms and their results.

GitHub stores and tracks code changes in consistent manner. It also provides a friendly and 
well-known user interface that would enable third parties to contribute their own tools with ease. <br> 

![alt tag](https://github.com/cbcrg/bengen/blob/master/images/bg-meta.png)

## GETTING STARTED

### Dependencies 
In order to run bengen on your machine **Docker** and **Nextflow** need to be installed.

* [Docker 1.11+](http://www.docker.com) 
* [Nextflow 0.18.+](http://www.nextflow.io)

### Setup 

You first need to clone the Bengen repository: 
 
```
git clone https://github.com/cbcrg/bengen
```

Then move in the bengen directory and use make to create all the needed images:

```
cd bengen
make
```

Now you are ready to use Bengen!

## RUNNING BENGEN LOCALLY (automatic modus)

In order to run BenGen on your machine in its automatic mode, after having followed the steps under the *Getting started* section, you can trigger the computation locally using the following command.

```
nextflow run query.nf
```
**!Tip**
You can use the `-resume` command to cache what was already computed. This could happen if you run bengen multiple times.

```
nextflow run query.nf -resume
```

In this way, the Metadata dataset is queried and the datasets, methods and scoring functions are automatically selected and run.

## RUNNING BENGEN LOCALLY (manually)

In order to run BenGen manually, and so define the datasets, scoring functions and methods to be run, the bengen.nf script must be used.

```
nextflow run bengen.nf
```
**!Tip**
You can use the `-resume` command to cache what was already computed. This could happen if you run bengen multiple times.

```
nextflow run bengen.nf -resume
```


The overall benchmark is driven by a **configuration file** that allows the definition of different components 

* `params.dataset`: Defines which dataset to use. Right now only the datasets provided in the `benchmark_dataset` directory are allowed. If you want to use them all you can use: `params.dataset="*"`.
* `params.renderer`: Choose which renderer to use among the ones provided (csv, html, json). 
* `params.out`: choose how the outputfile should be named. 

Example of configuration file content: 
```
docker.enabled = true

params.dataset = "balibase"
params.renderer = "csv"
params.out = "output.${params.renderer}"
```

**Important** 
Inside of the bengen directory you can find the `methods.txt` file and the `scores.txt` file.
They define which aligner to use and which score function to use.
You can modify them by adding/removing lines with the name of the aligners/scores you want to run (eg. bengen/NameOfAlignerOrScore).

Example of `methods.txt`:

```
bengen/mafft
bengen/tcoffee
bengen/clustalo
```

Example of `scores.txt`: 

```
bengen/qscore
bengen/baliscore
```

**!**    You can see **which aligners/scores are already integrated** in the project by looking respectively in the boxes or boxes_score directories. You can find these in the bengen directory.


## MODIFY BENGEN 

### Add a Multiple Sequence Aligner 

You can easily integrate your new MSA in Bengen by using a script that automatically does the work for you.

In the bengen directory that you cloned you can find the `add-aligner.sh`  script. 



ARGUMENTS: 
 * **-n|--name** =Name of your MSA  &emsp; &emsp; _compulsory_<br>
 * **-d|--dockerfile**= Complete Path to your Dockerfile &ensp;&ensp;  _compulsory_<br>
 * **-t|--template** =Complete Path to your template file &ensp;&ensp; _compulsory_ <br>

<br>
Example: 

    bash add-aligner.sh --name=MSA-NAME -d=/complete/path/to/your/Dockerfile -t=/complete/path/to/your/templatefile --add --make


## CONTRIBUTE TO THE PROJECT
If you wish to contribute to the project you can integrate your new MSA in the public project.

You need to follow these steps : 

1. **Clone** the repository and modify it by adding your new MSa
2. Do a **pull request** to merge the project
3. **Upload the docker images** on dockerhub 

Afterwards the maintainer of the project will recieve a notification and accept it if relevant to the project. Then the maintainer triggers the computation and the new results are shown on a public HTML page.
<br><br>
![alt tag](https://github.com/cbcrg/bengen/blob/master/images/bg-02.png)


