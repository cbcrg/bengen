#!/usr/bin/env perl
($method,$dataset_name,$id,$score,$format,$file)=@ARGV;


open FILE, "<", $file;
$output; 
$result;
$head ="SCORE, ALIGNER, DATASET, FILE,"; 

if($format eq "csv"){

	while($line = <FILE>){ 
		if($score eq "baliscore"){$line =~ s/ /,/g;}
		elsif($score eq "qscore"){$line =~ s/;/,/g ; $line =~ s/Test.*ref,//g; $line =~ s/\w*=//g;}
		elsif($score eq "fastsp"){ $line =~ s/.* //g; $line =~ s/\n/,/g;}
                $result.=$line; 
	}

	if($score eq "fastsp"){$result =~ s/,$/\n/g;}
	$output=$score.",".$method.",".$dataset_name.",".$id.",".$result;

	print $output;
}

elsif($format eq "html"){

       print "<tr>"; 
       print "<td>$score</td><td>$method</td><td>$dataset_home</td><td>$id</td>";
       
	while($line = <FILE>){
	
		if($score eq "baliscore"){$line =~ s/ /,/g;}
		elsif($score eq "qscore"){$line =~ s/;/,/g ; $line =~ s/Test.*ref,//g; $line =~ s/\w*=//g;}
		elsif($score eq "fastsp"){ $line =~ s/.* //g; $line =~ s/\n/,/g;}
                $result.=$line; 
	}
        if($score eq "fastsp"){$result =~ s/,$/\n/g;}

	my @cells= split ',',$result;
	foreach my $cell (@cells)
	    {
	       print "<td>$cell</td>";
	    }
        print "</tr>";


}



 

close FILE;


 
