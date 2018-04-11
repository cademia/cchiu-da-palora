#!/usr/bin/env perl

##  "sicilian.pl" -- makes a searchable version of the Dieli dictionary
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

use strict;
#use warnings;
#no warnings qw(uninitialized);
use CGI qw(:standard);
use Storable qw( retrieve ) ;
#{   no warnings;             
#    ## $Storable::Deparse = 1;  
#    $Storable::Eval    = 1;  
#}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  what are we looking for?
my $lgparm = ( ! defined param('langs') ) ? "SCEN" : param('langs') ;
my $rquest = param('langs') ;
my $insearch = param('search') ;

##  searches split by vertical bar
my @searches = split( "_OR_" , $insearch ) ; 
s/^\s*// for @searches ; 
s/\s*$// for @searches ; 
s/'/_SQUOTE_/g for @searches ; 

##  ## case-insensitive search == bad idea!
##  foreach my $i (0..$#searches) {
##      $searches[$i] = lc( $searches[$i] ) ;
##  }

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  we need to make a webpage, so let's get some HTML
my $tophtml = mk_tophtml( "../config/topnav.html");
my $newform = mk_newform( $lgparm );
my $foothtm = mk_foothtm("../config/navbar-footer.html");

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  initialize output HTML
my $otline ; 
$otline .= "\n" ; 

