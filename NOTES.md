
## CREATE A NEW BENCHMARK USING BENGEN'S WORKFLOW

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
