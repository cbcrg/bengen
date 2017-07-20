# BenGen
## Introduction

BenGen is a containerization and ontology-based benchmarking prototype.


### How does it work?

Nextflow is the skeleton of Bengen and defines the Benchmarking workflow.

Aligner tools are stored as Docker images in the Docker hub. A unique ID is assigned to each image. This guarantees the containers immutability and the full replicability of the benchmark over time.  

Docker provides a container runtime for local and cloud environments. Singularity performs the same role in the context of HPC and supercomputers (eg. Marenostrum).

GitHub stores and tracks code changes in consistent manner. It also provides a friendly and well-known user interface that would enable third parties to contribute their own tools with ease. <br> 

Moreover the no-SQl database, which is updated in every run of BenGen, allows to store metadata about the methods and their results.

![alt tag](https://github.com/cbcrg/bengen/blob/master/images/bg-01.png)



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


## RUNNING BENGEN LOCALLY 

In order to run bengen on your machine after having followed the steps under the "Getting started" section and modified the configuration file you can trigger the computation locally using the following command.

```
nextflow run bengen/main.nf
```
**!Tip**
You can use the -resume command to cache what was already computed. This could happen if you run bengen multiple times.


```
nextflow run bengen/main.nf -resume
```


<hr>


# Preprocessing 
## Datasets

All the reference and test files have to be downloaded, properly re-named and stored.


### Downloading datasets: an Example

The datasets download is part of the preprocessing and, as such, can be completed in many different ways.
In this section it is going to be shown the way datasets are integrated in the project.

First we **created a script for each dataset** in order to download and reorder it after Bengen's structure.
The solution is implemented in bash and here is how it looks like for `homfam_clustalo`: 

```bash
[[ -d  "homfam_clustalo-v1.0" ]]  && rm -rf homfam_clustalo-v1.0

mkdir homfam_clustalo-v1.0
cd homfam_clustalo-v1.0


wget -q http://www.clustal.org/omega/homfam-20110613-25.tar.gz 
tar xf homfam-20110613-25.tar.gz
rm -rf homfam-20110613-25.tar.gz

all_ref=`ls *ref.vie`
fam_names=`for i in $all_ref;{ echo $i | awk -F_ref '{ print $1 }'; }`
for i in $fam_names;{  sed -e s/-//g $i\_ref.vie > $i\_ref.fa ; }
for i in $fam_names;{ cat $i\_test* $i\_ref.fa  > $i.fa; rm $i\_ref.fa; mv $i\_ref.vie $i.fa.ref; }

rm -f *.vie
cd ..
echo "Homfam_clustalo downloaded!"
```

In order to make the downloading and reordering of the dataset as secure as possible, the scripts are stored and run inside a docker image ( bengen/datasets ) where the download happens.

By calling the make command at the very beginning the docker image is automatically downloaded and the whole bechmark_datasets folder copied inside the bengen project. 



### Integratig a new dataset

1. Create a *script* to download it. You can have a look at the example above.
This must be done following some easy rules :

*	The Reference file must have the following syntax: *myFileXY.format.ref*, e.g. `BB11001.xml.ref` 
*	The Test file must have the following syntax: *myFileXY.format*, e.g. `BB11001.fa` 
*	There must be a folder called `benchmark_dataset` where all the datasets-folders are stored.
*   Every dataset-folder has to be named *NAME-vVERSION*. e.g. `balibase-v4.0`

Here you can have an overview on how this should look like: 

![alt tag](https://github.com/cbcrg/bengen/blob/master/images/Datasets-organization.png)

After running the script, Bengen is ready for running on the new Dataset!

If you want to let your script public and, by doing so, enablig other users to downlaod the dataset, you must **create a docker image**, in which your script is run and **stores** all **the datasets-folders** (see description above) in the directory /usr/toCopy INSIDE the docker image. So , for example, inside the the directory /usr/toCopy will contain two subdirectories called balibase-v4.0 and homfam_clustalo-v1.0 which will respectively contain the renamed test and reference files.Eventually, **upload the image on dockerHub**.

Afterwards, **add the name of the image in the file [images_db_docker](https://github.com/cbcrg/bengen/blob/master/images_db_docker)**

Last but not least, metadata files have to be integrated in the project. In the case of multiple sequence aligner you can do this by calling the [create-metadataDB.sh](https://github.com/cbcrg/bengen/blob/master/model/create-metadataDB.sh) script and answering yes when asked is the csv files need to be updated. In this way, metadata are automatically created and integrated in the project. 
**REMEMBER** : for the multiple sequence alignment prototype the test sequences MUST be in fasta format and their ending ".fa". The reference set of sequences can be supported in both xml and fasta format (endings respectively : ".xml.ref" and ".fa.ref".

In the end, make a pull request. After the maintainer's approval the dataset will be automatically downlaoded by calling "make".


**!**   When downloading the datasets you may want to keep in mind that this is a good moment to store some informations about the data themselves in order to include them in the metadata. For example it might be interesting to know in which subset every file was stored.
This extra information are stored in the [extra-info](https://github.com/cbcrg/bengen/tree/master/model/extra-info) folder. You can find more information about this under the section METADATA.


## Metadata


Bengen is based on a RDF database. It stores metadata about about every method, scoring function and file in the datasets and all the benchmarking results.

The metadata are already stored in the [metadata](https://github.com/cbcrg/bengen/tree/master/metadata) folder.

EDAM ([EDAM_1.16.owl](https://github.com/cbcrg/bengen/blob/master/metadata/EDAM_1.16.owl)) is the main ontology, from which definitions and operations are taken for creating the metadata.
In [families.ttl](https://github.com/cbcrg/bengen/blob/master/metadata/families.ttl) metadata about the test and reference sequences are stored.
In [operations.ttl](https://github.com/cbcrg/bengen/blob/master/metadata/operations.ttl) metadata about methods and scoring function are stored.
The Sparql file [query.nf](https://github.com/cbcrg/bengen/blob/master/query.nf) will be used by bengen to query the metadata and find the possible running triplets (SequenceFile, method, scoring function).

In order to create the metadata files the [create-metadataDB.sh](https://github.com/cbcrg/bengen/blob/master/model/create-metadataDB.sh) script was used.

### How Metadata are created

First the metadata are created with the help of [tarql](https://tarql.github.io/) : a CSV to RDF converter.
Then the information in RDF format are stored in the DB and can be queried using [sparql](https://jena.apache.org/tutorials/sparql.html). The query is already integrated in the BenGen project and the results of every run are automatically stored in the (local) RDF Database.

Here an example on **how to create the metadata** about methods, scoring functions and datasets.
This example is built for Multiple Sequence Aligners.

0. Collect the metadata in csv format. These file are the ones with the prefix "toModel" in the [model folder](https://github.com/cbcrg/bengen/tree/master/model). The first line defines a key-label, through which each value in each line can be accessed when converting the file using tarql. In order to make as clear and standaried as possible the metadata structure only definitions from existing ontologies are used ( mainly [EDAM](http://edamontology.org/page) ) 

Example of a "toModel" file: 
```
id,version,label,type,input,output,input_format,output_format,topic,max_count
bengen/clustalo,1.2.0,bengen/clustalo,edam:operation_0499,edam:data_2976,edam:data_1384,edam:format_1929,edam:format_1984,edam:topic_0091,100
bengen/mafft,7.309,bengen/mafft,edam:operation_0492,edam:data_2976,edam:data_1384,edam:format_1929,edam:format_1984,edam:topic_0091,10000
```

In the MSA's case every set of sequences has been annotated. Two scripts ([create-csv-reference.sh](https://github.com/cbcrg/bengen/blob/master/model/create-csv-reference.sh) and [create-csv-test.sh](https://github.com/cbcrg/bengen/blob/master/model/create-csv-test.sh)) automatically collect the needed information and create the toModel file. 

1. All the informations needed for the metadata creation step are collected in csv format. Now they have to be converted in the RDF (turtle) format. This can be done by writing a mapping in sparql format. A lot of examples can be found in the [model folder](https://github.com/cbcrg/bengen/tree/master/model) with the prefix "mapping".

Example of mapping file : 

```
PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX edam: <http://edamontology.org/> 
PREFIX void: <http://rdfs.org/ns/void#> 
PREFIX SIO: <http://semanticscience.org/resource/>
PREFIX doap: <http://usefulinc.com/ns/doap#>

CONSTRUCT {
  
    ?URI a ?type;
	 rdfs:label ?NAMEandVERSION;
	 edam:has_input ?URI_INPUT;
	 edam:has_output ?URI_OUTPUT ;	
         edam:has_topic ?topic.
	

   ?URI_INPUT a ?input; 
	      	
	      #Thought to be the MAXIMAL number of sequence the MSA can align. Depends on the Query.	
	      SIO:SIO_000794 ?max_count;
              edam:has_format ?input_format.
  
   ?URI_OUTPUT a ?output;
 	       edam:has_format ?output_format.
		

	 
  }

FROM <file:toModel-msa.csv>

WHERE{
 BIND (URI(CONCAT('http://bengen.com/', ?id, '-', ?version)) AS ?URI)
 BIND (URI(CONCAT('http://bengen.com/', ?input,'-',?input_format,'-', ?max_count)) AS ?URI_INPUT)
 BIND (URI(CONCAT('http://bengen.com/', ?output, '-', ?output_format)) AS ?URI_OUTPUT)
 BIND (CONCAT(?label, '-v', ?version ) AS ?NAMEandVERSION) 
}

```


**Step 0. and 1. in the MSAs case can be done by simply calling the [create-metadataDB.sh](https://github.com/cbcrg/bengen/blob/master/model/create-metadataDB.sh) script.** 

```
cd bengen/model
bash create-metadataDB.sh
```

2. Now a query needs to be created. This defines which method can run on which kind of dataset and which scoring funciton is allowed to score the results. The query has to be written in sparql.Here the MSA's query [example](https://github.com/cbcrg/bengen/blob/master/metadata/query.rq).

3. the [mapping-score.sparql](http://github.com/cbcrg/bengen/master/blob/bin/mapping-score.sparql) has to be in the bin folder and contains the instrutions to translate the results which are given in csv format to RDF format in order to add them to the DB.


```
PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX edam: <http://edamontology.org/>
PREFIX void: <http://rdfs.org/ns/void#>
PREFIX SIO: <http://semanticscience.org/resource/>
PREFIX doap: <http://usefulinc.com/ns/doap#>

CONSTRUCT {

   ?URI a edam:data_1772 ;
	 rdfs:label ?label;
	 edam:is_output_of ?method;
	 edam:is_output_of ?sf;
   edam:is_output_of ?db;
	 edam:is_output_of ?id;
	 edam:isDefinedBy ?URI_DEF;
   rdf:value ?value;



  }

WHERE{
 BIND (URI(CONCAT('http://bengen.com/',?label,'-' ,?method, '-', ?sf,'-', ?db,'-', ?id)) AS ?URI)
 BIND (URI(CONCAT('http://bengen.com/', ?method, '-', ?sf,'-', ?db,'-', ?id)) AS ?URI_DEF)
}
```

All the metadata files are store in the [metadata folder](https://github.com/cbcrg/bengen/tree/master/metadata). (The one in turtle, .ttl format).


<hr>


# Contribute to the Project


## -CREATE A NEW BENCHMARK USING BENGEN'S WORKFLOW

### Preprocessing

#### 1. Create Docker images and uplod them in Dockerhub & Modify the images_docker file

**i.** Create Docker images locally and upload the to  [DockerHub ](https://hub.docker.com/).
They don't have to be necessarily in the bengen repository in order to work. You can put them in your own repository.

**ii.** Add the list of the images you wish to test to the images_docker file.

For example: 
```
bengen/mafft
bengen/clustalo
bengen/baliscore
```

#### 2. Create an RDF metadata Database and its Query

 * Create the RDF DB ( more informations on how to do so under the section "Metadata") and store it into the metadata folder
 * Create the query.sparql file : define what can run on what ( more informations on how to do so under the section "Metadata" ) and store it into the bin folder.
 



### Ready to Run! 

#### 1. Make

```
make
```

#### 2. Run it and get your results 

```
nextflow run query.nf
```


##  INCLUDE A NEW METHOD TO THE PROJECT

### Command Line version

#### 1. Collect what is needed : 

**i.** A docker image (uploaded in DockerHub) .
**ii.**  Template file.
Input file name has to be : $input
Output file name has to be : method.out

Example: 

```
clustalo -i $input -o method.out --outfmt fasta --force

```

NOTE : The output format of the method has to be the same format as the input for the scoring function. In case of MSA's output format MUST be a fasta format.

Many examples how to handle this can be found in the [templates ](https://github.com/cbcrg/bengen/tree/master/templates/bengen) directory.


**iii.**  Metadata file ( if you are using the automatized version ).
This is the file that defines your method according to the ontology.
This can be created online in the BenGen website in the case of MSA's.

#### 2. Upload the docker image to DockerHub 

#### 3. Call the script bengen/bin/addMethod.sh ( [here]() ) 

ARGUMENTS: 

 * **-n|--name** =DockerHub_repository_name/Method_name  &emsp; &emsp; _compulsory_<br>
 * **-m|--metadata**= Complete Path to your Metadata file &ensp;&ensp;  _compulsory_<br>
 * **-t|--template** =Complete Path to your template file &ensp;&ensp; _compulsory_ <br>
 * **--make** No argument. If used, calls the make command creating the image for the new Method locally &ensp;&ensp; _optional_<br>


### Website Version

The name of the new method ( or scoring function ) , the metadata file and the template file can be uploaded on the website and the extended version of BenGen can be downloaded.

{Right now it is working but too heavy to downlaod --> Sequences are saved in BenGen --> have to go to Zenodo--> then ready}


## CONTRIBUTE TO THE PROJECT
If you wish to contribute to the project you can integrate your new MSA in the public project.

You need to follow these steps : 

1. **Clone** the repository and modify it by adding your new MSa
2. Do a **pull request** to merge the project
3. **Upload the docker images** on dockerhub 

Afterwards the maintainer of the project will recieve a notification and accept it if relevant to the project. Then the maintainer triggers the computation and the new results are shown on a public HTML page.
<br><br>


![alt tag](https://github.com/cbcrg/bengen/blob/master/images/bg-02.png)


# MSA's Ontology Definition

For understanding the metadata you can look up the not human-understandable terms in the ontology websites. A suggested one for EDAM is [this one](https://www.ebi.ac.uk/ols/ontologies/edam). 

Here an overview on how metadata look like, their connection and their meaning.

#### MSA : 


![alt tag](https://github.com/cbcrg/bengen/blob/master/images/MSA-translated.png)

#### Scoring Function: 


![alt tag](https://github.com/cbcrg/bengen/blob/master/images/SF-translated.png)


#### Test File : 


![alt tag](https://github.com/cbcrg/bengen/blob/master/images/TEST-translated.png)


#### Reference File :


![alt tag](https://github.com/cbcrg/bengen/blob/master/images/TEST-translated.png)


#### Dataset: 


![alt tag](https://github.com/cbcrg/bengen/blob/master/images/DB-translated.png)


# WEBSITE Instruction

* Download [Grails](https://grails.org/)







