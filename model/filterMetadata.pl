#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;


my ($fileTOFILTER) = @ARGV;


my %hash = ();
my $flag="print";


my $temp;
open( $temp, '>', "temp") or die "Could not open file  $!";




#filter and save in temp 

open IN  ,'<', "$fileTOFILTER" or die "can't open file  for reading: $!";

while( defined( my $line = <IN> ) ){		
	
	if ($line =~ "^<http://bengen"){
		if(!$hash{$line}){
			$flag="print";
			$hash{$line}="true";
		}else{
			$flag="stop";
		}

	}
	if($flag eq "print"){
		print $temp $line;
	}




}





close(IN);
close ($temp);





#overwrite

my $toWrite;
open( $toWrite, '>', "$fileTOFILTER") or die "Could not open file  $!";

open IN  ,'<', "temp" or die "can't open file  for reading: $!";

while( defined( my $line = <IN> ) ){		
	print $toWrite $line;
}

close(IN);
close($toWrite);










