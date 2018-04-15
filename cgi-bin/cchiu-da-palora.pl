#!/usr/bin/env perl

##  "cchiu-da-palora.pl" -- annotates the Dieli dictionary
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
use warnings;
use CGI qw(:standard);
use Storable qw( retrieve ) ;
{   no warnings;             
    ## $Storable::Deparse = 1;  
    $Storable::Eval    = 1;  
}

##  retrieve hashes and subroutines
my $vthash = retrieve('../cgi-lib/verb-tools' );
my %vbconj = %{ $vthash->{vbconj} } ;
my %vbsubs = %{ $vthash->{vbsubs} } ;

my $vnhash = retrieve('../cgi-lib/verb-notes' );
my %vnotes = %{ $vnhash } ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  what are we looking for?
my $inword = param('palora') ; 
my $lgparm = ( ! defined param('langs') ) ? "SCEN" : param('langs') ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make webpage -- do not conjugate if $inword not defined
print mk_tophtml( "../config/topnav.html");
print mk_newform( $lgparm );
if ( ! defined $inword ) {
    print mk_showall(  \%vnotes , \%vbconj , \%vbsubs ) ;
} else { 

    ##  print translations and notes
    print mk_dielitrans( $inword , \%vnotes , \%vbconj , \%vbsubs ) ;
    print mk_notex( $inword , \%vnotes ) ;

    ##  are we working with a verb, noun or adjective?
    my $isverb = ( ! defined $vnotes{ $inword }{verb}     && 
		   ! defined $vnotes{ $inword }{reflex}   && 
		   ! defined $vnotes{ $inword }{prepend}            ) ? "false" : "true" ;
    my $isnoun = ( ! defined $vnotes{ $inword }{noun}               ) ? "false" : "true" ;
    my $isadj  = ( $vnotes{ $inword }{part_speech} ne "adj" ) ? "false" : "true" ;

    ##  "other" parts of speech currently include:  {adv} {prep} {pron}
    my $isother  = ( ! defined $vnotes{ $inword }{part_speech} ) ? "false" : "true" ;
    
    if ( $isverb eq "true" ) {
	print mk_conjhtml( $inword , \%vnotes , \%vbconj , \%vbsubs ) ;
	
    } elsif ( $isnoun eq "true" ) {
	print mk_nounhtml( $inword , \%vnotes , \%vbsubs ) ;
	
    } elsif ( $isadj  eq "true" ) {
	print mk_adjhtml( $inword , \%vnotes , \%vbsubs ) ;

    } elsif ( $isother  eq "true" ) {
	my $blah = "do nothing here.  we just want to avoid error message below." ; 
	
    } else {
	##  outer DIV to limit width
	my $othtml ; 
	$othtml .= '<div class="transconj">' . "\n" ; 
	$othtml .= '<div class="row">' . "\n" ; 
	$othtml .= '<p>' . "nun c'è" . ' na annotazzioni dâ palora: &nbsp; <b>' . $inword . '</b></p>' . "\n" ;
	$othtml .= '</div>' . "\n" ; 
	$othtml .= '</div>' . "\n" ; 
	print $othtml ; 
	print mk_showall(  \%vnotes , \%vbconj , \%vbsubs ) ;
    }
}
print mk_foothtm("../config/navbar-footer.html");

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

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

