/*
 * Copyright (c) 2013-2017, Centre for Genomic Regulation (CRG) and the authors.
 *
 *   This file is part of 'BENGEN'.
 *
 *   BENGEN is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   BENGEN is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with BENGEN.  If not, see <http://www.gnu.org/licenses/>.
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
Channel
    .fromPath("${params.balibase}/${params.dataset}")
    .map { tuple( it.parent.name, it.baseName, it ) }
    .set { dataset }

/* 
 * The method to be used 
 */ 
boxes = [
  'bengen/tcoffee',
  'bengen/clustalo',
  'bengen/mafft'
]


/* 
 * Execute an alignment job for each input sequence in the dataset 
 */
process aln {
  tag "$method"
  container "$method"
  
  input: 
  each method from boxes
  set group, id, file(fasta) from dataset 
  
  output: 
  set method, group, id, file('aln.{fa,msf}') into alignments
  
  script:
  template method
    
}


/* 
 * Evaluate the alignment score with BaliBase
 */
process score {
    tag "$method"
    container 'bengen/bb3'
    
    input:
    file bali_home
    set method, group, id, file(aln) from alignments
    
    output: 
    set method, group, id, file('bb3.out') into bb3 
    
    // creates a file containing the SP and TC scores 
    """
    ## normalise FASTA alignment to MSF format
    [[ $aln == *.fa ]] && t_coffee -other_pg seq_reformat aln.fa -output msf > aln.msf

    ## assert the `aln.msf` is not empty
    [[ -s aln.msf ]] || ( echo Missing alignment MSF file; exit 1 )

    ## run BALI SCORE
    bali_score $bali_home/$group/${id}.xml aln.msf | grep auto | awk '{ print \$3, \$4 }' > bb3.out

    ## assert the output is not empty
    [[ -s bb3.out ]] || ( echo Missing BB3 score output; exit 1 )
    """

}

bb3.println { method, group, id, file -> "$method $group $id ${file.text.trim()}" }