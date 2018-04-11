#!/usr/bin/env perl

##  "query-dieli.pl" -- searches the Dieli dictionary
##  Copyright (C) 2018 Eryk Wdowiak
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##  
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <https://www.gnu.org/licenses/>.

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

use strict ;
use warnings ;
use Storable qw( retrieve ) ;

##  what are we looking for?
my $lang = $ARGV[0] ; 
my $deep = $ARGV[1] ;
my @lkup = @ARGV[2..$#ARGV] ; 

##  exit if bad syntax
if ( ! defined $lang || ! defined $deep  || $lang !~ /^sc$|^en$|^it$/ || $deep !~ /largu|strittu/ ) {
    print "\n\t" . './query-dieli.pl [sc|en|it] [largu|strittu] <palora> <palora>' . "\n\n" ;
    exit ;
}

##  retrieve dictionaries
my %dieli_sc = %{ retrieve('../../cgi-lib/dieli-sc-dict' ) } ;
my %dieli_en = %{ retrieve('../../cgi-lib/dieli-en-dict' ) } ;
my %dieli_it = %{ retrieve('../../cgi-lib/dieli-it-dict' ) } ;

##  generate search results
my $ottext ;

foreach my $arg (@lkup) {
    
    $ottext .= "\n" ;

    my @matches ;

    if ( $deep eq "largu" ) {
	if ( $lang eq "sc" ) { @matches = grep(/$arg/, keys(%dieli_sc) );};
	if ( $lang eq "en" ) { @matches = grep(/$arg/, keys(%dieli_en) );};
	if ( $lang eq "it" ) { @matches = grep(/$arg/, keys(%dieli_it) );};
    } else {
	if ( $lang eq "sc" ) { @matches = grep(/^$arg$/, keys(%dieli_sc) );};
	if ( $lang eq "en" ) { @matches = grep(/^$arg$/, keys(%dieli_en) );};
	if ( $lang eq "it" ) { @matches = grep(/^$arg$/, keys(%dieli_it) );};	
    }

    if ( $#matches == -1 ) {
	$ottext .= "\t" . $arg . "  not found\n" ;
    } else {

	foreach my $search (uniq(@matches)) {
	    if ( $lang eq "sc" ) {    
		foreach my $i (0..$#{$dieli_sc{$search}}) {
		    my %th = %{ ${$dieli_sc{$search}}[$i] } ; 
		    $ottext .= "\t" . $i . "  ==  " ;
		    $ottext .= $th{"sc_word"} . " " . $th{"sc_part"} . " --> " ;
		    $ottext .= $th{"it_word"} . " " . $th{"it_part"} . " --> " ;
		    $ottext .= $th{"en_word"} . " " . $th{"en_part"} . "\n" ;
		}
	    } elsif ( $lang eq "en" ) {
		foreach my $i (0..$#{$dieli_en{$search}}) {
		    my %th = %{ ${$dieli_en{$search}}[$i] } ; 
		    $ottext .= "\t" . $i . "  ==  " ;
		    $ottext .= $th{"en_word"} . " " . $th{"en_part"} . " --> " ;
		    $ottext .= $th{"it_word"} . " " . $th{"it_part"} . " --> " ;
		    $ottext .= $th{"sc_word"} . " " . $th{"sc_part"} . "\n" ;
		}
	    } elsif ( $lang eq "it" ) {
		foreach my $i (0..$#{$dieli_it{$search}}) {
		    my %th = %{ ${$dieli_it{$search}}[$i] } ; 
		    $ottext .= "\t" . $i . "  ==  " ;
		    $ottext .= $th{"it_word"} . " " . $th{"it_part"} . " --> " ;
		    $ottext .= $th{"en_word"} . " " . $th{"en_part"} . " --> " ;
		    $ottext .= $th{"sc_word"} . " " . $th{"sc_part"} . "\n" ;
		}
	    }
	}

    }
}
print $ottext . "\n" ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

## tip of the hat to List::MoreUtils for this sub
sub uniq { 
    my %h;  
    map { $h{$_}++ == 0 ? $_ : () } @_;
}

