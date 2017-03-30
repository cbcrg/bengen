tarql mapping-family.sparql | sed "s/\"\(.*:.*\)\"/\1/g " |  sed "s/\(size.*\)\"\(.*\)\"/\1\2/g" 
tarql mapping-threshold.sparql | sed "s/\"\(.*:.*\)\"/\1/g " | sed "s/\(value.*\)\"\(.*\)\"/\1\2/g"

