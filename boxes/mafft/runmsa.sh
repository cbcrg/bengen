#!/bin/bash
set -o errexit
set -o xtrace
set -o nounset

TASK=${TASK:=normal}
CONT_THREADS=${CONT_THREADS:=1}

case $TASK in
    normal)
    mafft --thread $CONT_THREADS --anysymbol -quiet $CONT_INPUT_FASTA > $CONT_OUTPUT_FILE
    ;;
    
    large)
    mafft --thread $CONT_THREADS --anysymbol --parttree -quiet $CONT_INPUT_FASTA > $CONT_OUTPUT_FILE
    ;;
   
    *)
    echo "Unknown container task: $TASK"
    ;;
esac