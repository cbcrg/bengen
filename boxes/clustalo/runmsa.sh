#!/bin/bash
set -o errexit
set -o xtrace
set -o nounset

TASK=${TASK:=normal}
CONT_THREADS=${CONT_THREADS:=1}

case $TASK in
    normal)
    clustalo -i $CONT_INPUT_FASTA -o $CONT_OUTPUT_FILE --threads $CONT_THREADS --force 2> clustalo_log
    ;;
    
#    large)
#    mafft --thread $CONT_THREADS --anysymbol --parttree -quiet $CONT_INPUT_FASTA > $CONT_OUTPUT_FILE
#    ;;
   
    *)
    echo "Unknown container task: $TASK"
    ;;
esac