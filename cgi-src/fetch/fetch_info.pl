#!/usr/bin/env perl

##  "fetch_info.pl" -- counts parts of speech and missing parts of speech
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

use strict ;
use warnings ;
use Storable qw( retrieve ) ;

my %dieli_sc = %{ retrieve('../../cgi-lib/dieli-sc-dict' ) } ;

my $otfile = "fetch_info_" . datestamp() . ".txt" ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

open( OTFILE , ">$otfile" ) || die "could not open:  $otfile" ;
print OTFILE "\n" ;
print OTFILE $otfile . "\n" ;
print OTFILE "counts of parts of speech and missing parts of speech in Dieli dictionary" . "\n" ;
print OTFILE "-------------------------------------------------------------------------" . "\n\n" ;

my @dkeys = keys %dieli_sc ; 
my $total_words = $#dkeys + 1 ;
my $total_entries ;

my $total_txt ; 
$total_txt .= sprintf("%13s  -- %0s\n", $total_words, "total words");

my %parts ;
foreach my $palora (sort keys %dieli_sc) {
    foreach my $i (0..$#{$dieli_sc{$palora}}) {
	my $sc_part = ${$dieli_sc{$palora}[$i]}{"sc_part"} ;
	$parts{$sc_part} += 1;
	$total_entries += 1 ;
    }
}
my $ottxt ;
foreach my $sc_part (sort {$parts{$b} <=> $parts{$a}} keys %parts) {
    $ottxt .= sprintf("%13s  -- %0s\n", $parts{$sc_part} , $sc_part ) ;
}
$total_txt .= sprintf("%13s  -- %0s\n", $total_entries, "total entries");

print OTFILE $total_txt ;
print OTFILE "\n" ;
print OTFILE $ottxt ;
print OTFILE "\n" ;
close OTFILE ;


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  SUBROUTINES
##  ===========

##  tip of the hat to List::MoreUtils for this sub
sub uniq { 
    my %h;  
    map { $h{$_}++ == 0 ? $_ : () } @_;
}

sub datestamp {
    my($day, $month, $year)=(localtime)[3,4,5]; 
    $year += 1900 ; 
    $month = sprintf( "%02d" , $month + 1) ;
    $day = sprintf( "%02d" , $day ) ;
    my $ot = $year . "-" . $month . "-" . $day ;
    return $ot ;
}
