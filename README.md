# BENGEN

### Introduction

Bengen is a Containerization-based Multiple Sequence Aligners prototype.

It allows to test each selcted MSA in the project on each selected Dataset using each selected scoring function. 

Bengen provides an **elegant structure** for a benchmarking workflow. **Reproducibility** is allowed thanks to Docker containers usage. Moreover it is extremely easy for a user to integrate new MSAs or Scoring functions and **expand the project**.

### How does it work?

Nextflow is the skeleton of Bengen and defines the Benchmarking workflow.

Aligner tools are stored as Docker images in the Docker hub. A unique ID is assigned to each image. This guarantees the containers immutability and the full replicability of the benchmark over time.  

Docker provides a container runtime for local and cloud environments. Singularity performs the same role in the context of HPC and supercomputers (eg. Marenostrum).

GitHub stores and tracks code changes in consistent manner. It also provides a friendly and well-known user interface that would enable third parties to contribute their own tools with ease. <br> 


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

## CONFIGURATION 



## RUNNING BENGEN LOCALLY 
```
nextflow run bengen/main.nf
```


## MODIFY BENGEN 

### Add a Multiple Sequence Aligner 

You can easily integrate your new MSA in Bengen either following a couple of manual steps or using a script that automatically runs those steps.

#### Manually 

#### Using a provided Script
In the bengen directory that you cloned you can find the ** add-aligner.sh **  script


 **-n|--name** =Name of your MSA  &emsp; &emsp; _compulsory_<br>
 **-d|--dockerfile**= Complete Path to your Dockerfile &ensp;&ensp;  _compulsory_<br>
**-t|--template** =Complete Path to your template file &ensp;&ensp; _compulsory_ <br>
**--add** No argument. If called automatically adds the MSA to the aligners.txt file &ensp;&ensp; _optional_<br>
**--make** No argument. If used, calls the make command creating the image for the new MSA &ensp;&ensp; _optional_<br>
Example : 
```
bash add-aligner.sh --name=MSA-NAME -d=/complete/path/to/your/Dockerfile -t=/complete/path/to/your/templatefile --add --make
```

###Contribute to the project
If you wish to contribute to the project you can integrate your new MSA in the public project.

You need to follow these steps : 

1. Clone the repository and modify it by adding your new MSa
2. Do a pull request to merge the project
3. Upload the docker images on dockerhub 

Afterwards the maintainer of the project will recieve a notification and accept it if the modification is relevant to the project. Then the maintainer triggers the computation and the new reults are going to be shown on a public HTML page.
<br>
![alt tag](https://github.com/luisas/prova/blob/master/Bengen2.0.png)
