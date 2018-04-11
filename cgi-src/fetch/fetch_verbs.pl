#!/usr/bin/env perl

##  "fetch_verbs.pl" -- searches for verbs in Dieli dictionary and creates "proto-hashes"
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
use utf8 ;
use Encoding::FixLatin qw(fix_latin);
use Storable qw( retrieve ) ;

my %dieli_sc = %{ retrieve('../../cgi-lib/dieli-sc-dict' ) } ;
my $otverbs = "fetch_verbs_" . datestamp() . ".txt" ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  how should we order the output??  Sicilian has many similar forms
##  my @order = get_it_order( \%dieli_sc ) ;
my @order = get_alpha_order( \%dieli_sc );

##  now let's create some proto hashes
open( OTVERBS , ">$otverbs" ) || die "could not open:  $otverbs" ;
print OTVERBS "\n" . '##  DO  NOT  EDIT  THIS  FILE' . "\n" ;
print OTVERBS        '##  Just copy-paste what you need into:  "/cgi-src/mk_verb-notes.pl"' . "\n" ;
print OTVERBS        '##  ================================================================' . "\n\n" ;

foreach my $palora (@order) {

    ##  collect translations
    my @dieli_en ;
    my @dieli_it ;
    foreach my $i (0..$#{$dieli_sc{$palora}}) {
	my %th = %{ ${$dieli_sc{$palora}}[$i] } ; 
	if ( $th{"en_word"} ne '<br>' ) { push( @dieli_en , $th{"en_word"} );};
	if ( $th{"it_word"} ne '<br>' ) { push( @dieli_it , $th{"it_word"} );};
    }
    @dieli_en = uniq( @dieli_en ) ; 
    @dieli_it = uniq( @dieli_it ) ; 

    ##  please give me utf8 !!
    $palora = fix_latin( $palora ) ;

    ##  prepare output
    my $ottxt ;
    if ( $palora =~ /arisi$|irisi$/ ) {
	##  if verb is reflexive, then make reflexive
	$ottxt = mk_reflex( $palora , \@dieli_en , \@dieli_it ) ;
    } else {
	##  otherwise infer information for proto hash
	    
	##  infer conjugation
	my $conj ;
	if ( $palora =~ /iri$/ ) {
	    ##  cannot know if "xxiri" or "sciri"
	    ##  guess "xxiri"
	    $conj = "xxiri";
	} elsif ( $palora =~ /cari$/ ) {
	    $conj = "xcari";
	} elsif ( $palora =~ /gari$/ ) {
	    $conj = "xgari";
	} elsif ( $palora =~ /iari$/ ) {
	    if ( $palora =~ /ciari$/ ) {
		$conj = "ciari";
	    } elsif ( $palora =~ /giari$/ ) {
		$conj = "giari";
	    } else {
		$conj = "xiari";
	    }
	} else {
	    $conj = "xxari";
	}
	
	##  infer stem and boot
	( my $stemboot = $palora ) =~ s/ari$|iri$// ;
	my $stemA ; my $stemB ; my $bootA ; my $bootB ;
	if ( $stemboot =~ /[àèìòù]/ ) {
	    $bootA = $stemboot ;  $bootB = $stemboot ;

	    my %vmapA = ( 'à' => 'a', 'è' => 'i', 'ì' => 'i', 'ò' =>'u', 'ù' => 'u' );
	    my $rstemA = reverse( $stemboot ) ;
	    $rstemA =~ s/([àèìòù])/$vmapA{$1}/;
	    $stemA = reverse( $rstemA ) ;
	    
	    my %vmapB = ( 'à' => 'a', 'è' => 'e', 'ì' => 'i', 'ò' =>'o', 'ù' => 'u' );
	    my $rstemB = reverse( $stemboot ) ;
	    $rstemB =~ s/([àèìòù])/$vmapB{$1}/;
	    $stemB = reverse( $rstemB ) ;
	    
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
	##  generate proto hash
	$ottxt = mk_proto( $palora , \@dieli_en , \@dieli_it , $conj , $stemA , $stemB , $bootA , $bootB ) ;
    }
    print OTVERBS $ottxt ;
}
close OTVERBS ;


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  SUBROUTINES
##  ===========

sub mk_proto {

    my $dieli    =    $_[0]   ;
    my @dieli_en = @{ $_[1] } ;
    my @dieli_it = @{ $_[2] } ;
    my $conj     =    $_[3]   ;
    my $stemB    =    $_[4]   ; my $stemA  = $_[5] ;
    my $bootB    =    $_[6]   ; my $bootA  = $_[7] ;
    
    my $fullStemB = ($stemA eq $stemB) ? "" : ' ## "' . $stemB . '",' ; 
    my $fullBootB = ($bootA eq $bootB) ? "" : ' ## "' . $bootB . '",' ; 

    my $ottxt ;
    $ottxt .= "\n";
    $ottxt .= '##  ##  ##  ##  ##  ##  ##  ##  ##' . "\n";
    $ottxt .= "\n";
    $ottxt .= '##  ##  ' . $dieli . ' -- proto hash -- MUST check for accuracy' . "\n";
    $ottxt .= '##  %{ $vnotes{"' . $dieli . '"} } = (' . "\n";
    $ottxt .= '##      dieli => ["' . $dieli . '",],' . "\n";
    $ottxt .= '##      dieli_en => ['; 
    foreach my $listing (@dieli_en) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    $ottxt .= '##      dieli_it => ['; 
    foreach my $listing (@dieli_it) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    $ottxt .= '##      notex => ["","",],' . "\n";
    $ottxt .= '##      part_speech => "verb",' . "\n";
    $ottxt .= '##      verb => {' . "\n";
    $ottxt .= '##  	conj => "' . $conj . '",' . "\n";
    $ottxt .= '##  	stem => "' . $stemA . '",' . $fullStemB . "\n";
    $ottxt .= '##  	boot => "' . $bootA . '",' . $fullBootB . "\n";
    $ottxt .= '##  	irrg => {' . "\n";
    $ottxt .= '##  	    inf => "",' . "\n";
    $ottxt .= '##  	    pri => { us => "", ds => "", ts => "", up => "", dp => "", tp => ""},' . "\n";
    $ottxt .= '##  	    pim => { ds => "", ts => "", up => "", dp => "", tp => ""},' . "\n";
    $ottxt .= '##  	    pai => { quad = ""},' . "\n";
    $ottxt .= '##  	    imi => { us => "", ds => "", ts => "", up => "", dp => "", tp => ""},' . "\n";
    $ottxt .= '##  	    ims => { us => "", ds => "", ts => "", up => "", dp => "", tp => ""},' . "\n";
    $ottxt .= '##  	    fti => { stem => ""},' . "\n";
    $ottxt .= '##  	    coi => { stem => ""},' . "\n";
    $ottxt .= '##  	    pap => "",' . "\n";
    $ottxt .= '##  	    adj => "",' . "\n";
    $ottxt .= '##  	},' . "\n";
    $ottxt .= '##      },);' . "\n";
    
    return $ottxt ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_reflex {
    
    my $dieli = $_[0] ;
    ( my $nonrv = $dieli ) =~ s/si$// ;

    my @dieli_en = @{ $_[1] } ;
    my @dieli_it = @{ $_[2] } ;
    
    my $ottxt ;
    $ottxt .= "\n";
    $ottxt .= '##  ##  ##  ##  ##  ##  ##  ##  ##' . "\n";
    $ottxt .= "\n";
    $ottxt .= '##  ##  ' . $dieli . ' -- proto hash -- MUST check for accuracy' . "\n";
    $ottxt .= '##  %{ $vnotes{"' . $dieli . '"} } = (' . "\n";
    $ottxt .= '##      dieli => ["' . $dieli . '"],' . "\n";
    $ottxt .= '##      dieli_en => ['; 
    foreach my $listing (@dieli_en) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    $ottxt .= '##      dieli_it => ['; 
    foreach my $listing (@dieli_it) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    $ottxt .= '##      part_speech => "verb",' . "\n";
    $ottxt .= '##      reflex => "' . $nonrv . '",' . "\n";
    $ottxt .= '##      );' . "\n";
    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##

##  tip of the hat to List::MoreUtils for this sub
sub uniq { 
    my %h;  
    map { $h{$_}++ == 0 ? $_ : () } @_;
}

##  ##  ##  ##  ##  ##  ##  ##  ##

sub datestamp {
    my($day, $month, $year)=(localtime)[3,4,5]; 
    $year += 1900 ; 
    $month = sprintf( "%02d" , $month + 1) ;
    $day = sprintf( "%02d" , $day ) ;
    my $ot = $year . "-" . $month . "-" . $day ;
    return $ot ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##

sub get_alpha_order {
    my %dieli_sc = %{ $_[0] } ;
    my @order ;
    
    foreach my $palora (sort keys %dieli_sc) {
	foreach my $i (0..$#{$dieli_sc{$palora}}) {
	    if ( ${$dieli_sc{$palora}[$i]}{"sc_part"} eq "{v}" && 
		 ${$dieli_sc{$palora}[$i]}{"sc_word"} =~ /ari$|iri$|arisi$|irisi$/ ) {
		push( @order , $palora );
	    }
	}
    }
    @order = uniq( @order ) ; 
    return @order ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##

sub get_it_order {
    my %dieli_sc = %{ $_[0] } ;
    
    ##  get the italian words
    my %italian ;
    foreach my $palora (sort keys %dieli_sc) {
	foreach my $i (0..$#{$dieli_sc{$palora}}) {
	    if ( ${$dieli_sc{$palora}[$i]}{"sc_part"} eq "{v}" ) {
		my %th = %{ ${$dieli_sc{$palora}}[$i] } ; 
		if ( $th{"it_part"} eq '{v}' ) { 
		    push( @{$italian{$th{"it_word"}}} , $palora );
		}
	    }
	}
    }
    
    ##  unravel the whole thing
    my @it_order ;
    foreach my $it_word (sort keys %italian) {
	foreach my $palora (@{$italian{$it_word}}) {
	    if ( grep( /^$palora$/ , @it_order ) ) {
		my $blah = "exists. do nothing.";
	    } else {
		push ( @it_order , $palora ) ;
	    }
	}
    }
    return @it_order ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##
