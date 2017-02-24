/*
 * Copyright (c) 2013-2016, Centre for Genomic Regulation (CRG) and the authors.
 *
 *   This file is part of 'Piper-NF'.
 *
 *   Piper-NF is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Piper-NF is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Piper-NF.  If not, see <http://www.gnu.org/licenses/>.
 */



/*
* Define which file contains the information about which aligner and which score to use
*
*/

params.aligners = "bengen/test-align.txt"
params.scores="bengen/test-score.txt"
params.renderer="csv"
/*
*Define which dataset to use
*
*/

params.datasets_directory="$baseDir/benchmark_datasets"
params.dataset= "balibase"

datasets_home= file(params.datasets_directory)

params.output_dir = ("$baseDir")
params.out = ("output"+".${params.renderer}")


//Reads which aligners to use
boxes = file(params.aligners).readLines().findAll { it.size()>0 }


//Reads which score to use
boxes_score = file(params.scores).readLines().findAll { it.size()>0 }


/* 
 * Creates a channel emitting a tiple for each file in the datase composed 
 * by the following element: 
 * 
 */

dataset_fasta = Channel
            .fromPath("${params.datasets_directory}/${params.dataset}/*.fa")
            .map { tuple( it.parent.name, it.baseName, it ) }



/* 
 * Execute an alignment job for each input sequence in the dataset 
 */

process aln {
  tag "$method"
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
    set score, method, dataset_name, id, file('score.out') into score_output
    
    script :	
    template score

}


/*
* Write CSV output files
*/

process write_output {
  container "pditommaso/dkrbase:1.2"
  tag "$score + $method + $dataset_name"

  input:
  
  set score, method, dataset_name, id, file(scorefile) from score_output

  output:
  file 'output_csv_temp' into  output

  script:

  """
  score_clean=\$(echo $score|cut -d'/' -f2 )
  method_clean=\$(echo $method|cut -d'/' -f2 )
	
  parser.pl \$method_clean $dataset_name $id \$score_clean ${params.renderer} ${scorefile} > output_csv_temp
  """
}




/*
* save the results in one csv file
*/

 output.collectFile(name:"${params.out}" , storeDir:"${params.output_dir}").subscribe{println it.text}


 

/*
* convert output format


process convert_output {

  container "pditommaso/dkrbase:1.2"
  tag "$score + $method + $dataset_name"

  input:
  
  set file(ocsv) from csv

  output:
  file 'output.html' into  output_html

  script:

  if(params.renderer=="html")
  """
  
  CSVtoHTML.pl $ocsv > output.${params.renderer}
  """
}
*/

