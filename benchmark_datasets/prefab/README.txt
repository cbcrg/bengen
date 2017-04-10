PREFAB v4.0 README.txt
----------------------

These are the subdirectories:

./in		Sequence sets to be used as input (FASTA format).
			This is the "main" set.

./inw		Sequence sets for "weighting" set.

./ref		Reference alignments (FASTA format, FSSP conventions).

./src		Source code for qscore program.

./info		Contains longgap_subset.txt, which specifies the
			"long gap" subset.

Reference sets
--------------

The FSSP FASTA format uses upper case for aligned positions,
lower case for positions that are not aligned. Alignment
quality should be assessed by reference to upper-case
positions only.

Input sets
----------

The ./in directory contains input sequences for the "main"
set. The ./inw directory contains input sequences for the
"weighting" set.

The weighting set re-uses 100 pairs of structures that are
also found in the main set. Note therefore that statistics
obtained using the weighting set are not independent of the
main set, so you can't naively combined the results from
both sets and use them in (e.g.) a rank test statistic.
(This is also true of the Balibase reference sets -- in my
opinion, all published Balibase papers have invalid analysis
for this reason, including my own).

The weighting set has one highly over-represented sub-family.
Methods that do not implement sequence weighting (e.g. Probcons
1.x) weighting tend to perform relatively poorly on this set.

The "long gap" subset is a set of structure pairs that have
gaps of > 10 residues. This could be compared to Balibase
reference 4. Lines in longgap_subset.txt are in this format:

	<structure_pair>;<gap_length>

Sequences in the input files are annotated as follows.

The annotation line is in one of the following two formats:

	>1abcA
	>123|1abcA|gi|12345678

The first format is a PDB identifier and indicates that this is
the sequence of one of the two FSSP structures in the input file.

The second format indicates that this is a similar sequence
to 1abcA found by a PSI-BLAST search of the NCBI NR database.
The fields are as follows:

	123 = PSI-BLAST hit number
	1abcA = Query sequence
	gi|12345678 = NCBI identifier of the hit.

The hit number is from the raw PSI-BLAST output before filtering
to 80% identity and random selection of 24 sequences. This annotation
format is chosen so that the first few characters are unique, to
avoid problems in programs like CLUSTALW and PHYLIP that use a short
prefix of the annotation as a key to the sequence.

Alignment quality scoring
-------------------------

The qscore program (in ./src directory) can be used for alignment
quality scoring. There is a Makefile in that directory, so on
Intel x86 Linux this should build the program:

	cd ./src
	make

If you are using a different platform, you may need to edit the
C++ compiler options in the Makefile, especially those that specify
the CPU type.

Start qscore with no command line, this will give a message
explaining how to use it.

Changes from PREFAB v3
----------------------

Deleted several uninformative or problematic structure pairs. These
include those that were "too easy" (all methods score 1.0), "too hard"
(no method scores > 0.0), and pairs with repeated domains, which
causes some methods to get positive scores and other methods to score
zero (by choosing the "wrong" domain relative to the reference). These
problems should not invalidate results from v3 obtained by proper
statistical anlaysis, but do add noise.

Fixed cases where the sequence of a structure in an input set was
different from the version in the corresponding reference. Differences
were typically adding / deleting an N-terminal M (start codon) or
replacing a wildcard (e.g. X) with an explicit amino acid. Now the
input and reference sequences should be identical for all structures.

Added "weighting" and "long gaps" sets.

Added qscore program.

Bob Edgar
March 2005.
