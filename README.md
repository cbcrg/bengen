# BENGEN

### Introduction

Docker based Multiple sequence aligners benchmark prototype

* Elegant
* Reproducible solution 
* Easy to expand 

## GETTING STARTED




### Dependencies 
In order to run bengen on your machine **Docker** and **Nextlfow** need to be installed.

* [Docker 1.0](http://www.docker.com) 
* [Nextflow 0.18.+](http://www.nextflow.io)

### Setup 

You first need to clone the Bengen repository by running the command : 
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

<div style="	width:100px;
	height:100px;background-color: #b2b2b2;">prova
  prova</div>
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