sub mk_showall {

    my %vnotes = %{ $_[0] } ;
    my $vbcref =    $_[1]   ;  ##  hash reference
    my $vbsubs =    $_[2]   ;  ##  hash reference
    
    ##  let's split the print over four columns
    ##  keep words together by first letter
    my @vnkeys = sort( {$vbsubs{rid_accents}($a) cmp $vbsubs{rid_accents}($b)} keys(%vnotes) );
    my $vnkqtr = int( $#vnkeys / 4 ) ; 
    
    ##  scalar to adjust length of first and second columns (for appearances)
    my $adjustment = 0 ;
    
    ##  first column
    my $vnstart = 0 ; 
    my $vnkidx = $vnkqtr + $adjustment ; 
    my @vnkone = @vnkeys[$vnstart..$vnkidx] ; 
    foreach my $palora (@vnkeys[$vnkidx+1..$#vnkeys] ) {
	##  if same letter, add to column and increment the index
	my $newletter = substr(lc($vbsubs{rid_accents}($palora)),0,1) ; 
	my $oldletter = substr(lc($vbsubs{rid_accents}($vnkeys[$vnkidx])),0,1) ; 	
	if ( $newletter eq $oldletter ) { 
	    push( @vnkone , $palora ) ;
	    $vnkidx += 1 ; 
	}
    }

    ##  second column
    $vnstart = $vnkidx+1 ; 
    $vnkidx += $vnkqtr - $adjustment ; 
    my @vnktwo = @vnkeys[$vnstart..$vnkidx] ; 
    foreach my $palora (@vnkeys[$vnkidx+1..$#vnkeys] ) {
	##  if same letter, add to column and increment the index
	my $newletter = substr(lc($vbsubs{rid_accents}($palora)),0,1) ; 
	my $oldletter = substr(lc($vbsubs{rid_accents}($vnkeys[$vnkidx])),0,1) ; 
	if ( $newletter eq $oldletter ) { 
	    push( @vnktwo , $palora ) ;
	    $vnkidx += 1 ; 
	}
    }

    ##  third column
    $vnstart = $vnkidx+1 ; 
    $vnkidx += $vnkqtr ; 
    my @vnktre = @vnkeys[$vnstart..$vnkidx] ; 
    foreach my $palora (@vnkeys[$vnkidx+1..$#vnkeys] ) {
	##  if same letter, add to column and increment the index
	my $newletter = substr(lc($vbsubs{rid_accents}($palora)),0,1) ; 
	my $oldletter = substr(lc($vbsubs{rid_accents}($vnkeys[$vnkidx])),0,1) ; 
	if ( $newletter eq $oldletter ) { 
	    push( @vnktre , $palora ) ;
	    $vnkidx += 1 ; 
	}
    }

    ##  fourth column
    $vnstart = $vnkidx+1 ; 
    my @vnkqtt = @vnkeys[$vnstart..$#vnkeys] ; 
      

    ##  open the div
    my $othtml ;
    $othtml .= '<div class="listall">' . "\n" ; 
    $othtml .= '<div class="row">' . "\n" ; 

    ##  now print
    $othtml .= '<div class="rolltb">' . "\n" ; 
    $othtml .= '<div class="rolldk">' . "\n" ; 
    $othtml .= mk_vnkcontent( \@vnkone , $vbcref , $vbsubs );
    $othtml .= '</div>' . "\n" ;
    $othtml .= '<div class="rolldk">' . "\n" ; 
    $othtml .= mk_vnkcontent( \@vnktwo , $vbcref , $vbsubs );
    $othtml .= '</div>' . "\n" ;
    $othtml .= '</div>' . "\n" ;
    

    $othtml .= '<div class="rolltb">' . "\n" ; 
    $othtml .= '<div class="rolldk">' . "\n" ; 
    $othtml .= mk_vnkcontent( \@vnktre , $vbcref , $vbsubs );
    $othtml .= '</div>' . "\n" ;
    $othtml .= '<div class="rolldk">' . "\n" ; 
    $othtml .= mk_vnkcontent( \@vnkqtt , $vbcref , $vbsubs );
    $othtml .= '</div>' . "\n" ;
    $othtml .= '</div>' . "\n" ;

    ##  close the div
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 

    return $othtml ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

sub mk_vnkcontent {

    my $vnkarf = $_[0] ;
    my $vbcref = $_[1]   ;  ##  hash reference
    my $vbsubs = $_[2]   ;  ##  hash reference
    
    my $hold_letter = "" ; 
    my $othtml ;
    
    foreach my $palora (@{$vnkarf}) {
	##  which word do we display?
	##  get the infinitive
	
	if ( ! defined $vnotes{$palora}{hide} ) {
	    ##  if not hiding a (theoretical) non-reflexive form 
	    
	    ##  print initial letter if necessary
	    my $initial_letter = substr( $vbsubs{rid_accents}($palora) , 0 , 1 ) ; 
	    if ( $initial_letter ne $hold_letter ) {
		$hold_letter = $initial_letter ; 
		$othtml .= '<p style="margin-left: 10px"><b><i>' . uc($hold_letter) . '</i></b></p>' . "\n" ;
	    }
	    

	    ## initialize the word to display
	    my $display ;
	    if ( ! defined $vnotes{ $palora }{verb}     || 
		 ! defined $vnotes{ $palora }{reflex}   || 
		 ! defined $vnotes{ $palora }{prepend}  ) { 
		
		##  not a verb, so ...
		##  first choice is "display_as",  second choice is hash key
		$display = ( ! defined $vnotes{$palora}{display_as} ) ? $palora : $vnotes{$palora}{display_as} ;		
		
	    } else { 
		##  fetching to get conjugated infinitive
		my %othash = fetch_othash( $palora , \%vnotes , $vbcref , $vbsubs ) ; 

		##  is a verb, so ...
		##  first choice is "display_as",  second choice is conjugated infinitive,  third choice is hash key
		$display = ( ! defined $othash{inf} ) ? $palora : $othash{inf} ;
		$display = ( ! defined $vnotes{$palora}{display_as} ) ? $display : $vnotes{$palora}{display_as} ;
	    }

	    ##  create link
	    my $link = '<a href="/cgi-bin/cchiu-da-palora.pl?palora=' . $palora . '">' . $display . '</a>' ;
	    
	    ##  prepare output
	    $othtml .= '<p class="zero">' . $link . '</p>' . "\n" ; 
	}
    }
    
    return $othtml ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

sub fetch_othash {

    my $palora =    $_[0]   ;
    my %vnotes = %{ $_[1] } ;
    my $vbcref =    $_[2]   ;  ##  hash reference
    my $vbsubs =    $_[3]   ;  ##  hash reference

    ##  which word do we display?
    my %othash ;

    ##  which are defined?
    my $reflex  = $vnotes{$palora}{reflex}  ;

    my $prepend = ( ! defined $vnotes{$reflex}{prepend} ) ? $vnotes{$palora}{prepend} : $vnotes{$reflex}{prepend} ;
    my $prep  = ( ! defined ${$prepend}{prep} ) ? ""      : ${$prepend}{prep} ;
    my $verb  = ( ! defined ${$prepend}{verb} ) ? $palora : ${$prepend}{verb} ;  
    

    ##  first see if reflexive
    if ( defined $reflex ) {
	if ( ! defined 	$vnotes{$reflex}{prepend} ) {
	    %othash = $vbsubs{conjreflex}( $vnotes{$reflex} , $vbcref , $vbsubs , $prep );
	} else {
	    %othash = $vbsubs{conjreflex}( $vnotes{$verb} , $vbcref , $vbsubs , $prep );
	}
    } else {
	%othash = $vbsubs{conjnonreflex}( $vnotes{$verb} , $vbcref , $vbsubs , $prep );
    }

    return %othash ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

sub mk_dielitrans {

    my $palora =    $_[0]   ;
    my %vnotes = %{ $_[1] } ;
    my $vbcref =    $_[2]   ;  ##  hash reference
    my $vbsubs =    $_[3]   ;  ##  hash reference
    
    ##  prepare output
    my $ot ;    
    my %othash ;

    ##  are we working with a verb?
    my $isverb = ( ! defined $vnotes{ $inword }{verb}     && 
		   ! defined $vnotes{ $inword }{reflex}   && 
		   ! defined $vnotes{ $inword }{prepend}            ) ? "false" : "true" ;
    if ( $isverb eq "true" ) {
	%othash = fetch_othash( $palora , \%vnotes , $vbcref , $vbsubs ) ; 
    }
    
    ##  which word do we display?
    my $display ;
    $display = ( ! defined $othash{inf} ) ? $palora : $othash{inf} ;
    $display = ( ! defined $vnotes{$palora}{display_as} ) ? $display : $vnotes{$palora}{display_as} ;
    
    ##  which word do we redirect to? 
    my $redirect = ( ! defined $vnotes{$palora}{dieli} ) ? $display : join( "_OR_", @{$vnotes{$palora}{dieli}} ) ;
    
    ##  outer DIV to limit width
    $ot .= '<div class="transconj">' . "\n" ; 
    $ot .= '<p><b><a href="/cgi-bin/sicilian.pl?' . 'search=' . $redirect . '&langs=' . $lgparm . '">' ; 
    $ot .= $display . '</a></b>' ;

    ##  parti di discursu 
    my $part_speech = $vnotes{ $palora }{part_speech} ;

    ##  translate to Sicilian
    $part_speech =~ s/^verb$/verbu/ ;
    $part_speech =~ s/^noun$/sust./ ;
    $part_speech =~ s/^adj$/agg./ ;
    $part_speech =~ s/^adv$/avv./ ;
    $part_speech =~ s/^prep$/prip./ ;
    $part_speech =~ s/^pron$/prun./ ;
    
    $ot .= '&nbsp;&nbsp;{' . $part_speech . '}</p>' . "\n" ;
    
    $ot .= '<div class="row">' . "\n" ; 

    ##  what does the word translate to?
    my @dieli_en_links  ; 
    my @dieli_it_links  ; 
    foreach my $trans (@{$vnotes{$palora}{dieli_en}}) {
	push( @dieli_en_links , '<a href="/cgi-bin/sicilian.pl?search=' . $trans . '&langs=ENSC">' . $trans . '</a>' );
    } 
    foreach my $trans (@{$vnotes{$palora}{dieli_it}}) {
	push( @dieli_it_links , '<a href="/cgi-bin/sicilian.pl?search=' . $trans . '&langs=ITSC">' . $trans . '</a>' );
    } 
    my $dieli_en_str = join( ', ' , @dieli_en_links ); 
    my $dieli_it_str = join( ', ' , @dieli_it_links ); 
    
    $ot .= '<p style="margin-top: 0em; margin-bottom: 0em;"><b>EN:</b> &nbsp; ' . $dieli_en_str . '</p>' . "\n" ; 
    $ot .= '<p style="margin-top: 0em; margin-bottom: 0em;"><b>IT:</b> &nbsp; ' . $dieli_it_str . '</p>' . "\n" ; 
    
    $ot .= '</div>' . "\n" ;
    $ot .= '</div>' . "\n" ;

    return $ot ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

sub mk_notex {

    my $palora =    $_[0]   ;
    my %vnotes = %{ $_[1] } ;
    
    my $othtml ;
    
    ##  get the notes and examples
    if ( ! defined $vnotes{$palora}{notex} ) {
	my $blah = "no examples here."
    } else {

	my @notex  = @{ $vnotes{$palora}{notex} };

	$othtml .= '<div class="transconj">' . "\n" ; 
	$othtml .= '<p style="margin-bottom: 0.25em;"><i>pi esempiu:</i></p>' . "\n" ;
	$othtml .= '<ul style="margin-top: 0.25em;">' . "\n" ;
	foreach my $line (@notex) {
	    $othtml .= "<li>" . $line . "</li>" . "\n" ;
	}
	$othtml .= "</ul>" . "\n" ;
	$othtml .= "</div>" . "\n" ;
    } 
    return $othtml ;
}


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

sub mk_nounhtml { 
    my $palora =    $_[0]   ;
    my %vnotes = %{ $_[1] } ;
    my $vbsubs =    $_[2]   ;  ##  hash reference 
    
    ##  first choice is "display_as",  second choice is hash key
    my $display = ( ! defined $vnotes{$palora}{display_as} ) ? $palora : $vnotes{$palora}{display_as} ;		

    ##  prepare output
    my $ot ;

    ##  which word do we redirect to? 
    my $redirect = ( ! defined $vnotes{$palora}{dieli} ) ? $palora : join( "_OR_", @{$vnotes{$palora}{dieli}} ) ;
    
    ##  outer DIV to limit width
    $ot .= '<div class="transconj">' . "\n" ;
    $ot .= '<p style="margin-bottom: 0.5em;"><b><a href="/cgi-bin/sicilian.pl?' . 'search=' . $redirect . '&langs=' . $lgparm . '">' ; 
    $ot .= $display . '</a></b></p>' . "\n" ;
    

    ##  $vbsubs{mk_noun_plural}() assumes "mas" or "fem" noun, some nouns are "both"
    ##  such "both" nouns end in "-a" in singular and "-i" in plural
    ##  the sub is written in such a way that it should be able to handle "both"
    my $gender = $vnotes{$palora}{noun}{gender} ; 
    my $plural = ( ! defined $vnotes{$palora}{noun}{plural} ) ? 
	$vbsubs{mk_noun_plural}( $palora , $gender ) : $vnotes{$palora}{noun}{plural} ;

    ##  singular and plural forms
    if ( $gender eq "mas" || $gender eq "both" ) {
	my $defart = ( $palora =~ /^[aeiou]/i ) ? "l'" : "lu " ; 
	$ot .= '<p style="margin-top: 0em; margin-bottom: 0em;"><i>ms.:</i> &nbsp; ' . $defart . $palora . "</p>" . "\n";
    }
    if ( $gender eq "fem" || $gender eq "both" ) {
	my $defart = ( $palora =~ /^[aeiou]/i ) ? "l'" : "la " ; 
	$ot .= '<p style="margin-top: 0em; margin-bottom: 0em;"><i>fs.:</i> &nbsp; &nbsp; ' . $defart . $palora . "</p>" . "\n";
    }
    { my $defart = ( $plural =~ /^[aeiou]/i ) ? "l'" : "li " ; 
      $ot .= '<p style="margin-top: 0em; margin-bottom: 0em;"><i>pl.:</i> &nbsp; &nbsp; ' . $defart . $plural . "</p>" . "\n";
    }

    
    ##  close DIV that limits width
    $ot .= '</div>' . "\n" ; 
    return $ot ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

sub mk_adjhtml { 
    my $palora =    $_[0]   ;
    my %vnotes = %{ $_[1] } ;
    my $vbsubs =    $_[2]   ;  ##  hash reference

    ##  first choice is "display_as",  second choice is hash key
    my $display = ( ! defined $vnotes{$palora}{display_as} ) ? $palora : $vnotes{$palora}{display_as} ;	
    
    ##  prepare output
    my $ot ;
    ##  which word do we redirect to? 
    my $redirect = ( ! defined $vnotes{$palora}{dieli} ) ? $palora : join( "_OR_", @{$vnotes{$palora}{dieli}} ) ;
    
    ##  outer DIV to limit width
    $ot .= '<div class="transconj">' . "\n" ;
    $ot .= '<p style="margin-bottom: 0.5em;"><b><a href="/cgi-bin/sicilian.pl?' . 'search=' . $redirect . '&langs=' . $lgparm . '">' ; 
    $ot .= $display . '</a></b></p>' . "\n" ;
    
    ##  fetch singular and plural forms
    my ($massi , $femsi , $maspl , $fempl) = $vbsubs{mk_adjectives}($palora) ;

    ##  singular and plural forms
    $ot .= '<p style="margin-top: 0em; margin-bottom: 0em;"><i>ms.:</i> &nbsp; ' . $massi . "</p>" . "\n";
    $ot .= '<p style="margin-top: 0em; margin-bottom: 0em;"><i>fs.:</i> &nbsp; &nbsp; ' . $femsi . "</p>" . "\n";
    if ( $maspl ne $fempl ) {
	$ot .= '<p style="margin-top: 0em; margin-bottom: 0em;"><i>mp.:</i> &nbsp; '        . $maspl . "</p>" . "\n";
	$ot .= '<p style="margin-top: 0em; margin-bottom: 0em;"><i>fp.:</i> &nbsp; &nbsp; ' . $fempl . "</p>" . "\n";
    } else {
	$ot .= '<p style="margin-top: 0em; margin-bottom: 0em;"><i>pl.:</i> &nbsp; &nbsp; ' . $maspl . "</p>" . "\n";
    }

    
    ##  close DIV that limits width
    $ot .= '</div>' . "\n" ; 
    return $ot ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

sub mk_conjhtml {
    
    my $palora =    $_[0]   ;
    my %vnotes = %{ $_[1] } ;
    my $vbcref =    $_[2]   ;  ##  hash reference
    my $vbsubs =    $_[3]   ;  ##  hash reference
    
    my %forms  = $vbsubs{mk_forms}() ; 
    my @tenses = @{ $forms{tenses} } ; 
    my %tnhash = %{ $forms{tnhash} } ; 
    my @people = @{ $forms{people} } ; 

    ##  conjugate the verb
    my %othash = fetch_othash( $palora , \%vnotes , $vbcref , $vbsubs ) ; 

    ##  prepare output
    my $ot ;

    ##  which word do we redirect to? 
    my $redirect = ( ! defined $vnotes{$palora}{dieli} ) ? $palora : join( "_OR_", @{$vnotes{$palora}{dieli}} ) ;
    
    ##  outer DIV to limit width
    $ot .= '<div class="transconj">' . "\n" ;
    $ot .= '<p><b><a href="/cgi-bin/sicilian.pl?' . 'search=' . $redirect . '&langs=' . $lgparm . '">' ; 
    $ot .= $othash{inf} . '</a></b></p>' . "\n" ;
    
    ##  PRI -- present indicative 
    $ot .= '<div class="row">' . "\n" ; 
    $ot .= '<p style="margin-bottom: 0.5em"><u>' . $tnhash{pri} . '</u></p>' . "\n" ;
    $ot .= '<div class="col-m-6 col-6">' . "\n" ;
    foreach my $person (@people[0..2]) {
	$ot .= '<p class="zero">' ;
	$ot .= $othash{pri}{$person} ; 
	$ot .= '</p>' . "\n" ;
    }
	    $ot .= '</div>' . "\n" ; 
    $ot .= '<div class="col-m-6 col-6">' . "\n" ;
    foreach my $person (@people[3..5]) {
	$ot .= '<p class="zero">' ;
	$ot .= $othash{pri}{$person} ; 
	$ot .= '</p>' . "\n" ; 
    }
    $ot .= '</div>' . "\n" ; 	
    $ot .= '</div>' . "\n" ; 
    
    ##  PIM -- present imperative
    $ot .= '<div class="row">' . "\n" ; 
    $ot .= '<p style="margin-bottom: 0.5em"><u>' . $tnhash{pim} . '</u></p>' . "\n" ;
    $ot .= '<div class="col-m-6 col-6">' . "\n" ;
    $ot .= '<p class="zero">' . '--' . '</p>' . "\n" ;
    $ot .= '<p class="zero">' . $othash{pim}{"ds"} . '</p>' . "\n" ;
    $ot .= '<p class="zero">' . $othash{pim}{"ts"} . '</p>' . "\n" ;
    $ot .= '</div>' . "\n" ; 
    $ot .= '<div class="col-m-6 col-6">' . "\n" ;
    $ot .= '<p class="zero">' . $othash{pim}{"up"} . '</p>' . "\n" ;
    $ot .= '<p class="zero">' . $othash{pim}{"dp"} . '</p>' . "\n" ;
    $ot .= '<p class="zero">' . '--' . '</p>' . "\n" ;
    $ot .= '</div>' . "\n" ; 	
    $ot .= '</div>' . "\n" ; 
    
    ##  PAI -- past ind. (preterite) 
    ##  IMI -- imperfect ind.
    ##  IMS -- imperfect subjunctive
    foreach my $tense ("pai","imi","ims") {
	$ot .= '<div class="row">' . "\n" ; 
	$ot .= '<p style="margin-bottom: 0.5em"><u>' . $tnhash{$tense} . '</u></p>' . "\n" ;
	$ot .= '<div class="col-m-6 col-6">' . "\n" ;
	foreach my $person (@people[0..2]) {
	    $ot .= '<p class="zero">' ;
	    $ot .= $othash{$tense}{$person} ; 
	    $ot .= '</p>' . "\n" ;
	}
	$ot .= '</div>' . "\n" ; 
	$ot .= '<div class="col-m-6 col-6">' . "\n" ;
	foreach my $person (@people[3..5]) {
	    $ot .= '<p class="zero">' ;
	    $ot .= $othash{$tense}{$person} ; 
	    $ot .= '</p>' . "\n" ; 
	}
	$ot .= '</div>' . "\n" ; 	
	$ot .= '</div>' . "\n" ; 
    }
    
    ##  GER -- gerund
    ##  PAP -- past participle
    $ot .= '<div class="row">' . "\n" ; 
    $ot .= '<div class="col-m-6 col-6">' . "\n" ;
    $ot .= '<p style="margin-bottom: 0.5em"><u>' . $tnhash{ger} . '</u></p>' . "\n" ;
    $ot .= '<p class="zero">' ;
    $ot .= $othash{ger} ; 
    $ot .= '</p>' . "\n" ;
    $ot .= '</div>' . "\n" ; 
    $ot .= '<div class="col-m-6 col-6">' . "\n" ;
    $ot .= '<p style="margin-bottom: 0.5em"><u>' . $tnhash{pap} . '</u></p>' . "\n" ;
    $ot .= '<p class="zero">' ;
    $ot .= ( ! defined $vnotes{$palora}{reflex} ) ? "aviri" : "avirisi" ;
    $ot .= " " . $othash{pap} ; 
    $ot .= '</p>' . "\n" ; 
    $ot .= '<p class="zero">' ;
    $ot .= '<i>agg.:</i>  &nbsp; ' . $othash{adj} ; 
    $ot .= '</p>' . "\n" ; 
    $ot .= '</div>' . "\n" ; 	
    $ot .= '</div>' . "\n" ; 

    ##  FTI -- future indicative
    ##  COI -- conditional indicative
    $ot .= '<p><small><i><a href="#fticoi">mustra li àutri tempi</a></i></small></p>' . "\n" ; 
    $ot .= '<div id="fticoi">' . "\n" ; 
    foreach my $tense ("fti","coi") {
	$ot .= '<div class="row">' . "\n" ; 
	$ot .= '<p style="margin-bottom: 0.5em"><u>' . $tnhash{$tense} . '</u></p>' . "\n" ;
	$ot .= '<div class="col-m-6 col-6">' . "\n" ;
	foreach my $person (@people[0..2]) {
	    $ot .= '<p class="zero">' ;
	    $ot .= $othash{$tense}{$person} ; 
	    $ot .= '</p>' . "\n" ;
	}
	$ot .= '</div>' . "\n" ; 
	$ot .= '<div class="col-m-6 col-6">' . "\n" ;
	foreach my $person (@people[3..5]) {
	    $ot .= '<p class="zero">' ;
	    $ot .= $othash{$tense}{$person} ; 
	    $ot .= '</p>' . "\n" ; 
	}
	$ot .= '</div>' . "\n" ; 	
	$ot .= '</div>' . "\n" ; 
    }
    $ot .= '<p><small><i><a href="#closeme">ammucciali</a></i></small></p>' . "\n" ; 
    $ot .= '</div>' . "\n" ; 
    
    ##  close DIV that limits width
    $ot .= '</div>' . "\n" ; 
    return $ot ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

sub mk_tophtml {

    my $topnav = $_[0] ; 

    my $ottxt ;
    $ottxt .= "Content-type: text/html\n\n";
    $ottxt .= '<!DOCTYPE html>' . "\n" ;
    $ottxt .= '<html>' . "\n" ;
    $ottxt .= '  <head>' . "\n" ;
    $ottxt .= '    <title>Cchiù dâ Palora :: Eryk Wdowiak</title>' . "\n" ;
    $ottxt .= '    <meta name="DESCRIPTION" content="annotazzioni a nu dizzionariu sicilianu, annotations to a Sicilian dictionary">' . "\n" ;
    $ottxt .= '    <meta name="KEYWORDS" content="Sicilian, language, dictionary">' . "\n" ;
    $ottxt .= '    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' . "\n" ;
    $ottxt .= '    <meta name="Author" content="Eryk Wdowiak">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk.css">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_theme-bklyn.css">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_widenme.css">' . "\n" ;
    $ottxt .= '    <link rel="icon" type="image/png" href="/config/eryk-icon.png">' . "\n" ;
    $ottxt .= '    <meta name="viewport" content="width=device-width, initial-scale=1">' . "\n" ;

    ##  extra CSS
    $ottxt .= '    <style>' . "\n" ;

    ##  show/hide future and conditional
    $ottxt .= '      #fticoi {  display: none; }' . "\n" ;
    $ottxt .= '      #fticoi:target {  display: block; }' . "\n" ;
    $ottxt .= '      #closeme {  display: none; }' . "\n" ;
    $ottxt .= '      #closeme:target {  display: block; }' . "\n" ;

    ##  zero paragraph spacing
    $ottxt .= '      p.zero { margin-top: 0em; margin-bottom: 0em; }' . "\n" ;

    ##  DIV -- listall
    $ottxt .= '      div.listall { position: relative; margin: auto; width: 90%;}' . "\n" ;

    ##  DIV -- rolldk and rolltb
    $ottxt .= '      @media only screen and (min-width: 836px) { ' . "\n" ;
    $ottxt .= '          div.rolldk {float: left; width: 49%; padding: 0.5%; }' . "\n" ;
    $ottxt .= '      }' . "\n" ;
    $ottxt .= '      @media only screen and (min-width: 500px) { ' . "\n" ;
    $ottxt .= '          div.rolltb {float: left;  width: 49%; padding: 0.5%; }' . "\n" ;
    $ottxt .= '      }' . "\n" ;
    
    ##  DIV -- translations and conjugations
    $ottxt .= '      div.transconj { position: relative; margin: auto; width: 50%;}' . "\n" ;
    $ottxt .= '      @media only screen and (max-width: 835px) { ' . "\n" ;
    $ottxt .= '          div.transconj { position: relative; margin: auto; width: 90%;}' . "\n" ;
    $ottxt .= '      }' . "\n" ;

    ##  DIV -- suggestions
    $ottxt .= '      div.cunzigghiu { position: relative; margin: auto; width: 50%;}' . "\n" ;
    $ottxt .= '      @media only screen and (max-width: 835px) { ' . "\n" ;
    $ottxt .= '          div.cunzigghiu { position: relative; margin: auto; width: 90%;}' . "\n" ;
    $ottxt .= '      }' . "\n" ;

    ##  close CSS -- close head
    $ottxt .= '    </style>' . "\n" ;
    $ottxt .= '  </head>' . "\n" ;

    open( TOPNAV , $topnav ) || die "could not read:  $topnav";
    while(<TOPNAV>){ chomp;  $ottxt .= $_ . "\n" ; };
    close TOPNAV ;

    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    $ottxt .= '    <div class="col-m-12 col-12">' . "\n" ;
    $ottxt .= '      <h1>Cchiù dâ Palora</h1>' . "\n" ;
    $ottxt .= '      <h2>di Eryk Wdowiak</h2>' . "\n" ;
    $ottxt .= '    </div>' . "\n" ;
    $ottxt .= '  </div>' . "\n" ;
    $ottxt .= '  <!-- end row div -->' . "\n" ;
    $ottxt .= '  ' . "\n" ;
    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    
    return $ottxt ;
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

sub mk_foothtm {

    my $footnav = $_[0] ; 

    my $ot ;

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

