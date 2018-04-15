#!/usr/bin/env perl

##  "mk_other-notes.pl" -- makes hash of other parts of speech and adds "linkto"s to the Dieli dictionary
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

use strict;
use warnings;
use Storable qw( retrieve nstore ) ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  input and output files
my $vnotesfile = '../cgi-lib/verb-notes' ; 
my $dieli_sc_dict = '../cgi-lib/dieli-sc-dict' ; 
my $dieli_en_dict = '../cgi-lib/dieli-en-dict' ; 
my $dieli_it_dict = '../cgi-lib/dieli-it-dict' ; 

##  retrieve verb hash
my $vnhash = retrieve( $vnotesfile );
my %vnotes = %{ $vnhash } ;

##  retrieve SiCilian
my %dieli_sc = %{ retrieve( $dieli_sc_dict ) } ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  ADD OTHER PARTS OF SPEECH to HASH of VERBS
##  === ===== ===== == ====== == ==== == =====
##  adding:  {adv} {prep} {pron}
##  -------  ----- ------ ------
##  to add more parts of speech, must also include them 
##  when updating "linktos" at bottom

##  CAUTION:  be careful not to duplicate hash keys!
##  For example, "dintra" is both an adverb and a preposition.
##  To avoid duplication, give a unique hash key to both:
##    *  "dintra_adv"
##    *  "dintra_prep"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"a pedi"} } = (
    dieli => ["a pedi"],
    dieli_en => ["on foot",],
    dieli_it => ["a piedi",],
    notex => ["Avemu a jiri a pedi.",],
    part_speech => "adv", 
    );

%{ $vnotes{"abbastanza_adv"} } = (
    display_as => "abbastanza",
    dieli => ["abbastanza"],
    dieli_en => ["enough","fairly","rather","sufficient",],
    dieli_it => ["abbastanza","alquanto","bastante",],
    notex => ["Parri sicilianu abbastanza beni.",],
    part_speech => "adv", 
    );

%{ $vnotes{"dintra_adv"} } = (
    display_as => "dintra",
    dieli => ["dintra"],
    dieli_en => ["in","indoors","inside",],
    dieli_it => ["dentro",],
    notex => ["Grapi la casedda e talia dintra!",],
    part_speech => "adv", 
    );

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"dintra_prep"} } = (
    display_as => "dintra",
    dieli => ["dintra"],
    dieli_en => ["inside","into","within",],
    dieli_it => ["dentro","dentro a","in",],
    notex => ["Dintra nu biccheri d'acqua t'anniasti",],
    part_speech => "prep", 
    );

%{ $vnotes{"cu_prep"} } = (
    display_as => "cu",
    dieli => ["cu"],
    dieli_en => ["with","by means of",],
    dieli_it => ["con",],
    notex => ["Parru cu tia, to è la curpa.",],
    part_speech => "prep", 
    );

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cui_pron"} } = (
    display_as => "cui",
    dieli => ["cue",],
    dieli_en => ["whoever",],
    dieli_it => ["chi",],
    notex => ["Cu mi voli voli parrari, pò telefunarmi",],
    part_speech => "pron", 
    );

%{ $vnotes{"zoccu"} } = (
    dieli => ["zoccu"],
    dieli_en => ["that which","what",],
    dieli_it => ["ciò che","quello che",],
    notex => ["Zoccu mi dici dici, nun è veru mai.",],
    part_speech => "pron", 
    );

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make the "link tos"
foreach my $key (keys %vnotes) {
    foreach my $dieli (@{ $vnotes{$key}{dieli} }){
	foreach my $index (0..$#{ $dieli_sc{$dieli}}) {
	    ##  only replace the linkto if not already defined "above"
	    ##  "above" should ONLY mean defined in the "mk_dieli-edits.pl" script
	    if ( ! defined ${$dieli_sc{$dieli}[$index]}{"linkto"} ) {
		##  only replace the linkto if its a adverb, preposition or pronoun
		##  {adv} {prep} {pron}
		##  because that's what we're working with here
		my $scpart = ${$dieli_sc{$dieli}[$index]}{"sc_part"} ;
		if ( $scpart eq '{adv}' || $scpart eq '{prep}' || $scpart eq '{pron}' ) {
		    ${$dieli_sc{$dieli}[$index]}{"linkto"} = $key ;
		}
	    }
	}
    }
}

##  make ENglish and ITalian dictionaries
my %dieli_en = make_en_dict( \%dieli_sc ) ;
my %dieli_it = make_it_dict( \%dieli_sc ) ;

##  ##  ##  ##

##  store the verb notes
nstore( \%vnotes , $vnotesfile ) ; 

##  store the dictionaries
nstore( \%dieli_sc , $dieli_sc_dict );
nstore( \%dieli_en , $dieli_en_dict );
nstore( \%dieli_it , $dieli_it_dict );


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

sub replace_part {
    my $hashref = $_[0] ; 
    my $part    = $_[1] ; 
    
    foreach my $lang_part ("sc_part","it_part","en_part") {
	${$hashref}{$lang_part} = "{" . $part . "}" ; 
    }
    return $hashref ;
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

