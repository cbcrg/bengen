tarql mapping-msa.sparql toModel-msa.csv |sed "s/\"\(.*:.*\)\"/\1/g">db 
tarql mapping-sf.sparql toModel-sf.csv |sed "s/\"\(.*:.*\)\"/\1/g"| sed '/^@/ d'  >> db
tarql mapping-db.sparql toModel-db.csv |sed "s/\"\(.*:.*\)\"/\1/g"| sed '/^@/ d'  >> db




