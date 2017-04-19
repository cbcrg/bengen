#!/usr/bin/perl 
use CGI qw/:standard/;
use CGI; 
use strict;
use warnings;
 



my $cgi = CGI->new();

#read parameters
my $name = $cgi->param("name");
my $template = $cgi->param("template");
my $metadata = $cgi->param("metadata");


print header(), start_html(-title   => 'extendBenGen',-style   => [{'src' =>'../bootstrap-3.3.6-dist/css/bootstrap.min.css'}, {'src' =>'../layout.css'}]);

open( my $h, '<', '../header.html'); 
while(<$h>) {
	print  <$h>; 
}
close $h;


#check for input
if( $name eq undef ){
	print p "Input not given!"; 
}


#git clone
`git clone http://github.com/cbcrg/bengen`;
`cd bengen`;

#modify bengen
` add.sh -n $name -t $template -m $metadata`;

#give back the file
print "<form method=\"get\" action=\"bengen\">"
print "<button type=\"submit\">Download now!</button>"
print "</form>"


print end_html();
