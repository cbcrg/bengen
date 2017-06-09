/*
 * Copyright (c) 2013-2017, Centre for Genomic Regulation (CRG) and the authors, Luisa Santus, Maria Chatzou and Paolo Di Tommaso.
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


import java.io.FileWriter;



//Metadata files and Query
operations= file("$baseDir/metadata/operations.ttl")
families= file("$baseDir/metadata/families_split_test.ttl")
scores_file=file( "$baseDir/metadata/scores.ttl" )
edam= file("$baseDir/metadata/EDAM_1.16.owl")
query_original= file("metadata/query.rq")

//Other files needed
bengen_proj =file("$baseDir")
script=file("$baseDir/bin/mapping-score.sparql")
split_script = file ("$baseDir/bin/split_onto.groovy")

//Other params
params.splitOntoBy=2
params.force="false"

//Runfile --> if other metadata procedure has to be introduced.
params.run ="false"
run_file=file(params.run)

//Create modified-query
query_m= new File("metadata/query_modified.rq");
fileOut = new FileWriter(query_m);
fileOut.write("");
fileOut.write(query_original.text);
fileOut.close();
query=file("metadata/query_modified.rq");

/*
*   Parameters connected to the query file.
*   This part is very tightly connected to the structure of the ontology.
*   Parameters and query modifications have to change depending on the topic.
*
*   Depending on the parameters an appendix is
*/



//----------------------------MSA's Specific-------------------------------------------------//

String appendix = ""


params.method="false"
params.score="false"
params.database="false"
params.id="false"

params.structural="false"
params.tree_based="false"


if( "${params.method}" != "false" ) appendix += "?msa rdfs:label \"${params.method}\".\n"

if( "${params.score}" != "false" ) appendix += "?sf rdfs:label \"${params.score}\".\n"

if( "${params.database}" != "false" ) appendix += "?URI_DATASET rdfs:label \"${params.database}\".\n"

if( "${params.id}" != "false" ) appendix += "?ref edam:data_1066 \"${params.id}\".\n"

if( "${params.structural}" !="false") appendix += "?msa rdf:type edam:operation_0294 ."

if( "${params.tree_based}" != "false" ) appendix += "?msa rdf:type edam:operation_0499 ."

def extendedQuery = query.text.replaceAll("#insert here#","$appendix\n  #insert here#")
query.write(extendedQuery);

//-------------------------------------------------------------------------------------------//



/*
 * Split the families ontology into chunks so that it can be run in parallel
 * ( The split scripts works for the msas --> not for ANY user case )
 * It can just be deleted and instead of passing the channel to the create_run process the file families should be given.
 */



process split_ontology {

	container "bengen/groovy"

	input:
	file families
	file split_script

	output:
	file('fam_split*') into splitted_onto

	"""
	groovy $split_script ${families} ${params.splitOntoBy}
	"""
}


/*
 * CREATE table run.csv --> What has to run
 * If a manually created run.csv class is given the metadata database is queried.
 */
process create_run {

	container "bengen/apache-jena"

	input:
	file edam
	file(families_split) from splitted_onto.flatten()
	file operations
	file query
	file run_file
	file scores_file

	output:
	 file('run_for_channel.csv') into run_table


	script:

	if( "${params.run}" == "false")
	"""
	sparql  -data=$edam -data=$families_split -data=$operations -data=$scores_file -query=$query -results=csv| tail -n +2 > run_for_channel.csv

	"""
	else

	"""
	cat $run_file >> run_for_channel.csv

	"""
}


/*
 * Launch bengen.nf and convert the result into the required format.
 *  Each line of the run file is processed individually (splitText)
 *
 * The convert line Script converts the csv format ouput stored in result into a two-line input for the tarql parser.
 *
 * The csv extended format looks like this :
 *
 * Baliscore, Mafft, Balibase, B10001, TC=0.5, SP=0.6
 *
 * The output of this script looks like this :
 *
 * sf,method,db,id,label,value
 * Baliscore, Mafft, Balibase, B10001, TC,0.5
 * sf,method,db,id,label,value
 * Baliscore, Mafft, Balibase, B10001, SP,0.6
 */

process create_results{

  input :
	file(run_line) from run_table.splitText()
	file(bengen_proj)

	output:
	stdout into results

	"""
	line=`cat ${run_line}` ; IFS=',' ; read -a array <<< "\$line" ;

	sf=\${array[0]}
  msa=\${array[1]}
	db=\${array[2]}
	id=\${array[3]}

	nextflow -q run $bengen_proj/bengen.nf --method \$msa --score \$sf --dataset \$db --id \$id --renderer csv-extended >result

	convertLine.pl result

	"""
}


/*
 * CREATE results in metadata format ( Mapping procedure can be found in the $script file. )
 */


process create_metadata{

      container "bengen/apache-jena"

      input:
      file line from results.splitText( by: 2)
      file script
      file scores_file

      output:

      file("res") into meta

      script:

      """
      [[ grep -c ^@ ${scores_file} > 0 ]] &&   echo "hi"  
      """

}


meta.collectFile().set{collected}

/*
* Append the new results into the scores.ttl file ( Metadata Database ) in order for them to be cached in teh next round.
*/

process update_metadata_file{

   	publishDir "metadata", mode: 'move', overwrite: true

	input:
	file(meta_file) from collected
	file scores_file

	output:
	file "scores.ttl"

	"""
	cat $scores_file > "temp"
	cat $meta_file >> "temp"
	rm $scores_file
	mv "temp" "scores.ttl"
	"""
}
