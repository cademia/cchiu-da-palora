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
##no warnings qw(uninitialized);
use CGI qw(:standard);
use Storable qw( retrieve ) ;
#{   no warnings;             
    ## $Storable::Deparse = 1;  
    $Storable::Eval    = 1;  
#}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  what are we looking for?
my $lgparm = ( ! defined param('langs') ) ? "SCEN" : param('langs') ;
my $rquest = param('langs') ;
my $insearch = param('search') ;

##  which dictionary to retrieve?
my %dieli ; 
if ( $rquest =~ /SCEN|SCIT/ ) {  %dieli = %{ retrieve('../cgi-lib/dieli-sc-dict') };
} elsif ( $rquest =~ /ENSC/ ) {  %dieli = %{ retrieve('../cgi-lib/dieli-en-dict') };
} elsif ( $rquest =~ /ITSC/ ) {  %dieli = %{ retrieve('../cgi-lib/dieli-it-dict') };
} else {  my $blah = "retrieve nothing -- no language requested" ;
} 

##  retrieve subroutines
my $vthash  = retrieve('../cgi-lib/verb-tools' );
my %vbsubs  = %{ $vthash->{vbsubs} } ;

my $cchash = retrieve('../cgi-lib/cchiu-tools' );
my %ddsubs = %{ $cchash->{ddsubs} } ;

##  searches split by vertical bar
my @searches = split( "_OR_" , $insearch ) ; 
s/^\s*// for @searches ; 
s/\s*$// for @searches ; 
s/'/_SQUOTE_/g for @searches ; 

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  we need to make a webpage, so let's get some HTML
my $tophtml  = $ddsubs{mk_ddtophtml}( "../config/topnav.html");
my $newform  = $ddsubs{mk_newform}( $lgparm , $insearch );
my $thanks   = $ddsubs{thank_dieli}();
my $foothtml = $ddsubs{mk_foothtml}("../config/navbar-footer.html");

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  initialize output HTML
my $otline ; 
$otline .= "\n" ; 

