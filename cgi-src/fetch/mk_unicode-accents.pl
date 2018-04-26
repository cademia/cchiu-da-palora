#!/usr/bin/env perl

##  Eryk Wdowiak
##  26 april 2018
##  
##  *  make unicode accented vowels
##  *  remove unicode accents from vowels

use strict ;
use warnings ;
use autodie ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

my $otfile = "unicode-accents.txt";

my @vowels = (["à","á","â","ä"],["è","é","ê","ë"],["ì","í","î","ï"],["ò","ó","ô","ö"],["ù","ú","û","ü"]);
my @caps   = (["À","Á","Â","Ä"],["È","É","Ê","Ë"],["Ì","Í","Î","Ï"],["Ò","Ó","Ô","Ö"],["Ù","Ú","Û","Ü"]);

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

open( OTFILE , ">$otfile" ) ;
print OTFILE "test of subroutine to remove unicode accents:\n" ;
foreach my $i (0..4) {
    my $line ;
    foreach my $vowel (@{$vowels[$i]},@{$caps[$i]}) {
	my $cval = rm_accent($vowel) ; 
	$line .= $vowel . " = " . $cval  . "  ::  ";
    }
    $line =~ s/  ::  $/\n/;
    print OTFILE $line ;
}
print OTFILE "\n" ;
print OTFILE "test of subroutine to add unicode accents:\n" ;
foreach my $vowel ("a","e","i","o","u") {
    my $line ;
    foreach my $accent ("grave","acute","circ","diar") {
	my $cval = mk_accent($vowel,$accent) ; 
	$line .= "$vowel" . " = " . $cval  . "  ::  ";
    }
    foreach my $accent ("grave","acute","circ","diar") {
	my $upper = uc($vowel) ; 
	my $cval = mk_accent($upper,$accent) ; 
	$line .= "$vowel" . " = " . $cval  . "  ::  ";
    }
    $line =~ s/  ::  $/\n/;
    print OTFILE $line ;
}
close OTFILE ; 

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  make unicode accented vowels
sub mk_accent {

    my $letter = $_[0] ; 
    ( my $accent = $_[1] ) =~ s/^(.).*$/$1/ ;

    ##  "g" -- grave
    ##  "a" -- acute
    ##  "c" -- circumflex
    ##  "d" -- diaresis
    
    my %accent = (
	a => { g => "\303\240", a => "\303\241", c => "\303\242", d => "\303\244", }, 
	e => { g => "\303\250", a => "\303\251", c => "\303\252", d => "\303\253", }, 
	i => { g => "\303\254", a => "\303\255", c => "\303\256", d => "\303\257", }, 
	o => { g => "\303\262", a => "\303\263", c => "\303\264", d => "\303\266", }, 
	u => { g => "\303\271", a => "\303\272", c => "\303\273", d => "\303\274", }, 
	A => { g => "\303\200", a => "\303\201", c => "\303\202", d => "\303\204", }, 
	E => { g => "\303\210", a => "\303\211", c => "\303\212", d => "\303\213", }, 
	I => { g => "\303\214", a => "\303\215", c => "\303\216", d => "\303\217", }, 
	O => { g => "\303\222", a => "\303\223", c => "\303\224", d => "\303\226", }, 
	U => { g => "\303\231", a => "\303\232", c => "\303\233", d => "\303\234", }, 
	);
      
    return $accent{$letter}{$accent} ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  remove unicode accented vowels
sub rm_accent {
    my $char = $_[0] ;
    $char =~ s/\240/a/g; $char =~ s/\241/a/g; $char =~ s/\242/a/g; $char =~ s/\244/a/g;
    $char =~ s/\250/e/g; $char =~ s/\251/e/g; $char =~ s/\252/e/g; $char =~ s/\253/e/g;
    $char =~ s/\254/i/g; $char =~ s/\255/i/g; $char =~ s/\256/i/g; $char =~ s/\257/i/g;
    $char =~ s/\262/o/g; $char =~ s/\263/o/g; $char =~ s/\264/o/g; $char =~ s/\266/o/g;
    $char =~ s/\271/u/g; $char =~ s/\272/u/g; $char =~ s/\273/u/g; $char =~ s/\274/u/g;
    $char =~ s/\200/A/g; $char =~ s/\201/A/g; $char =~ s/\202/A/g; $char =~ s/\204/A/g;
    $char =~ s/\210/E/g; $char =~ s/\211/E/g; $char =~ s/\212/E/g; $char =~ s/\213/E/g;
    $char =~ s/\214/I/g; $char =~ s/\215/I/g; $char =~ s/\216/I/g; $char =~ s/\217/I/g;
    $char =~ s/\222/O/g; $char =~ s/\223/O/g; $char =~ s/\224/O/g; $char =~ s/\226/O/g;
    $char =~ s/\231/U/g; $char =~ s/\232/U/g; $char =~ s/\233/U/g; $char =~ s/\234/U/g;
    $char =~ s/\303//g;
    return $char ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
