#!/usr/bin/env perl

##  "mk_dieli-dicts.pl" -- makes storable versions of the Dieli dictionary
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

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  perl script to make storable versions of the Dieli dictionary
##    *  assumes the Sicilian list and the English list are identical
##    *  one is sorted alphabetically by Sicilian word
##    *  other is sorted alphabetically by English word

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

use strict;
use warnings;
use IO::Zlib;
use Storable qw( nstore ) ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  read infiles into a hash that will hold the dictionary
my $sc_dict = "dieli/dieli_sc_utf8.txt.gz" ;
## my $en_dict = "dieli/dieli_en_utf8.txt.gz" ;

##  read SiCilian dictionary
my %dieli_sc = read_sc_dict( $sc_dict ) ; 

##  ##  ##  ##

##  make ENglish dictionary
my %dieli_en = make_en_dict( \%dieli_sc ) ; 

##  make ITalian dictionary
my %dieli_it = make_it_dict( \%dieli_sc ) ;

##  ##  ##  ##  

##  store it all
nstore( \%dieli_sc , '../cgi-lib/dieli-sc-dict' );
nstore( \%dieli_en , '../cgi-lib/dieli-en-dict' );
nstore( \%dieli_it , '../cgi-lib/dieli-it-dict' );


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

##  remove diaresis from vowels
sub rm_diaeresis {
    my $char = $_[0] ;
    $char =~ s/\303\244/a/g;
    $char =~ s/\303\253/e/g;
    $char =~ s/\303\257/i/g;
    $char =~ s/\303\266/o/g;
    $char =~ s/\303\274/u/g;
    $char =~ s/\303\204/A/g;
    $char =~ s/\303\213/E/g;
    $char =~ s/\303\217/I/g;
    $char =~ s/\303\226/O/g;
    $char =~ s/\303\234/U/g;
    return $char ;
}


sub make_en_dict {

    my %dieli_sc = %{ $_[0] } ;
    my %dieli_en ; 
    foreach my $sc_word ( sort keys %dieli_sc ) {	
	for my $i (0..$#{ $dieli_sc{$sc_word} }) {
	    my %sc_hash = %{ ${ $dieli_sc{$sc_word}}[$i] } ; 
	    if ($sc_hash{"en_word"} ne '<br>') {
		push( @{ $dieli_en{$sc_hash{"en_word"}} } , \%sc_hash ) ; 
	    }
	}
    }
    return %dieli_en ;
}

sub make_it_dict {
    
    my %dieli_sc = %{ $_[0] } ;
    my %dieli_it ; 
    foreach my $sc_word ( sort keys %dieli_sc ) {	
	for my $i (0..$#{ $dieli_sc{$sc_word} }) {
	    my %sc_hash = %{ ${ $dieli_sc{$sc_word}}[$i] } ; 
	    if ($sc_hash{"it_word"} ne '<br>') {
		push( @{ $dieli_it{$sc_hash{"it_word"}} } , \%sc_hash ) ; 
	    }
	}
    }
    return %dieli_it ;
}

sub read_sc_dict {

    ##  input
    my $sc_dict = $_[0] ;
    
    ##  hash of arrays of hashes -- to hold the whole dictionary 
    my %dict ;

    ##  array to hold the translations as we read them
    my @holdarray ;
    my $scdhnd = new IO::Zlib;
    $scdhnd->open($sc_dict, "rb") || die "could not read:  $sc_dict";
    while(<$scdhnd>){
	chomp;
	my $line = $_ ; 
	$line =~ s/&#821[67];/_SQUOTE_/g ;
	$line =~ s/'/_SQUOTE_/g ;

	if ($line =~ /<tr align|<\/tr>/) {

	    ##  new or end of entry, so complete the previous entry
	    ##  hash to hold translation
	    if ( ! defined $holdarray[0] ) {
		my $blah = "not defined, do nothing";
	    } else {

		my $sc_word = $holdarray[0] ; 
		my $it_word = $holdarray[2] ; 
		my $en_word = $holdarray[4] ; 

		$sc_word =~ s/^\s+// ; $sc_word =~ s/\s+$// ; $sc_word =~ s/^_SQUOTE_// ; 
		$it_word =~ s/^\s+// ; $it_word =~ s/\s+$// ;
		$en_word =~ s/^\s+// ; $en_word =~ s/\s+$// ;

		$sc_word = rm_diaeresis( $sc_word ) ; 
		$it_word = rm_diaeresis( $it_word ) ; 
		$en_word = rm_diaeresis( $en_word ) ; 

		my %transhash ;  
		$transhash{"sc_word"} = $sc_word ;  $transhash{"sc_part"} = $holdarray[1] ;
		$transhash{"it_word"} = $it_word ;  $transhash{"it_part"} = $holdarray[3] ;
		$transhash{"en_word"} = $en_word ;  $transhash{"en_part"} = $holdarray[5] ;

		##  push translation onto the dictionary hash
		push( @{ $dict{$sc_word} } , \%transhash ) ;

		##  clear out the hold array
		undef( @holdarray );
	    }

	} elsif ( $line !~ /<td>/ ) {
	    my $blah = "do nothing";

	} else {
	    ##  here come the entries
	    my $entry = $line ;
	    $entry =~ s/^.*<td>// ; 
	    $entry =~ s/<\/td>.*$// ; 
	    push( @holdarray , $entry ) ;
	}
    }
    $scdhnd->close ; 

    return %dict ;
}

