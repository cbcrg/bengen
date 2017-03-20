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


params.aligners_file ="aligners.txt"
aligners_f = file (params.aligners_file)

params.result_file="results.csv"
result_f= file(params.result_file)

params.run_file ="run.csv"
run_f = file(params.result_file)
 

params.rdf_file="myrdf.ttl"
rdf_f= file(params.rdf_file)

params.query_file="query.rq"
query_f= file(params.query_file)

params.constraints_file="constraints.txt"
constraints_f= file(params.constraints_file)


/*
* CREATE Metadata complete file 
* 
*/

process get_metadata{

  

  output: 
  
  set file('toModel-msa1.csv'), file('toModel-sf1.csv'), file('toModel-db1.csv') into metadata_csv

  """

  cat "$baseDir/model/toModel-msa.csv" > toModel-msa1.csv
  cat "$baseDir/model/toModel-sf.csv" > toModel-sf1.csv
  cat "$baseDir/model/toModel-db.csv" > toModel-db1.csv
  """



}





/*
* CREATE RDF from Metadata
*/


process create_rdf{

  input: 
  set file(msa), file(sf), file(db) from metadata_csv	 
  
  output: 
  file('myrdf.ttl') into rdf_db

  """

  create-rdf.sh "$baseDir" >  myrdf.ttl
	
  """



}




/*
* CREATE query file 
*/

process create_query {

	input: 
	file constraints_f
	file (rdf_db) from rdf_db
	
	output: 
	set file('query1.rq'), file(rdf_db) into query_ttl
	
	
	"""
	
        request=`cat "$constraints_f"`

	cat "$baseDir/${params.query_file}" | sed "s/#insert here#/\$request/g" > query1.rq
		
	"""


}






/*
* CREATE table run.csv
*/


process create_run {
	
	//container: "bengen/sparql"

	input: 
	
	set file (query), file (rdf_db) from query_ttl 
	
	
	output: 
	
	file('run.csv') into run_table
	
	"""
	sparql -data=$rdf_db -query=$query -results=csv| tail -n +2 > run.csv
	
	"""


}




/*
* CREATE table results.csv
*/


process create_results{

	publishDir baseDir

        input : 

	file(run) from run_table
	file aligners_f

        
	"""
	run-nf.pl $baseDir $aligners_f $baseDir/${params.result_file} $run
      
	"""


}





