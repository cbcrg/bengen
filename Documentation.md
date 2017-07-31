
# HOWTOs

Here some instructions are presented on how to complete different task in particular for the MSA's version of BenGen.

## How to create a template file 
There are two different types of template files: for methods and scoring function.

A template file basically contains information about the commandline.

A method recieves as input the **$input**, which in the case of multiple sequence aligner is a set of sequences generally in fasta format; the method must then provide the output in a file called **method.out**.

An example: 
```
muscle -in $input -fastaout method.out
```

A scoring function recieves as test-input **$input**, which is the output of the method; as reference, it will recieve the reference file in the bechmark_datastes folder, for example **$datasets_home/${id}.fa.ref** is in the case of the multiple sequence aligner. Eventually, the scoring function needs to ouptut the result in the file **score.out**.

**!** The output format of the scoring function must be : Id=value;id=value;

An example: 
```
qscore -test $input -ref $datasets_home/${id}.fa.ref -modeler -cline -ignoretestcase -ignorerefcase > score_temp.out
sed 's/Test.*.ref;//g' score_temp.out> score.out
```

![alt tag](https://github.com/cbcrg/bengen/blob/master/images/interface.png)


## How to create a Metadata file

A metadata file can be created in two ways: manually or with the help of the website ( in the MSA's case ).

### Manually 
To manually create a metadata file 2 steps are needed: 

**Step number one**
Create a csv file with the right header: this one can be found as an example in the correposnding csv file e.g. for [multiple sequence aligners](https://github.com/cbcrg/bengen/blob/master/model/toModel-msa.csv) in the model folder. What is needed is an imitation of the csv file, with the new data needed for the new component.

**Step number two**
Use TARQL and the corresponding sparql file for converting it into the right format.

Here an example for the multiple sequence aligners: 

```
tarql [mapping-msa.sparql](https://github.com/cbcrg/bengen/blob/master/model/mapping-msa.sparql) yourTable.csv
```


### Website

On the website under the section help a metadata file can be created for scoring functions and methods, in the MSA's benchmarking context.

## How to download and integrate a new Dataset

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



### Integrating a new dataset

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






## How to use Metadata in a project: a general example.
Integrating metadata in a project is useful for both automation and for a consistent and machine-readable description of the components. While the amount of data to be analyzed and methods to be tested raise, these issues become more relevant in bioinformatics projects; for this reason here a summary is provided on how to create and use metadata so that these information can be used with ease in other projects than BenGen, too.
## Step number 1:
define your needs. The first thing to be done is to clearly define which are the components of the project which need a metadata description and make an informal schema about the main proprieties of these components. In the case of bioinformatics methods, it can be needed, for example, a definition of what the algorithm is (multiple sequence aligner, assembler ..) and which input/output it has.
## Step number 2:
find the right ontology and ontology terms. It is good practice base the creation of metadata on existing ontologies, in order to make the meta- data community-understandable and sharable; this means that the vocabulary of the new metadata should be selected from existing ontologies’ terms. Depending on what the metadata describe, the right ontology must be found. In the case of bioinformatics meth- ods the EDAM [23] ontology can be very useful, which is the one which describes the main components of the BenGen prototype. EBI currently maintains an exhaustive list of ontologies, which can be found at the ”ontologies look up service” [46]. Terms from different ontologies can be combined in the description of a compomnent of the metadata
   
database.
## Step number 3:
create a model. A formal model must be then created. SPARQL is
the perfect tool for this task. A sparql model file will be created for each component which needs metadata information, for example one model for multiple sequence aligners and one model for scoring functions. Under the section ”Material and Methods” a complete description of SPARQL and examples are provided.
## Step number 4:
collect the data. The data to be modelled must be collected and saved in the proper way in a csv format. For this reason, the way columns are called and which information are collected, is based on the previously created SPARQL model file. As described in the ”Material and Methods” section under ”TARQL” the first line of the file, called header, defines the name of the columns, through which the SPARQL file can access the right data to model. The collection of the data can be accomplished in several ways, even manually if this is the easiest way for the user. One common and easy way to do so is to create a script that automatically collects information from the data, as it is done for the test and reference sequences in the BenGen project.
## Step number 5:
use TARQL for modelling. The collected data, which are stored in the CSV file, must be modelled using the SPARQL model. This can be achieved with the help of TARQL (See section ”Material and Methods”).
## Step number 6 :
integrate the metadata in the project and write a query.
When metadata are ready, they can be integrated in the project depending on the specific needs. In the case of BenGen, integrating the metadata database actually means saving the Turtle-format metadata files in the project, so that a query can be run on them whenever needed. One thing that is normally done, when a metadata database is created, is to write a query for them, and this should be written in SPARQL. More details about the SPARQL query language can be found unde the section ”Material and Methods”.

## How the metadata were created in BenGen


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










