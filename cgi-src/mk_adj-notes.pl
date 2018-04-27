#!/usr/bin/env perl

##  "mk_adj-notes.pl" -- makes hash of adjectives and adds "linkto"s to the Dieli dictionary
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
my $vnotesfile = '../cgi-lib/vocab-notes' ; 
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

##  ADD ADJECTIVES to VOCABULARY HASH
##  === ========== == ========== ====

%{ $vnotes{"àutru_adj"} } = (
    display_as => "àutru",
    dieli => ["autru",],
    dieli_en => ["different","else",],
    dieli_it => ["altro",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"azzolu_adj"} } = (
    display_as => "azzolu",
    dieli => ["azzolu",],
    dieli_en => ["blue",],
    dieli_it => ["azzurro",],
    ## notex => ["","",],
    part_speech => "adj",
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"azzurru_adj"} } = (
    display_as => "azzurru",
    dieli => ["azzurru",],
    dieli_en => ["azure","blue",],
    dieli_it => ["azzurro",],
    ## notex => ["","",],
    part_speech => "adj",
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"beddu"} } = (
    dieli => ["beddu","bellu"],
    dieli_en => ["beautiful","fair","fine","good-looking","good","handsome","nice","pleasing","pretty",],
    dieli_it => ["avvenente","bello","di bell' aspetto",],
    notex => ["Chista è na bedda cosa!",],
    part_speech => "adj", 
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"bonu"} } = (
    dieli => ["bonu"],
    dieli_en => ["fair","good","nice",],
    dieli_it => ["buono",],
    notex => ["lu bon senzu","la bona cosa",],
    part_speech => "adj", 
    adj => {
	may_precede => 1,
	massi_precede => "bon",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"bruttu_adj"} } = (
    display_as => "bruttu",
    dieli => ["bruttu",],
    dieli_en => ["bad","bad weather","deformed","nasty","ugly",],
    dieli_it => ["brutto","deforme","sgradevole",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"catolicu_adj"} } = (
    display_as => "catolicu",
    dieli => ["catolicu",],
    dieli_en => ["Catholic",],
    dieli_it => ["cattolico",],
    ## notex => ["","",],
    part_speech => "adj",
    );

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cuntenti_adj"} } = (
    display_as => "cuntenti",
    dieli => ["cuntenti",],
    dieli_en => ["content","happy","satisfied",],
    dieli_it => ["contento",],
    ## notex => ["","",],
    part_speech => "adj",
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"giùvini_adj"} } = (
    display_as => "giùvini",
    dieli => ["giuvini","giuvina",],
    dieli_en => ["young boy","young girl",],
    dieli_it => ["giovanotto","giovanotta",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	femsi => "giùvina",
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"granni_adj"} } = (
    display_as => "granni",
    dieli => ["granni",],
    dieli_en => ["adult","grand","great","heavy","large","older","very",],
    dieli_it => ["adulto","grande","grave",],
    notex => ["lu gran omu","na granni vittoria",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
	massi_precede => "gran",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"grossu_adj"} } = (
    display_as => "grossu",
    dieli => ["grossu",],
    dieli_en => ["big","big (stout)","grand","gross","large",],
    dieli_it => ["grosso","grasso",],
    ## notex => ["","",],
    part_speech => "adj",
    );

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"ladiu_adj"} } = (
    display_as => "ladiu",
    dieli => ["ladiu",],
    dieli_en => ["ugly",],
    dieli_it => ["brutto",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"malu_adj"} } = (
    display_as => "malu",
    dieli => ["malu",],
    dieli_en => ["bad","evil","ill","wicked",],
    dieli_it => ["male","cattivo","malvagio",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"megghiu_adj"} } = (
    display_as => "megghiu",
    dieli => ["megghiu","u megghiu",],
    dieli_en => ["better","superior",],
    dieli_it => ["migliore","meglio","maggiore",],
    notex => ["La megghiu cosa è di lassari tuttu com'è.",],
    part_speech => "adj",
    adj => { 
	invariant => 1,
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"nicu_adj"} } = (
    display_as => "nicu",
    dieli => ["nicu",],
    dieli_en => ["child","little","petty","small","toddler","young boy",],
    dieli_it => ["giovane","piccolo","giovanotto",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"nìuru_adj"} } = (
    display_as => "nìuru",
    dieli => ["niuru",],
    dieli_en => ["black","dark","gloomy","negro",],
    dieli_it => ["nero","scuro","cupo","negro",],
    ## notex => ["","",],
    part_speech => "adj",
    );

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"peggiu_adj"} } = (
    display_as => "peggiu",
    dieli => ["peggiu","pèggiu","u peggiu","u pèggiu","peiu","piggiuri","pijuri",],
    dieli_en => ["worse",],
    dieli_it => ["peggio",],
    notex => ["Ora si truva nni na peggiu situazzioni.",],
    part_speech => "adj",
    adj => { 
	invariant => 1,
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pìcciulu_adj"} } = (
    display_as => "pìcciulu",
    dieli => ["picciulu",],
    dieli_en => ["minor","small",],
    dieli_it => ["piccolo",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pòviru_adj"} } = (
    display_as => "pòviru",
    dieli => ["poviru",],
    dieli_en => ["poor","unfortunate",],
    dieli_it => ["povero","sfortunato",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pricisu_adj"} } = (
    display_as => "pricisu",
    dieli => ["pricisu",],
    dieli_en => ["exact","precise",],
    dieli_it => [],
    ## notex => ["","",],
    part_speech => "adj",
    );

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"socialista_adj"} } = (
    display_as => "socialista",
    dieli => ["socialista",],
    dieli_en => ["socialist",],
    dieli_it => ["socialista",],
    ## notex => ["","",],
    part_speech => "adj",
    );

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"stissu_adj"} } = (
    display_as => "stissu",
    dieli => ["stissu",],
    dieli_en => ["own","same","very",],
    dieli_it => ["proprio","stesso",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"tintu_adj"} } = (
    display_as => "tintu",
    dieli => ["tintu",],
    dieli_en => ["bad","corrupt","dyed","evil","inept","not good","wicked","needy",],
    dieli_it => ["tinto","cattivo","misero",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"vecchiu_adj"} } = (
    display_as => "vecchiu",
    dieli => ["vecchiu",],
    dieli_en => ["old","venerable",],
    dieli_it => ["vecchio",],
    ## notex => ["","",],
    part_speech => "adj",
    adj => {
	may_precede => 1,
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"virdi_adj"} } = (
    display_as => "virdi",
    dieli => ["virdi",],
    dieli_en => ["green",],
    dieli_it => ["verde",],
    ## notex => ["","",],
    part_speech => "adj",
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
		##  only replace the linkto if its an adjective
		##  because that's what we're working with here
		if ( ${$dieli_sc{$dieli}[$index]}{"sc_part"} eq '{adj}'  &&  $vnotes{$key}{part_speech} eq 'adj' ) {
		    ${$dieli_sc{$dieli}[$index]}{"linkto"} = $key ;
		}
	    }
	}
    }
}

##  make ENglish and ITalian dictionaries
# my %dieli_en = make_en_dict( \%dieli_sc ) ;
# my %dieli_it = make_it_dict( \%dieli_sc ) ;

##  ##  ##  ##

##  store the verb notes
nstore( \%vnotes , $vnotesfile ) ; 

##  store the dictionaries
nstore( \%dieli_sc , $dieli_sc_dict );
# nstore( \%dieli_en , $dieli_en_dict );
# nstore( \%dieli_it , $dieli_it_dict );


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

