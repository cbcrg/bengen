# HOWTOs

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

#### 2. Create an Ontology or directly your own run file and merge them into the bengen repository.



### Ready to Run! 

#### 1. Make

```
make
```

#### 2. Run it and get your results 

```
nextflow run query.nf
```


## - INCLUDE A NEW METHOD TO THE PROJECT

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










