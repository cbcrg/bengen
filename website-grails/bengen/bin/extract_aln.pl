#!/usr/bin/env perl
($subSeq_file, $largeSeq_file)=@ARGV;


if($subSeq_file=~/.*\/(PF.*)\.sp_lib/){  $subSeq_file_name=$1; }
if($largeSeq_file=~/.*\/(.*)\.aln/){  $largeSeq_file_name=$1; }

$out_file="method_modified.out";
$erout_file="$subSeq_file_name"."_error.log";

$i=0;
%hashStru=(); 
open SUBseq, $subSeq_file;
while (<SUBseq>)
{ 
 
    if($_=~/^#.*/){ last; print "####" }
    if($_=~/^>(.*)\n/){ 
	$hashStru{$1}=$i; 
	$i++;
    } 
}
#foreach $key( sort { $hashStru{$a} <=> $hashStru{$b} } (keys %hashStru) ){  print $key."\t".$hashStru{$key}."\n";   }

$/=">";
%hashFinal=(); 
%NOThashFinal=();
open LARGEseq, $largeSeq_file;
$not=0;
while (<LARGEseq>)
{   
    
    $entry=$_;
    chop $entry;
    $entry= ">"."$entry";   
    $entry=~/>(.+?)\n(((.*\n)|(.*))*)/g;
    $title=$1;$sequence=$2;
    #$sequence=~s/\n//g;
    
   
    if ($title ne "")
    {   #$sequence=~s/-//g; $sequence=~s/\n//g; 
	if( exists $hashStru{$title} ){  $hashFinal{$title}=$sequence;  }
	#else{  if($not<40){ $NOThashFinal{$title}=$sequence; $not++; } }
    }
}
$/="\n";

if (%hashFinal){
	open OUT, ">$out_file";
	foreach $key( sort { $hashStru{$a} <=> $hashStru{$b} } (keys %hashStru) ){ print OUT ">".$key."\n".$hashFinal{$key}."\n";  }
	#foreach $key2 (keys %NOThashFinal){ print OUT ">".$key2."\n".$NOThashFinal{$key2}."\n";  }
	close OUT;
}
else{
	##### --- NOT NECESSARY! This is to check if all seqs in lib exist in the large scale MSA --- #####
	open EROUT,">>$erout_file";
	foreach $key( sort { $hashStru{$a} <=> $hashStru{$b} } (keys %hashStru) ){ 
  		if( !exists $hashFinal{$key}) { print EROUT "This sequence didn't exist in the large scale MSA: $key \n"; }
	}
}