##  translate and pass output to HTML
foreach my $search (@searches) {
    if ( $search =~ /^COLL_/ ) {
	my %collections = mk_collections() ;
	my @whichcolls = grep( /$search/ , keys( %collections ) ); 
	foreach my $collection (@whichcolls) {

	    ##  get the reference
	    my $cref   = $collections{$collection} ;
	    my $slang = ${${$cref}[0]}[0] ;
	    
	    ##  if more then one collection requested, then dictionaries load more than once
	    ##  nonetheless, I don't think that will be a problem
	    my %dieli ; 

	    if ( $slang =~ /SCEN|SCIT/ ) {  %dieli = %{ retrieve('../cgi-lib/dieli-sc-dict') };
	    } elsif ( $slang =~ /ENSC/ ) {  %dieli = %{ retrieve('../cgi-lib/dieli-en-dict') };
	    } elsif ( $slang =~ /ITSC/ ) {  %dieli = %{ retrieve('../cgi-lib/dieli-it-dict') };
	    } else {  my $blah = "retrieve nothing -- no language requested" ;
	    }

	    for my $i (1..$#{$cref}) { 
		$otline .= '<br>' . "\n" ; 
		my $pclass = ' class="zero"' ;
		$otline .= '<div align="center">' . "\n" ; 
		for my $j (0..$#{${$cref}[$i]}) {
		    $otline .= mk_search( $slang , ${${$cref}[$i]}[$j] , \%dieli , $pclass ) ;
		}
		$otline .= '</div>' . "\n" ; 	
	    }
	}
    } else {
	if ( $rquest =~ /SCEN|SCIT|ENSC|ITSC/ ) { 
	    my %dieli ; 
	    if ( $rquest =~ /SCEN|SCIT/ ) {  %dieli = %{ retrieve('../cgi-lib/dieli-sc-dict') };
	    } elsif ( $rquest =~ /ENSC/ ) {  %dieli = %{ retrieve('../cgi-lib/dieli-en-dict') };
	    } elsif ( $rquest =~ /ITSC/ ) {  %dieli = %{ retrieve('../cgi-lib/dieli-it-dict') };
	    } else {  my $blah = "retrieve nothing -- no language requested" ;
	    } 
	    my $pclass = "" ; 
	    $otline .= '<div align="center">' . "\n" ; 
	    $otline .= mk_search( $rquest, $search , \%dieli , $pclass ) ; 
	    $otline .= '</div>' . "\n" ; 	
	}
    }
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make webpage
print $tophtml ;
print $newform ;
print $otline  ;
print $foothtm ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

## tip of the hat to List::MoreUtils for this sub
sub uniq { 
    my %h;  
    map { $h{$_}++ == 0 ? $_ : () } @_;
}


sub mk_search {
    
    my $rlang  = $_[0] ; 
    my $rsrch  = $_[1] ; 
    my $dlirf  = $_[2] ; 
    my $pclass = $_[3] ; 

    my @translation = translate( $rlang , $rsrch , $dlirf ) ;
    my @inpart = @{ $translation[0] } ;
    my @otpart = @{ $translation[1] } ;
    my @otword = @{ $translation[2] } ;
    my @linkto = @{ $translation[3] } ;
	
    my $othtml ;
    if ($#inpart == -1 && $rsrch ne "") {
	$rsrch =~ s/_SQUOTE_/'/g ;
	$othtml .= "<p>nun c'è na traduzzioni dâ palora: " . '&nbsp; <b>' . $rsrch . '</b></p>';
    } else {
	    
	my @otplines ;
	if ( $rlang =~ /SCEN|SCIT/ ) {
	    ##  Sicilian is "IN" language
	    foreach my $i (0..$#inpart) {
		my $linkifany ;
		if ( $linkto[$i] ne "" ) {
		    $linkifany .= '<a href="/cgi-bin/cchiu-da-palora.pl?' ; 
		    $linkifany .= 'palora=' . $linkto[$i] . '&langs=' . $lgparm . '">' ; 
		    $linkifany .= $rsrch . '</a>' ;
		} else {
		    $linkifany .= $rsrch ;
		}
		##  create the output
		my $otpline ;
		$linkifany =~ s/_SQUOTE_/'/g ;
		$otpline .= '<p' . $pclass . '><b>' . $linkifany . '</b> ' . $inpart[$i] . ' &nbsp; &rarr; &nbsp; ' ;
		$otpline .= '<b>' . $otword[$i] . '</b> ' . $otpart[$i] . '</p>' . "\n" ;
		push( @otplines , $otpline ) ;
	    }
	} else {
	    ##  Sicilian is "OUT" language
	    foreach my $i (0..$#otpart) {
		##  need to reverse the language for lookup
		my $newlgparm = ( $lgparm eq "ITSC" ) ? "SCIT" : "SCEN" ;
		my $linkifany ;
		if ( $linkto[$i] ne "" ) {
		    $linkifany .= '<a href="/cgi-bin/cchiu-da-palora.pl?' ; 
		    $linkifany .= 'palora=' . $linkto[$i] . '&langs=' . $newlgparm . '">' ; 
		    $linkifany .= $otword[$i] . '</a>' ;
		} else {
		    $linkifany .= $otword[$i] ;
		}
		##  create the output
		my $otpline ;
		$linkifany =~ s/_SQUOTE_/'/g ;
		$otpline .= '<p' . $pclass . '><b>' . $rsrch . '</b> ' . $inpart[$i] . ' &nbsp; &rarr; &nbsp; ' ;
		$otpline .= '<b>' . $linkifany . '</b> ' . $otpart[$i] . '</p>' . "\n" ;
		push( @otplines , $otpline ) ;
	    }
	}
	
	foreach my $otpline (sort( uniq( @otplines ))) {
	    $othtml .= $otpline ; 
	}
    }
    return $othtml ; 
}
    
sub translate {

    my $rlang =    $_[0]   ; 
    my $rsrch =    $_[1]   ; 
    my %dict  = %{ $_[2] } ;

    ##  prepare arrays of output
    my @inpart ;
    my @otpart ;
    my @otword ;
    my @linkto ;

    ##  how many entries are there?
    my $nu_entry = $#{ $dict{$rsrch} } ;

    if ( $rlang =~ /SCEN/ ) {  
	for my $i (0..$nu_entry) {
	    if ( ${ ${ $dict{$rsrch} }[$i] }{"en_word"} ne '<br>') {
		push( @inpart , ${ ${ $dict{$rsrch} }[$i] }{"sc_part"} );
		push( @otpart , ${ ${ $dict{$rsrch} }[$i] }{"en_part"} );
		push( @otword , ${ ${ $dict{$rsrch} }[$i] }{"en_word"} );
		my $link = ( ! defined ${ ${ $dict{$rsrch} }[$i] }{"linkto"} ) ? "" : ${ ${ $dict{$rsrch} }[$i] }{"linkto"} ;
		push( @linkto , $link );
	    }
	}
    } elsif ( $rlang =~ /SCIT/ ) {  
	for my $i (0..$nu_entry) {
	    if ( ${ ${ $dict{$rsrch} }[$i] }{"it_word"} ne '<br>') {
		push( @inpart , ${ ${ $dict{$rsrch} }[$i] }{"sc_part"} );
		push( @otpart , ${ ${ $dict{$rsrch} }[$i] }{"it_part"} );
		push( @otword , ${ ${ $dict{$rsrch} }[$i] }{"it_word"} );
		my $link = ( ! defined ${ ${ $dict{$rsrch} }[$i] }{"linkto"} ) ? "" : ${ ${ $dict{$rsrch} }[$i] }{"linkto"} ;
		push( @linkto , $link );
	    }
	}
    } elsif ( $rlang =~ /ENSC/ ) {  
	for my $i (0..$nu_entry) {
	    if ( ${ ${ $dict{$rsrch} }[$i] }{"sc_word"} ne '<br>') {
		push( @inpart , ${ ${ $dict{$rsrch} }[$i] }{"en_part"} );
		push( @otpart , ${ ${ $dict{$rsrch} }[$i] }{"sc_part"} );
		push( @otword , ${ ${ $dict{$rsrch} }[$i] }{"sc_word"} );
		my $link = ( ! defined ${ ${ $dict{$rsrch} }[$i] }{"linkto"} ) ? "" : ${ ${ $dict{$rsrch} }[$i] }{"linkto"} ;
		push( @linkto , $link );
	    }
	}
    } elsif ( $rlang =~ /ITSC/ ) {  
	for my $i (0..$nu_entry) {
	    if ( ${ ${ $dict{$rsrch} }[$i] }{"sc_word"} ne '<br>') {
		push( @inpart , ${ ${ $dict{$rsrch} }[$i] }{"it_part"} );
		push( @otpart , ${ ${ $dict{$rsrch} }[$i] }{"sc_part"} );
		push( @otword , ${ ${ $dict{$rsrch} }[$i] }{"sc_word"} );
		my $link = ( ! defined ${ ${ $dict{$rsrch} }[$i] }{"linkto"} ) ? "" : ${ ${ $dict{$rsrch} }[$i] }{"linkto"} ;
		push( @linkto , $link );
	    }
	}
    }

    s/_SQUOTE_/'/g for @inpart ; 
    s/_SQUOTE_/'/g for @otpart ; 
    s/_SQUOTE_/'/g for @otword ; 
    s/_SQUOTE_/'/g for @linkto ; 
    return( \@inpart , \@otpart , \@otword , \@linkto ) ; 
}

sub mk_tophtml {

    my $topnav = $_[0] ; 

    my $ottxt ;
    $ottxt .= "Content-type: text/html\n\n";
    $ottxt .= '<!DOCTYPE html>' . "\n" ;
    $ottxt .= '<html>' . "\n" ;
    $ottxt .= '  <head>' . "\n" ;
    $ottxt .= '    <title>Dizziunariu di Dieli :: Eryk Wdowiak</title>' . "\n" ;
    $ottxt .= '    <meta name="DESCRIPTION" content="Sicilian-Italian-English Dictionary by Arthur Dieli">' . "\n" ;
    $ottxt .= '    <meta name="KEYWORDS" content="Sicilian, language, dictionary, Dieli, Arthur Dieli">' . "\n" ;
    $ottxt .= '    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' . "\n" ;
    $ottxt .= '    <meta name="Author" content="Eryk Wdowiak">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk.css">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_theme-bklyn.css">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_widenme.css">' . "\n" ;
    $ottxt .= '    <link rel="icon" type="image/png" href="/config/eryk-icon.png">' . "\n" ;
    $ottxt .= '    <meta http-equiv="Pragma" content="no-cache">' . "\n" ;
    $ottxt .= '    <meta http-equiv="Expires" content="0"> ' . "\n" ;
    $ottxt .= '    <meta name="viewport" content="width=device-width, initial-scale=1">' . "\n" ;
    $ottxt .= '    <style>' . "\n" ;
    $ottxt .= '    p.zero { margin-top: 0em; margin-bottom: 0em; }' . "\n" ;
    $ottxt .= '      div.cunzigghiu { position: relative; margin: auto; width: 50%;}' . "\n" ;
    $ottxt .= '      @media only screen and (max-width: 835px) { ' . "\n" ;
    $ottxt .= '          div.cunzigghiu { position: relative; margin: auto; width: 90%;}' . "\n" ;
    $ottxt .= '      }' . "\n" ;
    $ottxt .= '    </style>' . "\n" ;
    $ottxt .= '  </head>' . "\n" ;

    open( TOPNAV , $topnav ) || die "could not read:  $topnav";
    while(<TOPNAV>){ chomp;  $ottxt .= $_ . "\n" ; };
    close TOPNAV ;

    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    $ottxt .= '    <div class="col-m-12 col-12">' . "\n" ;
    $ottxt .= '      <h1>Dizziunariu Sicilianu</h1> <h2>di Arthur Dieli</h2>' . "\n" ;
    $ottxt .= '    </div>' . "\n" ;
    $ottxt .= '  </div>' . "\n" ;
    $ottxt .= '  <!-- end row div -->' . "\n" ;
    $ottxt .= '  ' . "\n" ;
    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    
    return $ottxt ;
}

sub mk_foothtm {

    my $footnav = $_[0] ; 

    my $ot ;
    $ot .= '<p style="margin-top: 1.5em; margin-bottom: 0.25em; text-align: center;">Grazii a <a href="http://www.dieli.net/" target="_blank">' ;
    $ot .= 'Arthur Dieli</a> pi cumpilari stu dizziunariu.</p>' . "\n" ; 
    ## $ot .= '<a href="http://www.dieli.net/SicilyPage/SicilianLanguage/Vocabulary.html"' . "\n" ;
    ## $ot .= '   target="_blank">' . "vocabulary lists" . '</a> ' . "\n" ;

    ##  open inner DIV 
    $ot .= '<div class="row">' . "\n" ; 
 
    $ot .= '<div class="minicol"></div>' . "\n" ; 
    $ot .= '<div class="col-m-12 col-6">' . "\n" ; 
    $ot .= '<p style="margin-bottom: 0.25em;"><b><i>ricota di palori:</i></b></p>' . "\n" ; 
    $ot .= '<div class="col-m-6 col-6">' . "\n" ; 
    $ot .= '<ul style="margin-top: 0em; margin-bottom: 0em;">' . "\n" ;
    $ot .= '<li><a href="/cgi-bin/sicilian.pl?search=' . "COLL_aviri"    . '">' . "aviri"    . '</a> &amp; ' . "\n" ; 
    $ot .=     '<a href="/cgi-bin/sicilian.pl?search=' . "COLL_have"     . '">' . "to have"  . '</a></li>'   . "\n" ; 
    $ot .= '<li><a href="/cgi-bin/sicilian.pl?search=' . "COLL_essiri"   . '">' . "essiri"    . '</a></li>'  . "\n" ; 
    $ot .= '<li><a href="/cgi-bin/sicilian.pl?search=' . "COLL_fari"     . '">' . "fari"      . '</a></li>'  . "\n" ; 
    $ot .= '<li><a href="/cgi-bin/sicilian.pl?search=' . "COLL_timerel"  . '">' . "tempu"     . '</a></li>'  . "\n" ; 
    $ot .= '</ul>' . "\n" ;
    $ot .= '</div>' . "\n" ;
    $ot .= '<div class="col-m-6 col-6">' . "\n" ; 
    $ot .= '<ul style="margin-top: 0em; margin-bottom: 0em;">' . "\n" ;
    $ot .= '<li><a href="/cgi-bin/sicilian.pl?search=' . "COLL_daysweek" . '">' . "iorni"     . '</a></li>'  . "\n" ; 
    $ot .= '<li><a href="/cgi-bin/sicilian.pl?search=' . "COLL_months"   . '">' . "misi"      . '</a></li>'  . "\n" ; 
    $ot .= '<li><a href="/cgi-bin/sicilian.pl?search=' . "COLL_holidays" . '">' . "festi"     . '</a></li>'  . "\n" ; 
    $ot .= '<li><a href="/cgi-bin/sicilian.pl?search=' . "COLL_seasons"  . '">' . "staggiuni" . '</a></li>'  . "\n" ; 
    $ot .= '</ul>' . "\n" ;
    $ot .= '</div>' . "\n" ;
    $ot .= '</div>' . "\n" ;

    $ot .= '<div class="col-m-12 col-5">' . "\n" ; 
    $ot .= '<p style="margin-bottom: 0.25em;"><b><i>pàggini principali:</i></b></p>' . "\n" ; 
    $ot .= '<ul style="margin-top: 0em; margin-bottom: 0em;">' . "\n" ;
    $ot .= '<li><i><a href="/cgi-bin/sicilian.pl">Dizziunariu di Dieli</a></i></li>' . "\n" ; 
    $ot .= '<li><i><a href="/cgi-bin/cchiu-da-palora.pl">Cchiù dâ Palora</a></i></li>' . "\n" ; 
    $ot .= '</ul>' . "\n" ;
    $ot .= '<p style="margin-bottom: 0.25em;"><b><i>cchiù di stu prujettu:</i></b></p>' . "\n" ; 
    $ot .= '<ul style="margin-top: 0em; margin-bottom: 0em;">' . "\n" ;
    $ot .= '<li><a href="/archive/sicilian/index.shtml">specificazioni dû dizziunariu</a></li>' . "\n" ; 
    $ot .= '<li><a href="/archive/sicilian/sicilian-verbs.shtml">boot and stem theory</a></li>' . "\n" ; 
    $ot .= '</ul>' . "\n" ;
    $ot .= '</div>' . "\n" ;
    $ot .= '<div class="minicol"></div>' . "\n" ; 
    
    $ot .= '</div>' . "\n" ;
    ##  close inner div

    ##  let's keep this thing wide on large screens
    $ot .= '<div class="widenme"></div>' . "\n" ; 

    ##  add some space on the bottom
    $ot .= '<br>' . "\n" ;

    $ot .= '  </div>' . "\n" ;
    $ot .= '  <!-- end row div -->' . "\n" ;
    
    open( FOOTNAV , $footnav ) || die "could not read:  $footnav";
    while(<FOOTNAV>){ chomp;  $ot .= $_ . "\n" ; };
    close FOOTNAV ;
    
    return $ot ;
}


sub mk_newform {

    my $lgparm = $_[0] ;

    my $ottxt ;
    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/sicilian.pl" method="post">' . "\n" ;
    $ottxt .= '<table style="max-width:500px;"><tbody>' . "\n" ;
    $ottxt .= '<tr><td colspan="2">' . '<input type=text name="search" size=36 maxlength=72>' . '</td></tr>' . "\n" ;
    $ottxt .= '<tr><td>' . "\n" ; 

    $ottxt .= '<select name="langs">' . "\n" ;
    if ( $lgparm =~ /SCEN|ENSC/ ) {
	$ottxt .= '<option value="SCEN">Sicilianu-Ngrisi'  . "\n" ;
	$ottxt .= '<option value="SCIT">Sicilianu-Talianu' . "\n" ;
    } else {
	$ottxt .= '<option value="SCIT">Sicilianu-Talianu' . "\n" ;
	$ottxt .= '<option value="SCEN">Sicilianu-Ngrisi'  . "\n" ;
    }
    
    $ottxt .= '</select>' . "\n" ;
    $ottxt .= '</td>' . "\n" ;
    $ottxt .= '<td align="right">' . '<input type="submit" value="Traduci">' . "\n" ;
    ## $ottxt .= '<input type=reset value="Clear Form">' . "\n" ; 
    $ottxt .= '</td></tr>' . "\n" ;
    $ottxt .= '</tbody></table>' . "\n" ;
    $ottxt .= '</form>' . "\n" ;

    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/sicilian.pl" method="post">' . "\n" ;
    $ottxt .= '<table style="max-width:500px;"><tbody>' . "\n" ;
    $ottxt .= '<tr><td colspan="2">' . '<input type=text name="search" size=36 maxlength=72>' . '</td></tr>' . "\n" ;
    $ottxt .= '<tr><td>' . "\n" ; 

    $ottxt .= '<select name="langs">' . "\n" ;
    if ( $lgparm =~ /SCEN|ENSC/ ) {
	$ottxt .= '<option value="ENSC">Ngrisi-Sicilianu'  . "\n" ;
	$ottxt .= '<option value="ITSC">Talianu-Sicilianu' . "\n" ;
    } else {
	$ottxt .= '<option value="ITSC">Talianu-Sicilianu' . "\n" ;
	$ottxt .= '<option value="ENSC">Ngrisi-Sicilianu'  . "\n" ;
    }
    
    $ottxt .= '</select>' . "\n" ;
    $ottxt .= '</td>' . "\n" ;
    $ottxt .= '<td align="right">' . '<input type="submit" value="Traduci">' . "\n" ;
    ## $ottxt .= '<input type=reset value="Clear Form">' . "\n" ; 
    $ottxt .= '</td></tr>' . "\n" ;
    $ottxt .= '</tbody></table>' . "\n" ;
    $ottxt .= '</form>' . "\n" ;
        
    return $ottxt ;
}

##  make collections
sub mk_collections {

    ##  hash to output
    my %othash ;

    ##  COLL_have
    @{ $othash{"COLL_have"} } = ( 
	["ENSC"],
	["have"],
	["have to"],
	["have to do"],
	["have a light complexion","have a dark complexion"],
	["have dinner"], 
	["have fun"],
	["have a good time","have pleasure"],
	["have knowledge"],
	["have makeup on"],
	["have a limp"],
	["have a desire"],
	["have an urge"],
	## ["have homosexual relations","have intercourse","have an orgasm"],
	);

    ##  COLL_aviri
    @{ $othash{"COLL_aviri"} } = (
	["SCEN"],
	["aviri"],
	["aviri a"],
	["aviri a chi fari","aviri a chi fari (cu)"],	
	["aviri bisognu","aviri di bisognu"],
	["aviri disidderiu"],
	["aviri ficatu"],
	["nun aviri fiducia"],
	["aviri fami"],
	["aviri paura"],
	["aviri sapuri"],
	["aviri siti"],
	["aviri spinnu"],
	["aviri vogghia"],
	);

    ##  COLL_essiri
    @{ $othash{"COLL_essiri"} } = (
	["SCEN"],
	["essiri"],
	["essiri chiaru di peddi","essiri scuru di peddi"],
	["po essiri"],
	["essiri d_SQUOTE_accordu"],
	["essiri dignu"],
	["essiri eredi"],
	["essiri nnamuratu"],
	["essiri paru"],
	["essiri umanu"],
	["essiri utili"],
	);
    
    ##  COLL_fari
    @{ $othash{"COLL_fari"} } = ( 
	["SCEN"],
	["fari"],
	["farisi"],
	["farisi largu"],
	["farisi mpristari"],
	["farisi nnarreri"],
	["farisi vidiri"],
	["fari abbozzi"],
	["fari a cura du suli"],
	["fari affari con"],
	["fari a guardia"],
	["fari a pugna"],
	["fari attenzioni"],
	["fari capiri"],
	["fari cascare"],
	["fari causa"],
	["fari cena"],
	["fari contattu"],
	["fari cumpiri"],
	["fari dumanna pr_SQUOTE_impiegu"],
	["fari dumanni"],
	["fari ecu"],
	["fari fermari"],
	["fari finta"],
	["fari fretta"],
	["fari i provi"],
	["fari i spisi"],
	["fari lu dittu"],
	["fari mali"],
	["fari marcia ndarreri"],
	["fari na culletta"],
	["fari na durmitina"],
	["fari na passiata"],
	["fari na scampagnata"],
	["fari nutari"],
	["fari obbiezzioni"],
	["fari pagari"],
	["fari premura"],
	["fari priggiuneri"],
	["fari ricerchi"],
	["fari risposta"],
	["fari sapiri"],
	["fari sculari"],
	["fari taciri"],
	["fari tortu"],
	["fari u bagnu"],
	["fari u buffuni"],
	["fari u cruscè"],
	["fari un votu"],				     
	["fari u_SQUOTE_vai e veni"],
	["fari vela"],
	["fari veniri"],
	["fari ventu"],
	);
    
    ##  COLL_timerel
    @{ $othash{"COLL_timerel"} } = ( 
	["SCEN"],
	["oi","oj","òggi","stirnata"],
	["aieri","ajeri"],
	["dumani","rumani"],
	["oggi","oggigiornu"],
	["cutidianu"],
	["antura","avantìeri","dopporumani"],
	["vigghia"],
	["_SQUOTE_nnumani"],
	["agghiurnari"],
	["arburi","livata","luci du iornu","menziornu","nnoccu","notti"],
	["iornu","a lu iornu","iurnata","iurnata di travagghiu","jurnateri"],
	["festa","festa civili (ital)","iornu di festa"],
	["onomasticu"],
	["vacanza"],
	["simana","simanali","a la simana","fini da simana","fini di simana"],
	["misi","mensili","misaloru"],
	["annu","annuu","annata"], 
	["annaloru"],
	["bisesta"],
	["ovannu","avannu","avannu passatu","oggellannu","notrannu"],
	["cinquant'anni"],
	);
    
    ##  COLL_daysweek
    @{ $othash{"COLL_daysweek"} } = ( 
	["SCEN"],
	["luneddì","luniddì","luniddìa","lunidì","lùniri"],
	["marteddì","martiddì","martiddìa","màrtidi","màrtiri"],
	["mercoldì","mercoleddì","mercuccì","mercuddì","mercuddìa","merculiddì","merculiddìa","mèrcuri","mìerculi"],
	["gioveddì","giuviddì","giuviddìa","ioviddì","iuviddì","iuviddìa","iòviri","jòvidi","jòviri"],
	["vennadi","venneddì","vinniddì","vinniddìa","vènnari","vìenniri"],
	["sabbatu","sabbatuddì","sabbatuddìa"],
	["dumìnica","dumìnicaddi","dumìnicaddia"],
	);

    ##  COLL_months
    @{ $othash{"COLL_months"} } = ( 
	["SCEN"],
	["Jinnaru","ginnaiu","jinnaru"],
	["fibraiu","frivaru"],
	["marzu"],
	["aprili"],
	["maggiu","maju","majulinu"],
	["giugnu"],
	["giugnettu","lugliu"],
	["agustu","austu"],
	["settembri","settìmeri"],
	["ottubbri"],
	["novembri","novemmiru","nuvìemri"],
	["decembri"],
	);
    
    ##  COLL_holidays
    @{ $othash{"COLL_holidays"} } = ( 
	["SCEN"],
	["compleannu"],
	["natali"],["capudannu"],
	["carnilivari"],
	["sdirri","sdirrisira"],
	["marteddì grassu"],
	["pasqua"],
	["pentecosti"],
	["u primu maggiu"],
	["nespola di màiu"],
	);

    ##  COLL_seasons
    @{ $othash{"COLL_seasons"} } = ( 
	["SCEN"],
	["autunnu"],
	["invernu","invirnata"],
	["primavera"],
	["estati","estivu"],
	["ura estiva"],
	["menza estati","agustinu"],
	["sta","staggiuni","stagghiuni"],
	["statizzari"],
	["stati","statia"],
	## ["colonia di vacanze (ital)"],
	);

    return %othash ;
}
