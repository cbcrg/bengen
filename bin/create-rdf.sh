home=$1 




cd $home/model  

tarql mapping-msa.sparql 
tarql mapping-sf.sparql | sed '/^@/ d' 
tarql mapping-db.sparql | sed '/^@/ d'




