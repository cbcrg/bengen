#!/usr/bin/env perl

# This script creates from the csv-extended format a two-line input for the tarql parser
# The csv extended format looks like this :
#
# Baliscore, Mafft, Balibase, B10001, TC=0.5, SP=0.6
#
# The output of this script looks like this :
#
#sf,method,db,id,label,value
#Baliscore, Mafft, Balibase, B10001, TC,0.5
#sf,method,db,id,label,value
#Baliscore, Mafft, Balibase, B10001, SP,0.6
#
#( See templates_out directory for more informations).
#
#
# INPUT : The $file is the csv-extended format line


($file)=@ARGV;

my $label;
my $value;

my $label_begin="sf,method,db,id,label,value";
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
