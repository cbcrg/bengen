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


params.methods_file ="methods.txt"
methods = file (params.methods_file)

params.cache_file="cache.csv"
 


//Metadata files
params.operations_file="metadata/operations.ttl"
operations= file(params.operations_file)

params.families_file="metadata/families_test.ttl"
families= file(params.families_file)

params.query_file="metadata/query.rq"
query= file(params.query_file)

params.edam_file="metadata/EDAM_1.16.owl"
edam= file(params.edam_file)


//create the file if it does not exist
File f = new File("results.csv");
if(!f.exists())
    f.createNewFile();

params.run ="false"



/*
 * CREATE table run.csv
 */
process create_run {
	
	container "bengen/apache-jena"
	
	input: 
	file edam 
	file families
	file operations
	file query 
	
	output: 	
	file('run_for_channel.csv') into run_table
	

	script: 

	if( "${params.run}" == "false")
	"""
	sparql  -data=$edam -data=$families -data=$operations -query=$query -results=csv| tail -n +2 > run_for_channel.csv
	
	"""
	else 
	
	"""
	cat "$baseDir/${params.run}" > run_for_channel.csv	
	
	"""
}


/*
 * CREATE table results.csv using the run.nf script
 */
process create_results{

   	publishDir "CACHE", mode: 'copy', overwrite: true

	
        input : 
	file(run_file_from_ch) from run_table
	file methods
	
	output: 
	file("${params.cache_file}")

	"""
	run-nf.pl $baseDir $methods "$baseDir/CACHE/${params.cache_file}" $run_file_from_ch "$baseDir/CACHE/${params.cache_file}"
      
	"""
}






