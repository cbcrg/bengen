#!/bin/bash

small_medium_threshold=1000

medium_large_threshold=5000

all_test=`ls *.fa` 

mkdir small
mkdir medium
mkdir large 

for i in $all_test ;{ 
num_seq=`grep ">" $i | wc -l` ; 
if [ $num_seq > $medium_large_threshold ];then
	ln -s $i large/$i;


}





