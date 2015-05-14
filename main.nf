/*
 * Copyright (c) 2013-2014, Centre for Genomic Regulation (CRG) and the authors.
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

// define the dataset to process  
params.dataset = "RV11/BB11001.tfa"

// defines the BALiBASE home path 
params.balibase = "$baseDir/bb3_release"

bali_home = file(params.balibase)

/* 
 * Creates a channel emitting a tiple for each file in the datase composed 
 * by the following element: 
 * 
 * - group i.e. RV11, RV12, etc
 * - id i.e. BB11001, BB11002, etc
 * - fasta file to be aligned  
 * 
 */
dataset = Channel
            .fromPath("${params.balibase}/${params.dataset}")
            .map { tuple( it.parent.name, it.baseName, it ) }

/* 
 * The method to be used 
 */ 
boxes = [
  'bengen/tcoffee',
  'bengen/clustalo'
]


/* 
 * Execute an alignment job for each input sequence in the dataset 
 */
process aln {
  container true
  
  input: 
  each method from boxes
  set group, id, file(fasta) from dataset 
  
  output: 
  set method, group, id, file('aln.msf') into msf_files
  
  """
  # define the container inputs
  CONT_INPUT_FASTA=$fasta
  CONT_OUTPUT_FILE=aln.msf
  
  # invoke the container execution 
  $method 
  """

}


/* 
 * Evaluate the alignment score with BaliBase
 */
process score {
    container 'bengen/bb3'
    
    input:
    file bali_home
    set method, group, id, file(msf) from msf_files
    
    output: 
    set method, group, id, file('bb3.out') into bb3 
    
    // creates a file containing the SP and TC scores 
    """
    bali_score $bali_home/$group/${id}.xml $msf | grep auto | awk '{ print \$3, \$4 }' > bb3.out
    """

}

bb3.println { method, group, id, file -> "$method $group $id ${file.text.trim()}" }