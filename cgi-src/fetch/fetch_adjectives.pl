#!/usr/bin/env perl

##  "fetch_adjectives.pl" -- searches for adjectives in Dieli dictionary and creates "proto-hashes"
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
no warnings qw( uninitialized );
use utf8 ;
use Encoding::FixLatin qw(fix_latin);
use Storable qw( retrieve ) ;

my %dieli_sc = %{ retrieve('../../cgi-lib/dieli-sc-dict' ) } ;
my $otadjs = "fetch_adjs_" . datestamp() . ".txt" ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  sort the adjs into alphabetical order
my @order = get_alpha_order( \%dieli_sc );

##  now let's create some proto hashes
open( OTADJS , ">$otadjs" ) || die "could not open:  $otadjs" ;
print OTADJS "\n" . '##  DO  NOT  EDIT  THIS  FILE' . "\n" ;
print OTADJS        '##  Just copy-paste what you need into:  "/cgi-src/mk_adj-notes.pl"' . "\n" ;
print OTADJS        '##  ==============================================================' . "\n\n" ;

foreach my $palora (@order) {

    ##  collect translations and part of speech
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

    ##  generate proto hash
    my $ottxt = mk_proto( $palora , \@dieli_en , \@dieli_it ) ;

    print OTADJS $ottxt ;
}
close OTADJS ;


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  SUBROUTINES
##  ===========

sub mk_proto {

    my $dieli    =    $_[0]   ;
    my @dieli_en = @{ $_[1] } ;
    my @dieli_it = @{ $_[2] } ;
    
    my $ottxt ;
    $ottxt .= "\n";
    $ottxt .= '##  ##  ##  ##  ##  ##  ##  ##  ##' . "\n";
    $ottxt .= "\n";
    $ottxt .= '##  ##  ' . $dieli . ' -- proto hash -- MUST check for accuracy' . "\n";
    $ottxt .= '##  %{ $vnotes{"' . $dieli . '_adj"} } = (' . "\n";
    $ottxt .= '##      display_as => "' . $dieli . '",' . "\n";
    $ottxt .= '##      dieli => ["' . $dieli . '",],' . "\n";
    $ottxt .= '##      dieli_en => ['; 
    foreach my $listing (@dieli_en) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    $ottxt .= '##      dieli_it => ['; 
    foreach my $listing (@dieli_it) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    $ottxt .= '##      notex => ["","",],' . "\n";
    $ottxt .= '##      part_speech => "adj",' . "\n";
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
	    my $sc_part = ${$dieli_sc{$palora}[$i]}{"sc_part"} ;
	    if ( $sc_part eq '{adj}' ) {
		push( @order , $palora );
	    }
	}
    }
    @order = uniq( @order ) ; 
    return @order ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##
