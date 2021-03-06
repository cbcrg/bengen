#!/usr/bin/env nextflow

/*
 * Copyright (c) 2013-2018, Centre for Genomic Regulation (CRG) and the authors, Luisa Santus, Maria Chatzou and Paolo Di Tommaso.
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

params.newBase="$baseDir"
params.dataset_folder="benchmark_datasets_demo"
params.methods = "$baseDir/DEMO/methods_demo.txt"
params.scores="$baseDir/DEMO/scores_demo.txt"
params.dataset="*"

params.output_dir = ("$baseDir/output")
params.out = ("output"+".${params.renderer}")

//deafult values
params.subset="false"
params.id="false"
file= "*"


//Set the path to the files to be analyzed depending on the command line commands
if( "${params.id}" != "false"){ file= "${params.id}"}




/*
 * Creates a channel emitting a triple for each file in the datase composed
 * by the following element:
 *
 * -Name of the dataset (e.g. Balibase,Oxfam..)
 * -Name of the file (e.g. B11001_RV11 )
 * -the file itself
 *
 */
params.datasets_directory="$baseDir/${params.dataset_folder}/${params.dataset}"
datasets_home= "$baseDir/${params.dataset_folder}/${params.dataset}"


dataset_fasta = Channel
	.fromPath("${params.datasets_directory}/${file}.fa")
	.map { tuple(it.parent.name, it.baseName, it ) }



//per default uses the files methods.txt and scores.txt
//if asked in the command line one aligner and one scoring function can be used
params.score="false"
params.method="false"



/*
 * Define the scores to be used, depending on command line parameters
 *
 */

if( "${params.score}" == "false"){
  boxes_score = file(params.scores).readLines().findAll { it.size()>0 }
}
else {
  boxes_score=["$params.score"]
}


/*
 * Define the aligners to be used, depending on command line parameters
 *
 */

if( "${params.method}" == "false"){
  boxes = file(params.methods).readLines().findAll { it.size()>0 }
}
else{
  boxes=["$params.method"]
}




/*
 * Execute a method job for each input file in the dataset
 */

process run_method {

  publishDir "${params.newBase}/methods_results/$method/$dataset_name/$id"
  tag "$method, $dataset_name, $id"
  container "$method"

  input:
  each method from boxes
  set dataset_name, id, file(input) from dataset_fasta

  output:
  set method, dataset_name, id, file('method.out') into methods_result

  script:
  template method


}

/*
 * Manipulation Step:
 * This step is specific for MSA's manipulation and it extracts the sequences from the alignment, for which there is a reference for.
 *
 * In case the benchmarked methods are nor Multiple sequence aligners this process should not be used.
 * It can be substituted by an equivalent manipulation.
 *
 */

process MANIPULATION_extract_subaln {

  publishDir "${params.newBase}/methods_modified_results/$method/$dataset_name/$id"
  tag "$method"
  container "$method"

  input:
  set method, dataset_name, id, file(aln) from methods_result

  output:
  set method, dataset_name, id, file('method_modified.out') into modified_methods_result


  """
    [[ -f $datasets_home/${id}.fa.ref ]] && extract_aln.pl $datasets_home/${id}.fa.ref $aln  || cp $aln method_modified.out

  """
}


/*
 * Evaluate the score for the ouput of each method
 */

process run_score {
    tag "$score + $method + $dataset_name"
    container "$score"

    input:
    set method, dataset_name, id, file(input) from modified_methods_result
    each score from boxes_score


    output:
    set score, method, dataset_name, id, file('score.out')  into score_output

    script :
    template score

}

/*
 * Create the output file in the required format specified by the renderer parameter.
 * It is based on the groovy SimpleTemplateEngine --> The template's files are stored in the template_output folder.
 *
 * If needed a new template file can be added in the template_ouput folder : NEW_TEMPLATE_NAME.txt .
 * Afterwards it can be automatically used by setting the params.renderer="NEW_TEMPLATE_NAME" (or calling it by the command line --renderer "NEW_TEMPLATE_NAME").
 */

def map =[]


score_output.subscribe onNext:  {  score, method, dataset, id ,file->  map << [score: score, method: method,dataset:dataset,id:id,scores:scoreFileParser(file.toString(),score)] },
onComplete: { def allResults = [all:map]; createOutput("${params.renderer}", allResults, "${params.output_dir}/${params.out}");  }


def createOutput(String format, allResults, outputPath){
	//create the file template
	def f = new File("$baseDir/templates_output/"+format+".txt") ;
	def template = new SimpleTemplateEngine().createTemplate(f.text).make(allResults);

	//write the file
        def outfile = new File(outputPath)
        if( !outfile.parentFile.exists() ) outfile.parentFile.mkdirs()
	def destination = new BufferedWriter(new FileWriter(outfile));
	template.writeTo(destination)
        destination.flush()
	destination.close()


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
