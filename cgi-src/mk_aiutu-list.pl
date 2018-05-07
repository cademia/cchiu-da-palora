#!/usr/bin/env perl

##  "mk_aiutu-list.pl" -- makes list of words for "Aiùtami!"
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
no warnings qw( uninitialized ) ;
## use utf8 ;
use Encoding::FixLatin qw(fix_latin);
use Storable qw( retrieve nstore ) ;
{   no warnings;             
    $Storable::Deparse = 1;  
    $Storable::Eval    = 1;  
}


##  retrieve dieli dictionary
my $dieli_sc = retrieve('../cgi-lib/dieli-sc-dict' );
my %dieli_sc = %{ $dieli_sc } ; 

##  retrieve hashes and subroutines
my $vthash  = retrieve('../cgi-lib/verb-tools' );
#my $vbconj  = $vthash->{vbconj} ;
my $vbsubs  = $vthash->{vbsubs} ;
#my $nounpls = $vthash->{nounpls} ;

my $vnhash = retrieve('../cgi-lib/vocab-notes' );
my %vnotes = %{ $vnhash } ;

my $cchash = retrieve('../cgi-lib/cchiu-tools' );
#my %ccsubs = %{ $cchash->{ccsubs} } ;
my %ddsubs = %{ $cchash->{ddsubs} } ;

#my $amhash = retrieve('../cgi-lib/aiutu-tools' );
#my %amsubs = %{ $amhash->{amsubs} } ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

## output file 
my $otfile = '../cgi-lib/aiutu-list' ; 

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make list
my %amlist = mk_wants( \%vnotes , $vbsubs , \%dieli_sc , \%ddsubs );

##  store it all
nstore( \%amlist , $otfile );  


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##


