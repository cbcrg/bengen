<!DOCTYPE html>
<html>
<head>
 <meta name="layout" content="main"/>
 <title>BenGen</title>

</head>


<body>


<div id="header"></div>

<div class="main">


  <h2 id="introduction">Introduction</h2>

  <p>BenGen is a containerization and ontology-based benchmarking prototype.</p>

  <h3 id="howdoesitwork">How does it work?</h3>

  <p>Nextflow is the skeleton of Bengen and defines the Benchmarking workflow.</p>

  <p>Aligner tools are stored as Docker images in the Docker hub. A unique ID is assigned to each image. This guarantees the containers immutability and the full replicability of the benchmark over time.  </p>

  <p>Docker provides a container runtime for local and cloud environments. Singularity performs the same role in the context of HPC and supercomputers (eg. Marenostrum).</p>

  <p>GitHub stores and tracks code changes in consistent manner. It also provides a friendly and well-known user interface that would enable third parties to contribute their own tools with ease. <br> </p>

  <p>Moreover the no-SQl database, which is updated in every run of BenGen, allows to store metadata about the methods and their results.</p>

  <p><asset:image src="bg-01.png"  style=""/></p>

  <h2 id="gettingstarted">GETTING STARTED</h2>

  <h3 id="dependencies">Dependencies</h3>

  <p>In order to run bengen on your machine <strong>Docker</strong> and <strong>Nextlfow</strong> need to be installed.</p>

  <ul>
  <li><a href="http://www.docker.com">Docker 1.0</a> </li>

  <li><a href="http://www.nextflow.io">Nextflow 0.18.+</a></li>
  </ul>

  <h3 id="setup">Setup</h3>

  <p>You first need to clone the Bengen repository </p>

  <pre><code>git clone https://github.com/cbcrg/bengen
  </code></pre>

  <p>Then move in the bengen directory and use make to create all the needed images</p>

  <pre><code>cd bengen
  make
  </code></pre>

  <p>Now you are ready to use Bengen!</p>

  <h2 id="runningbengenlocally">RUNNING BENGEN LOCALLY</h2>

  <p>In order to run bengen on your machine after having followed the steps under the "Getting started" section and modified the configuration file you can trigger the computation locally using the following command.</p>

  <pre><code>nextflow run bengen/main.nf
  </code></pre>

  <p><strong>!Tip</strong>
  You can use the -resume command to cache what was already computed. This could happen if you run bengen multiple times.</p>

  <pre><code>nextflow run bengen/main.nf -resume
  </code></pre>

  <hr>

  <h1 id="preprocessing">Preprocessing</h1>

  <h2 id="datasets">Datasets</h2>

  <p>In order to integrate a dataset in the Project you need to follow these steps: </p>

  <ol>
  <li>Download and properly rename the datasets.</li>

  <li>Upload the Datasets on Zenodo.</li>

  <li>Add the link to the dataset folder in Zenodo in the datasetList file.</li>
  </ol>

  <p>Here you can find more details on how to complete them: </p>

  <p>All the reference and test files have to be downloaded, named and stored following some easy rules :</p>

  <ul>
  <li>The reference file must have a suffix “-reference”. Eg: “myFileXY-reference.myEnding” </li>

  <li>The Test file must have a suffix ”-test”. E.g. “myFileXY-test.myEnding”</li>

  <li>There must be a folder called “benchmark_dataset” where all the datasets-folders are stored.</li>

  <li>Every folder has to be named "NAME-vVERSION". Eg: "balibase-v4.0"</li>
  </ul>

  <p><asset:image src="Datasets-organization.png"  style=""/></p>

  <p>The datasets downlad is part of the preprocessing and, as such, can be completed in many different ways.
  As refrerence the MSA's datasets downlaod can be found on GitHub. The solution is implemented in bash.</p>

  <p>By calling the script <a href="https://github.com/cbcrg/bengen/blob/master/bin/downlaodDatasets.sh">downlaodDatasets.sh</a> in the bin folder each file
  is correctly named and stored.
  The script calls every bash script contained in the folder <a href="https://github.com/cbcrg/bengen/tree/master/create-datasets">create-datasets</a>.
  Every script is responsible for downloading one dataset. <br>
  If a new Dataset has to be downlaoded the only thing to do is to add the new bash script inside the create-datasets folder.</p>

  <pre><code>cd bengen/bin
  bash downloadDatasets.sh
  </code></pre>

  <p>After having organized the datasets locally, these have to be published in order for other users to reproduce the results or even test new methods on them.</p>

  <p>So the next step is to upload the datasets on  <a href="http://zenodo.org">Zenodo</a> and add the link of the dataset in the datasetsList.</p>

  <p>By calling "make" every dataset is automatically downloaded and stored so that BenGen can run on them.</p>

  <p><strong>!</strong>   When downloading the datasets you may want to keep in mind that this is a good moment to store some informations about the data themselves in order to include them in the metadata. For example it might be interesting to know in which subset every file was stored.
  For more informations on HOW to store this information you can look at the metadata section.</p>

  <h2 id="metadata">Metadata</h2>

  <p>BenGen is based on a RDF Database : a standardized No-SQL Database. It stores metadata about about every method, scoring function and file in the datasets and all the benchmarking results.</p>

  <p>First the metadata are created with the help of <a href="https://tarql.github.io/">tarql</a> : a CSV to RDF converter.
  Then the information in RDF format are stored in the DB and can be queried using <a href="https://jena.apache.org/tutorials/sparql.html">sparql</a>. The query is already integrated in the BenGen project and the results of every run are automatically stored in the (local) RDF Database.</p>

  <p>Here an example on <strong>how to create the metadata</strong> about methods, scoring functions and datasets.
  This example is built for Multiple Sequence Aligners.</p>

  <ol>
  <li>Collect the metadata in csv format.hese file are the ones with the prefix "toModel" in the <a href="https://github.com/cbcrg/bengen/tree/master/model">model folder</a>. The first line defines a key-label, through which each value in each line can be accessed when converting the file using tarql. In order to make as clear and standaried as possible the metadata structure only definitions from existing ontologies are used ( mainly <a href="http://edamontology.org/page">EDAM</a> ) </li>
  </ol>

  <p>Example of a "toModel" file: </p>

  <pre><code>id,version,label,type,input,output,input_format,output_format,topic,max_count
  bengen/clustalo,1.2.0,bengen/clustalo,edam:operation_0499,edam:data_2976,edam:data_1384,edam:format_1929,edam:format_1984,edam:topic_0091,100
  bengen/mafft,7.309,bengen/mafft,edam:operation_0492,edam:data_2976,edam:data_1384,edam:format_1929,edam:format_1984,edam:topic_0091,10000
  </code></pre>

  <p>In the MSA's case every set of sequences has been annotated. Two scripts (<a href="https://github.com/cbcrg/bengen/blob/master/model/create-csv-reference.sh">create-csv-reference.sh</a> and <a href="https://github.com/cbcrg/bengen/blob/master/model/create-csv-test.sh">create-csv-test.sh</a>) automatically collect the needed information. </p>

  <ol>
  <li>All the informations needed for the metadata creation step are collected in csv format.Now they have to be converted in the RDF (turtle) format. This can be done by writing a mapping in sparql format. A lot of examples can be found in the <a href="https://github.com/cbcrg/bengen/tree/master/model">model folder</a> with the prefix "mapping".</li>
  </ol>

  <p>Example of mapping file : </p>

  <pre><code>PREFIX rdf:  &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;
  PREFIX rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;
  PREFIX edam: &lt;http://edamontology.org/&gt;
  PREFIX void: &lt;http://rdfs.org/ns/void#&gt;
  PREFIX SIO: &lt;http://semanticscience.org/resource/&gt;
  PREFIX doap: &lt;http://usefulinc.com/ns/doap#&gt;

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

  FROM &lt;file:toModel-msa.csv&gt;

  WHERE{
   BIND (URI(CONCAT('http://bengen.com/', ?id, '-', ?version)) AS ?URI)
   BIND (URI(CONCAT('http://bengen.com/', ?input,'-',?input_format,'-', ?max_count)) AS ?URI_INPUT)
   BIND (URI(CONCAT('http://bengen.com/', ?output, '-', ?output_format)) AS ?URI_OUTPUT)
   BIND (CONCAT(?label, '-v', ?version ) AS ?NAMEandVERSION)
  }
  </code></pre>

  <p><strong>Step 0. and 1. in the MSAs case can be done by simply calling the <a href="https://github.com/cbcrg/bengen/blob/master/model/create-metadataDB.sh">create-metadataDB.sh</a> script.</strong> </p>

  <pre><code>cd bengen/model
  bash create-metadata.sh
  </code></pre>

  <ol>
  <li><p>Now a query needs to be created. This defines which method can run on which kind of dataset and which scoring funciton is allowed to score the results. The query has to be written in sparql.Here the MSA's query <a href="https://github.com/cbcrg/bengen/blob/master/metadata/query.rq">example</a>.</p></li>

  <li><p>the <a href="http://github.com/cbcrg/bengen/master/blob/bin/mapping-score.sparql">mapping-score.sparql</a> has to be in the bin folder and contains the instrutions to translate the results which are given in csv format to RDF format in order to add them to the DB.</p></li>
  </ol>

  <pre><code>PREFIX rdf:  &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;
  PREFIX rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;
  PREFIX edam: &lt;http://edamontology.org/&gt;
  PREFIX void: &lt;http://rdfs.org/ns/void#&gt;
  PREFIX SIO: &lt;http://semanticscience.org/resource/&gt;
  PREFIX doap: &lt;http://usefulinc.com/ns/doap#&gt;

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
  </code></pre>

  <p>All the metadata files are store in the <a href="https://github.com/cbcrg/bengen/tree/master/metadata">metadata folder</a>. (The one in turtle, .ttl format).</p>

  <hr>

  <h1 id="contributetotheproject">Contribute to the Project</h1>

  <h2 id="createanewbenchmarkusingbengensworkflow">-CREATE A NEW BENCHMARK USING BENGEN'S WORKFLOW</h2>

  <h3 id="preprocessing-1">Preprocessing</h3>

  <h4 id="1createdockerimagesanduplodthemindockerhubmodifytheimages_dockerfile">1. Create Docker images and uplod them in Dockerhub &amp; Modify the images_docker file</h4>

  <p><strong>i.</strong> Create Docker images locally and upload the to  <a href="https://hub.docker.com/">DockerHub </a>.
  They don't have to be necessarily in the bengen repository in order to work. You can put them in your own repository.</p>

  <p><strong>ii.</strong> Add the list of the images you wish to test to the images_docker file.</p>

  <p>For example: </p>

  <pre><code>bengen/mafft
  bengen/clustalo
  bengen/baliscore
  </code></pre>

  <h4 id="2createanrdfmetadatadatabaseanditsquery">2. Create an RDF metadata Database and its Query</h4>

  <ul>
  <li>Create the RDF DB ( more informations on how to do so under the section "Metadata") and store it into the metadata folder</li>

  <li>Create the query.sparql file : define what can run on what ( more informations on how to do so under the section "Metadata" ) and store it into the bin folder.</li>
  </ul>

  <h3 id="readytorun">Ready to Run!</h3>

  <h4 id="1make">1. Make</h4>

  <pre><code>make
  </code></pre>

  <h4 id="2runitandgetyourresults">2. Run it and get your results</h4>

  <pre><code>nextflow run query.nf
  </code></pre>

  <h2 id="includeanewmethodtotheproject">INCLUDE A NEW METHOD TO THE PROJECT</h2>

  <h3 id="commandlineversion">Command Line version</h3>

  <h4 id="1collectwhatisneeded">1. Collect what is needed :</h4>

  <p><strong>i.</strong> A docker image (uploaded in DockerHub) .
  <strong>ii.</strong>  Template file.
  Input file name has to be : $input
  Output file name has to be : method.out</p>

  <p>Example: </p>

  <pre><code>clustalo -i $input -o method.out --outfmt fasta --force
  </code></pre>

  <p>NOTE : The output format of the method has to be the same format as the input for the scoring function. In case of MSA's output format MUST be a fasta format.</p>

  <p>Many examples how to handle this can be found in the <a href="https://github.com/cbcrg/bengen/tree/master/templates/bengen">templates </a> directory.</p>

  <p><strong>iii.</strong>  Metadata file ( if you are using the automatized version ).
  This is the file that defines your method according to the ontology.
  This can be created online in the BenGen website in the case of MSA's.</p>

  <h4 id="2uploadthedockerimagetodockerhub">2. Upload the docker image to DockerHub</h4>

  <h4 id="3callthescriptbengenbinaddmethodshhere">3. Call the script bengen/bin/addMethod.sh ( <a href="">here</a> )</h4>

  <p>ARGUMENTS: </p>

  <ul>
  <li><strong>-n|--name</strong> =DockerHub<em>repository</em>name/Method<em>name  &emsp; &emsp; _compulsory</em><br></li>

  <li><strong>-m|--metadata</strong>= Complete Path to your Metadata file &ensp;&ensp;  <em>compulsory</em><br></li>

  <li><strong>-t|--template</strong> =Complete Path to your template file &ensp;&ensp; <em>compulsory</em> <br></li>

  <li><strong>--make</strong> No argument. If used, calls the make command creating the image for the new Method locally &ensp;&ensp; <em>optional</em><br></li>
  </ul>

  <h3 id="websiteversion">Website Version</h3>

  <p>The name of the new method ( or scoring function ) , the metadata file and the template file can be uploaded on the website and the extended version of BenGen can be downloaded.</p>

  <p>{Right now it is working but too heavy to downlaod --> Sequences are saved in BenGen --> have to go to Zenodo--> then ready}</p>

  <h2 id="contributetotheproject-1">CONTRIBUTE TO THE PROJECT</h2>

  <p>If you wish to contribute to the project you can integrate your new MSA in the public project.</p>

  <p>You need to follow these steps : </p>

  <ol>
  <li><strong>Clone</strong> the repository and modify it by adding your new MSa</li>

  <li>Do a <strong>pull request</strong> to merge the project</li>

  <li><strong>Upload the docker images</strong> on dockerhub </li>
  </ol>

  <p>Afterwards the maintainer of the project will recieve a notification and accept it if relevant to the project. Then the maintainer triggers the computation and the new results are shown on a public HTML page.
  <br><br></p>

  <p><asset:image src="bg-02.png"  style=""/> </p>

  <h1 id="msasontologydefinition">MSA's Ontology Definition</h1>

  <p>For understanding the metadata you can look up the not human-understandable terms in the ontology websites. A suggested one for EDAM is <a href="https://www.ebi.ac.uk/ols/ontologies/edam">this one</a>. </p>

  <p>Here an overview on how metadata look like, their connection and their meaning.</p>

  <h4 id="msa">MSA :</h4>

  <p><asset:image src="MSA-translated.png"  style=""/></p>

  <h4 id="scoringfunction">Scoring Function:</h4>

  <p><asset:image src="SF-translated.png"  style=""/></p>

  <h4 id="testfile">Test File :</h4>

  <p><asset:image src="TEST-translated.png"  style=""/></p>

  <h4 id="referencefile">Reference File :</h4>

  <p><asset:image src="REFERENCE-translated.png"  style=""/></p>

  <h4 id="dataset">Dataset:</h4>

  <p><asset:image src="DB-translated.png"  style=""/></p>

  <h1 id="websiteinstruction">WEBSITE Instruction</h1>

  <ul>
  <li>Download <a href="https://grails.org/">Grails</a></li>
  </ul>
</div>

</body>
</html>
