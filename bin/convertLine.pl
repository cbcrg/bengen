#!/usr/bin/env perl
($file)=@ARGV;

my $label; 
my $value; 

my $label_begin="sf,msa,db,id,label,value";
my $value_begin="";

open IN  ,'<', "$file" or die "can't open file  for reading: $!";

while( defined( my $line = <IN> ) ){

	chomp $line; 

	my @splitted= split /,/, $line;
        
	foreach my $i (@splitted) { 
	    chomp $i ; 
	     
	   # $i =~ tr/,//d;	
	    if (index($i, "=") != -1) {
	   		my @splitted_intern= split /=/, $i;
			$value=$value_begin.",".$splitted_intern[0].",".$splitted_intern[1];
                   
			 print $label_begin."\n".$value."\n";
		}
	   else{
		if ($value_begin eq ""){
			$value_begin=$i; 
		}else{
			$value_begin=$value_begin.",$i"
		}
	   }
	} 

}

close(IN);