##  list of words that we want to annotate
##  what words do you have?  which do you need?
sub mk_wants {

    my %vnotes  = %{ $_[0] } ; 
    my %vbsubs  = %{ $_[1] } ; 
    my %dieli_sc   = %{ $_[2] } ; 
    my %ddsubs  = %{ $_[3] } ; 

    ##  what information do we want to collect?
    ##  store it in a hash 
    my %othash ;
    
    ##  collect what is already annotated -- only want poetry on these
    foreach my $key (sort keys %vnotes) {

	##  hash key (less marker)
	my $palora = $key ;  
	$palora =~ s/_verb$|_noun$|_adj$|_adv$|_prep$|_pron$|_conj$//; 
	
	##  first choice is "display_as",  second choice is hash key (less marker)
	my $display = ( ! defined $vnotes{$key}{display_as} ) ? $palora : $vnotes{$key}{display_as} ; 
	$display =~ s/_SQUOTE_/'/ ; 
	
	##  part of speech
	my $pos = $vnotes{$key}{part_speech} ; 

	my @dieli_en = ( ! defined $vnotes{$key}{dieli_en} ) ? undef : @{$vnotes{$key}{dieli_en}};
	my @dieli_it = ( ! defined $vnotes{$key}{dieli_en} ) ? undef : @{$vnotes{$key}{dieli_it}};
	
	##  we do not need the arrays for this project
	my $trans_dieli_en  =  join( ', ' , @dieli_en );
	my $trans_dieli_it  =  join( ', ' , @dieli_it );
	$trans_dieli_en  =~ s/_SQUOTE_/'/ ; 
	$trans_dieli_it  =~ s/_SQUOTE_/'/ ; 

	##  pass it to %othash, 
	$othash{ $key }{palora} = $display ; 
	$othash{ $key }{part_speech} = $pos ; 
	$othash{ $key }{hashkey} = $key ; 
	$othash{ $key }{notes_on} = 1 ;
	$othash{ $key }{dieli_en} = $trans_dieli_en ;
	$othash{ $key }{dieli_it} = $trans_dieli_it ;

	##  could also limit parts of speech
	##  single words only -- no phrases, no capital letters
	##  ##  if ( $display =~ /^[a-z]+$/ && $pos !~ /^adv$|^prep$|^pron$|^conj$/ ) {}

    } 

    ##  now collect the rest of the Dieli dictionary
    foreach my $key (sort keys %dieli_sc) {

	##  collect translations
	my %dieli_en ;
	my %dieli_it ;

	##  loop through the word to capture translations by part of speech
	foreach my $i (0..$#{$dieli_sc{$key}}){

	    my $sc_part = ${$dieli_sc{$key}[$i]}{"sc_part"} ; 
	    my $sc_word = ${$dieli_sc{$key}[$i]}{"sc_word"} ; 
	    my $linkto  = ${$dieli_sc{$key}[$i]}{"linkto"} ; 
	    
	    my $is_verb = ( $sc_part eq '{v}' && $sc_word =~ /ari$|iri$|arisi$|irisi$/ ) ? "true" : "false" ;
	    my $is_noun = ( $sc_part eq '{m}'   || $sc_part eq '{f}'   || $sc_part eq '{m/f}' || 
			    $sc_part eq '{mpl}' || $sc_part eq '{fpl}') ? "true" : "false" ;
	    my $is_adj  = ( $sc_part eq '{adj}' ) ? "true" : "false" ;

	    my $pos_tag ;
	    $pos_tag = ( $is_verb eq "true"  ) ?  'verb'  : undef    ;
	    $pos_tag = ( $is_noun eq "true"  ) ?  'noun'  : $pos_tag ;
	    $pos_tag = ( $is_adj  eq "true"  ) ?  'adj'   : $pos_tag ;
	    $pos_tag = ( $sc_part eq '{adv}' ) ?  'adv'   : $pos_tag ;
	    $pos_tag = ( $sc_part eq '{prep}') ?  'prep'  : $pos_tag ;
	    $pos_tag = ( $sc_part eq '{pron}') ?  'pron'  : $pos_tag ;
	    $pos_tag = ( $sc_part eq '{conj}') ?  'conj'  : $pos_tag ;
	    $pos_tag = ( ! defined $pos_tag  ) ?  'other' : $pos_tag ;

	    ## translation hash
	    my %th = %{ ${$dieli_sc{$key}}[$i] } ; 
	    if ( $th{"en_word"} ne '<br>' ) { push( @{$dieli_en{$pos_tag}} , $th{"en_word"} );};
	    if ( $th{"it_word"} ne '<br>' ) { push( @{$dieli_it{$pos_tag}} , $th{"it_word"} );};
	}

	##  make translations unique and join them
	my %trans_en ;  
	my %trans_it ;  
	foreach my $pos ("verb","noun","adj","adv","prep","pron","conj","other") {
	    @{$dieli_en{$pos}} = sort( $ddsubs{uniq}( @{$dieli_en{$pos}} )) ; 
	    @{$dieli_it{$pos}} = sort( $ddsubs{uniq}( @{$dieli_it{$pos}} )) ; 
	    $trans_en{$pos} = join( ', ' , @{$dieli_en{$pos}} );
	    $trans_it{$pos} = join( ', ' , @{$dieli_it{$pos}} );
	    $trans_en{$pos}  =~ s/_SQUOTE_/'/ ; 
	    $trans_it{$pos}  =~ s/_SQUOTE_/'/ ; 
	}

	

	##  now loop through it all again
	foreach my $i (0..$#{$dieli_sc{$key}}){
	    
	    my $sc_part = ${$dieli_sc{$key}[$i]}{"sc_part"} ; 
	    my $sc_word = ${$dieli_sc{$key}[$i]}{"sc_word"} ; 
	    my $linkto  = ${$dieli_sc{$key}[$i]}{"linkto"} ; 
	    
	    
	    ##  ##  for now, single words only -- no phrases, no capital letters
	    ##  if ( $vbsubs{rid_accents}($sc_word) =~ /^[a-z]+$/ ) {}
		
	    my $is_verb = ( $sc_part eq '{v}' && $sc_word =~ /ari$|iri$|arisi$|irisi$/ ) ? "true" : "false" ;
	    my $is_noun = ( $sc_part eq '{m}'   || $sc_part eq '{f}'   || $sc_part eq '{m/f}' || 
			    $sc_part eq '{mpl}' || $sc_part eq '{fpl}') ? "true" : "false" ;
	    my $is_adj  = ( $sc_part eq '{adj}' ) ? "true" : "false" ;
	    
	    ##  if linkto not defined
	    if ( $is_noun eq "true" &&  ! defined $linkto ) {
		my ( $othref , $pos_tag ) = want_about_noun( $sc_word , $sc_part ); 
		$othash{ $pos_tag } = ( $othref ) ; 
		$othash{ $pos_tag }{dieli_en} = $trans_en{"noun"} ;
		$othash{ $pos_tag }{dieli_it} = $trans_it{"noun"} ;
		
	    } elsif ( $is_adj eq "true" && ! defined $linkto ) {
		my ( $othref , $pos_tag ) = want_about_adj( $sc_word ); 
		$othash{ $pos_tag } = ( $othref ) ; 
		$othash{ $pos_tag }{dieli_en} = $trans_en{"adj"} ;
		$othash{ $pos_tag }{dieli_it} = $trans_it{"adj"} ;
		
	    } elsif ( $is_verb eq "true" && ! defined $linkto ) {
		my ( $othref , $pos_tag ) = want_about_verb( $sc_word , \%vbsubs ); 
		$othash{ $pos_tag } = ( $othref ) ; 
		$othash{ $pos_tag }{dieli_en} = $trans_en{"verb"} ;
		$othash{ $pos_tag }{dieli_it} = $trans_it{"verb"} ;
	    } elsif  ( ! defined $linkto &&  $sc_word !~ /- - -/ ) {
		my $pos_tag ; 
		$pos_tag = ( $is_verb eq "true" )  ?  'verb'  : $pos_tag ;
		$pos_tag = ( $is_noun eq "true" )  ?  'noun'  : $pos_tag ;
		$pos_tag = ( $is_adj  eq "true" )  ?  'adj'   : $pos_tag ;
		$pos_tag = ( $sc_part eq '{adv}' ) ?  'adv'   : $pos_tag ;
		$pos_tag = ( $sc_part eq '{prep}') ?  'prep'  : $pos_tag ;
		$pos_tag = ( $sc_part eq '{pron}') ?  'pron'  : $pos_tag ;
		$pos_tag = ( $sc_part eq '{conj}') ?  'conj'  : $pos_tag ;
		$pos_tag = ( ! defined $pos_tag  ) ?  'other' : $pos_tag ;

		my $pos_disp ;
		$pos_disp = ( $pos_tag eq "other" ) ? 'àutru' : $pos_tag ;

		( my $display = $sc_word ) =~ s/_SQUOTE_/'/ ; 
		my $hkey = $sc_word . "_" . $pos_tag ; 

		%{ $othash{ $hkey } } = ( 
		    palora => $display ,
		    part_speech => $pos_disp , 
		    hashkey => $hkey ,
		    dieli_en => $trans_en{$pos_tag} ,
		    dieli_it => $trans_it{$pos_tag} ,
		    );
	    }
	}
    }
    ##  return hash 
    return %othash ;
}


