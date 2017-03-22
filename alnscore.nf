/*
 * Copyright (c) 2013-2017, Centre for Genomic Regulation (CRG) and the authors.
 *
 *   This file is part of 'Bengen'.
 *
 *   Bengen is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Bengen is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Bengen.  If not, see <http://www.gnu.org/licenses/>.
 */

// IMPORT
import groovy.text.*
import java.io.*


params.json="false"
params.csv="false"
params.html="false"

if("$params.json" == true ){ params.renderer="json"}
else if ("$params.html" == true){params.renderer="html" }
else{params.renderer="csv" }


 
params.aligners = "$baseDir/aligners.txt"
params.scores="$baseDir/scores.txt"
params.dataset="*"

params.datasets_directory="$baseDir/benchmark_datasets"
datasets_home= file(params.datasets_directory)


params.output_dir = ("$baseDir/output")
params.out = ("output"+".${params.renderer}")



//per default uses the files aligners.txt and scores.txt
//if asked in the command line one aligner and one scoring function can be used
params.score="false"
params.aligner="false"



/* 
 * Define the scores to be used, depending on command line parameters
 * 
 */

if( "${params.score}" == "false"){
  boxes_score = file(params.scores).readLines().findAll { it.size()>0 }	
}
else {
  boxes_score=["bengen/$params.score"]
}


/* 
 * Define the aligners to be used, depending on command line parameters
 * 
 */

if( "${params.aligner}" == "false"){
  boxes = file(params.aligners).readLines().findAll { it.size()>0 }	
}
else{
  boxes=["bengen/$params.aligner"]
}





/* 
 * Creates a channel emitting a triple for each file in the datase composed 
 * by the following element: 
 *
 * -Name of the dataset (e.g. Balibase,Oxfam..)
 * -Name of the file (e.g. B11001_RV11 )
 * -the file itself
 * 
 */

dataset_fasta = Channel
            .fromPath("${params.datasets_directory}/${params.dataset}/*.fa")
            .map { tuple( it.parent.name, it.baseName, it ) }



/* 
 * Execute an alignment job for each input sequence in the dataset 
 */

process aln {
  tag "$method, $dataset_name"
  container "$method"
  
  input: 
  each method from boxes
  set dataset_name, id, file(fasta) from dataset_fasta 
  
  
  output: 
  set method, dataset_name, id, file('aln.fa') into alignments
  
  script:
  template method

  
}

/* 
 * Extract all sequences there is a reference for
 */

process extract_subaln {
  tag "$method"
  container "$method"
  
  input: 
  set method, dataset_name, id, file(aln) from alignments

  file datasets_home 
  
  
  output: 
  set method, dataset_name, id, file('aln.fa') into extracted_alignments
  
  """
  extract_aln.pl $datasets_home/${dataset_name}/${id}.fa.ref $aln
  """
}


/* 
 * Evaluate the alignment score 
 */

process score {
    tag "$score + $method + $dataset_name"
    container "$score"
    
    input: 
    set method, dataset_name, id, file(aln) from extracted_alignments
    each score from boxes_score
    file datasets_home  
    

    output: 
    set score, method, dataset_name, id, file('score.out')  into score_output
    
    script :	
    template score

}

/* 
 * Create the output file 
 */

def map =[]


score_output.subscribe onNext:  {  score, method, dataset, id ,file->  map << [score: score, method: method,dataset:dataset,id:id,scores:scoreFileParser(file.toString(),score)] },
onComplete: { def allResults = [all:map]; createOutput("${params.renderer}", allResults, "${params.output_dir}/${params.out}");  }


def createOutput(String format, allResults, outputPath){
	//create the file template
	def f = new File("$baseDir/templates_output/"+format+".txt") ;
	def template = new SimpleTemplateEngine().createTemplate(f.text).make(allResults);
	
	//write the file
	def destination = new BufferedWriter(new FileWriter(outputPath));	
	template.writeTo(destination);
	destination.close();

	
	//print for testing
	print "${template.toString()}";
}


def scoreFileParser(String path , String score){

	String fileString = new File(path).text

	scores = fileString.split(";")
	scores_hash = [:]

	scores.each{ 
		temp = it.split("=")	
		scores_hash.put(temp[0],temp[1])	
	}
	return scores_hash; 
}



 
 