##  translate and pass output to HTML
foreach my $search (@searches) {

    ##  if "collection" ...
    if ( $search =~ /^COLL_/ ) {
	my %collections = mk_collections() ;
	my @whichcolls = grep( /$search/ , keys( %collections ) ); 
	foreach my $collection (@whichcolls) {

	    ##  get the reference
	    my $cref   = $collections{$collection} ;
	    my $slang = ${${$cref}[0]}[0] ;
	    
	    ##  if more then one collection requested, then dictionaries load more than once
	    ##  but I'm not providing any links that we make more than one collection request
	    my $dieli_slang ; 

	    if ( $slang =~ /SCEN|SCIT/ ) {  $dieli_slang = retrieve('../cgi-lib/dieli-sc-dict');
	    } elsif ( $slang =~ /ENSC/ ) {  $dieli_slang = retrieve('../cgi-lib/dieli-en-dict');
	    } elsif ( $slang =~ /ITSC/ ) {  $dieli_slang = retrieve('../cgi-lib/dieli-it-dict');
	    } else {  my $blah = "retrieve nothing -- no language requested" ;
	    }

	    for my $i (1..$#{$cref}) { 
		$otline .= '<br>' . "\n" ; 
		my $pclass = ' class="zero"' ;
		$otline .= '<div align="center">' . "\n" ; 
		for my $j (0..$#{${$cref}[$i]}) {
		    $otline .= $ddsubs{mk_search}( $slang , ${${$cref}[$i]}[$j] , $dieli_slang , \%ddsubs , $lgparm , $pclass , "BeNice" ) ; 
		}
		$otline .= '</div>' . "\n" ; 	
	    }
	}


    } elsif ( $rquest =~ /SCEN|SCIT|ENSC|ITSC/ ) { 
	##  no collection was requested, so 
	##  check if language specified in request
	##  if language not specified, then there is no request

	if ( $insearch =~ /_OR_/ ) { 
	    ##  _OR_ was specified, so limit results
	    my $pclass = "" ; 
	    $otline .= '<div align="center">' . "\n" ; 
	    $otline .= $ddsubs{mk_search}( $rquest, $search , \%dieli , \%ddsubs , $lgparm , $pclass , "BeNice" ) ; 
	    $otline .= '</div>' . "\n" ; 

	} elsif ( length($insearch) < 5 ) {
	    ###  ( $rquest =~ /SCEN|SCIT/ && 
	    ###    ( length($insearch) < 2 || 
	    ###      $search =~ /lu|la|li|ca|cu|di|nna|nni|nta|ntra|pi|pri/ ) )  
	    ##  
	    ##  search string less than five
	    ##  search string small, but broaden results by dropping accents

	    my @subsearches ; 
	    foreach my $key (sort keys(%dieli) ) {
		my $sch_noa = $vbsubs{rid_accents}( $search ) ;
		my $key_noa = $vbsubs{rid_accents}( $key ) ;  
		$key_noa =~ s/[\(\)]//g;  $key_noa =~ s/_SQUOTE_/ /g;
		$sch_noa =~ s/[\(\)]//g;  $sch_noa =~ s/_SQUOTE_/ /g;
		if ( $key_noa eq $sch_noa ) {
		    push( @subsearches , $key ) ;
		}
	    }
	    if ( $#subsearches > -1 ) {
		foreach my $subsearch ($ddsubs{uniq}(@subsearches)) {
		    my $pclass = ' style="margin-top: 0em; margin-bottom: 0.35em;"' ; 
		    $otline .= '<div align="center" style="margin-bottom: 0.5em; margin-top: 1.0em;">' . "\n" ; 
		    $otline .= $ddsubs{mk_search}( $rquest, $subsearch , \%dieli , \%ddsubs , $lgparm , $pclass , "BeNice" ) ; 
		    $otline .= '</div>' . "\n" ; 
		}
	    } else {
		$otline .= '<div align="center">' . "\n" ; 
		$otline .= "<p>nun c'è na traduzzioni dâ palora: " . '&nbsp; <b>' . $search . '</b></p>';
		$otline .= '</div>' . "\n" ; 
	    }
	    
	} else {
	    ##  search string five characters or more, so let's broaden search further
	    ##  drop accents and check for matching word within key
	    my @subsearches ; 
	    foreach my $key (sort keys(%dieli) ) {
		my $sch_noa = $vbsubs{rid_accents}( $search ) ;
		my $key_noa = $vbsubs{rid_accents}( $key ) ;  
		$key_noa =~ s/[\(\)]//g;
		$key_noa =~ s/_SQUOTE_/ /g;

		if ( $key_noa =~ /$sch_noa/ ) {
		    ##  found search term in key
		    ##  does search term match a word in key?
		    my @key_wds = split( / /, $key_noa ) ;
		    foreach my $keyword (@key_wds) {
			if ( $sch_noa =~ /$keyword/ ) {
			    push( @subsearches , $key ) ;
			}
		    }
		}
	    }
	    if ( $#subsearches > -1 ) {
		foreach my $subsearch ($ddsubs{uniq}(@subsearches)) {
		    my $pclass = ' style="margin-top: 0em; margin-bottom: 0.35em;"' ; 
		    $otline .= '<div align="center" style="margin-bottom: 0.5em; margin-top: 1.0em;">' . "\n" ; 
		    $otline .= $ddsubs{mk_search}( $rquest, $subsearch , \%dieli , \%ddsubs , $lgparm , $pclass , "BeNice" ) ; 
		    $otline .= '</div>' . "\n" ; 
		}
	    } else {
		$otline .= '<div align="center">' . "\n" ; 
		$otline .= "<p>nun c'è na traduzzioni dâ palora: " . '&nbsp; <b>' . $search . '</b></p>';
		$otline .= '</div>' . "\n" ; 
	    }
	} 
    }
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make webpage
print $tophtml ;
print $newform ;
print $otline  ;
print $thanks  ;
print $foothtml ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

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
	["nnumani"],
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
    
    ## COLL_places
    @{ $othash{"COLL_places"} } = ( 
	["SCEN"],
	["Sicilia",],
	["Cartagiruni","Castedduvitranu","Partinicu","Patti","Siracusa",], ## "Siragusa",],
	["munnu",],
	["Arabbia Saudita","Australia","Austria","Belgiu","Bolivia","Brasili","Bulgaria",
	 "Cecoslovacchia","Cile","Cina","Colombia","Cuba","Danimarca","Ecuaturi","Egittu",
	 "Li Filipini","Francia","Galles","Girmania","Gran Britagna","Grecia","India",
	 "Indonisia","Inghilterra","Iran","Iraq","Irlanda","Islanda","Israeli","Italia",
	 "Iugoslavia","Marocco","Messicu","Nepal","Nicaragua","Nigeria","Norveggia",
	 "Nova Zilanna","Olanda","Pakistan","Persia","Perù","Polonia","Portugallu",
	 "Regnu Unitu","Rumanìa","Russia","Sardegna","Scandinavia","Scozzia","Siria","Spagna",
	 "Stati Uniti","Sud Àfrica","Svezzia","Svizzira","Ungheria","Unioni suvietica","Uruguai",],
	["Ceca","Cilenu","Cinisi","Danesi","Egizianu","Indianu","Indonisianu","Inglisi","Irachenu",
	 "Iranianu","Irlandesi","Islandisi","Israelanu","Missicanu","Olandisi","Pakistanu",
	 "Scandinavu","Scuzzisi","Tedescu","Ungheresi",],
	["Atlanticu","Europa","Sud America",],
    );

    return %othash ;
}

##  people
##  ["Cristu","Franciscu","Salamuni","Sammartinu","Omèru","Pirinnellu","Umèru",],
##   
##  random
##  ["Imprisa","Re Filippu",],