##  what do we want to know about the verb?
sub want_about_verb {
    
    my $verb    =    $_[0]   ;
    my %vbsubs  = %{ $_[1] } ; 

    my $reflex_id = ( $verb =~ /arisi$|irisi$/ ) ? "reflex" : "nonreflex" ;
    my $nonreflex = $verb ; 
    if ( $nonreflex =~ /arisi$|irisi$/ ) { 
	$nonreflex =~ s/si$// ;
    } 
    
    ##  infer conjugation
    my $conj ;
    if ( $nonreflex =~ /iri$/ ) {
	##  cannot know if "xxiri" or "sciri"
	##  guess "xxiri"
	$conj = "xxiri";
    } elsif ( $nonreflex =~ /cari$/ ) {
	$conj = "xcari";
    } elsif ( $nonreflex =~ /gari$/ ) {
	$conj = "xgari";
    } elsif ( $nonreflex =~ /iari$/ ) {
	if ( $nonreflex =~ /ciari$/ ) {
	    $conj = "ciari";
	} elsif ( $nonreflex =~ /giari$/ ) {
	    $conj = "giari";
	} else {
	    $conj = "xiari";
	}
    } else {
	$conj = "xxari";
    }
	
    ##  infer stem and boot
    ( my $stemboot = $nonreflex ) =~ s/ari$|iri$// ;
    my $stemA ; my $stemB ; my $bootA ; my $bootB ;
    if ( $stemboot =~ /[àèìòù]/ ) {
	$bootA = $stemboot ;  $bootB = $stemboot ;
	
	##  ##  LOOK  FOR  THIS  CODE  AND  REPLACE  IT
	##  my %vmapA = ( 'à' => 'a', 'è' => 'i', 'ì' => 'i', 'ò' =>'u', 'ù' => 'u' );
	##  my $rstemA = reverse( $stemboot ) ;
	##  $rstemA =~ s/([àèìòù])/$vmapA{$1}/;
	##  $stemA = reverse( $rstemA ) ;
	$stemA = $vbsubs{rid_accents}( $stemboot ) ;
	
	##  ##  LOOK  FOR  THIS  CODE  AND  REPLACE  IT  
	##  my %vmapB = ( 'à' => 'a', 'è' => 'e', 'ì' => 'i', 'ò' =>'o', 'ù' => 'u' );
	##  my $rstemB = reverse( $stemboot ) ;
	##  $rstemB =~ s/([àèìòù])/$vmapB{$1}/;
	##  $stemB = reverse( $rstemB ) ;
	$stemB = $vbsubs{rid_accents}( $stemboot ) ;	

    } else {
	$stemA = $stemboot ;  $stemB = $stemboot ;
	
	my %vmapA = ( a => 'à', e => 'è', i => 'è', o => 'ò', u => 'ò' );
	my $rbootA = reverse( $stemboot ) ;
	$rbootA =~ s/([aeiou])/$vmapA{$1}/;
	$bootA = reverse( $rbootA ) ;
	
	my %vmapB = ( a => 'à', e => 'è', i => 'ì', o => 'ò', u => 'ù' );
	my $rbootB = reverse( $stemboot ) ;
	$rbootB =~ s/([aeiou])/$vmapB{$1}/;
	$bootB= reverse( $rbootB ) ; 
    }	

    ##  collect everything into a hash
    ( my $display = $verb ) =~ s/_SQUOTE_/'/ ; 
    my $hkey = $verb . "_verb" ; 
    my %othash = ( 
	palora => $display ,
	part_speech => "verb" , 
	hashkey => $hkey ,
	verb => {
	    conj => $conj , 
	    stemA => $stemA , stemB => $stemB , 
	    bootA => $bootA , bootB => $bootB , 
	},);
    
    ##  return hash 
    return ( \%othash , $hkey ) ; 
}

