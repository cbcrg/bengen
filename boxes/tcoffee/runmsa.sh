#!/bin/bash
set -o errexit
set -o xtrace
set -o nounset

TASK=${TASK:=normal}
CONT_THREADS=${CONT_THREADS:=1}

case $TASK in
    normal)
    t_coffee -multi_core=$CONT_THREADS -in=$CONT_INPUT_FASTA -output msf -run_name __aln &> tcoffee_log
    mv __aln.msf $CONT_OUTPUT_FILE
    ;;
    
#    large)
#    mafft --thread $CONT_THREADS --anysymbol --parttree -quiet $CONT_INPUT_FASTA > $CONT_OUTPUT_FILE
#    ;;
   
    *)
    echo "Unknown container task: $TASK"
    ;;
esac