sub want_about_noun {
    
    my $noun   = $_[0] ;
    my $gender = $_[1] ;  ##  feeding in "sc_part"

    ##  convert gender
    $gender =~ s/{m}/mas/;
    $gender =~ s/{f}/fem/;
    $gender =~ s/{mpl}/mpl/;
    $gender =~ s/{fpl}/fpl/;
    ## $gender =~ s/{m\/f}/both/;
    $gender = ( $gender eq '{m/f}' ) ? "both" : $gender ;
    
    ##  guess  "plend"
    my $plend ;
    if ( $gender eq "mpl" || $gender eq "fpl" ) {
	$plend = "ispl" ;
    } elsif ( $noun =~ /eddu$/ && $gender eq "mas" ) {
	$plend = "eddu" ;
    } elsif ( $noun =~ /aru$/ && $gender eq "mas" ) {
	$plend = "aru" ;
    } elsif ( $noun =~ /uni$/ && $gender eq "mas" ) {	
	$plend = "uni" ;
    } elsif ( $noun =~ /uri$/ && $gender eq "mas" ) {
	$plend = "uri" ;
    } elsif ( $noun =~ /u$/ && $gender eq "fem" ) {
	$plend = "xx" ;
    } elsif ( $noun =~ /[bcdfghjklmnpqrstvwxyz]$/ ) {
	##  probably foreign word
	$plend = "xx" ;
    } else {
	$plend = "xi" ;
    }

    ##  collect everything into a hash
    ( my $display = $noun ) =~ s/_SQUOTE_/'/ ; 
    my $hkey = $noun . "_noun" ; 
    my %othash = ( 
	palora => $display ,
	part_speech => "noun" , 
	hashkey => $hkey ,
	noun => {
	    gender => $gender , 
	    plend => $plend , 
	},);
    
    ##  return hash 
    return ( \%othash , $hkey ) ; 
}


sub want_about_adj {

    my $adj = $_[0] ;

    ##  collect everything into a hash
    ( my $display = $adj ) =~ s/_SQUOTE_/'/ ; 
    my $hkey = $adj . "_adj" ; 
    my %othash = ( 
	palora => $display ,
	part_speech => "adj" , 
	hashkey => $hkey ,
	adj => {
	    massi => $adj , 
	},);

    ##  return hash 
    return ( \%othash , $hkey ) ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
