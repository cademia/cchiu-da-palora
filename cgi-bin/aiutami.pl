#!/usr/bin/env perl

##  "aiutami.pl" -- solicits information for "Cchiù dâ Palora"
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
no warnings qw( uninitialized );
use CGI qw(:standard);
use Storable qw( retrieve ) ;
{   no warnings;             
    ## $Storable::Deparse = 1;  
    $Storable::Eval    = 1;  
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  PARAMETERS
##  ==========

##  number of pages for vocabulary list
##  should be divisible by four
my $nupages = 76 ; 

##  number of pages for each part of speech
#my $pages_nouns = 24 ; 
#my $pages_adjs  =  8 ; 
#my $pages_verbs =  8 ; 

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  retrieve dieli dictionary
my $dieli_sc = retrieve('../cgi-lib/dieli-sc-dict' );
my %dieli = %{ $dieli_sc } ; 

##  retrieve hashes and subroutines
my $vthash  = retrieve('../cgi-lib/verb-tools' );
my $vbconj  = $vthash->{vbconj} ;
my $vbsubs  = $vthash->{vbsubs} ;
my $nounpls = $vthash->{nounpls} ;

my $vnhash = retrieve('../cgi-lib/vocab-notes' );
my %vnotes = %{ $vnhash } ;

my $cchash = retrieve('../cgi-lib/cchiu-tools' );
my %ccsubs = %{ $cchash->{ccsubs} } ;
my %ddsubs = %{ $cchash->{ddsubs} } ;

my $amhash = retrieve('../cgi-lib/aiutu-tools' );
my %amsubs = %{ $amhash->{amsubs} } ;

my $amlsrf = retrieve('../cgi-lib/aiutu-list' );
my %amlist = %{ $amlsrf } ;

##  output file
#my $otfile = '../cgi-log/aiutami_emw_' . $amsubs{datestamp}() ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  VARIABLES
##  =========

##  what word do we wish to annotate?
my $palora = param('palora'); 

##  which collection are we looking for?
my $coll =  param('coll');

##  annotating -- auto mode vs. word by word
##  possible values -- "auto","alfa_p02"
my $lastauto = param('lastauto') ;

##  capture card values
my $cagna  = param('cagna'); 
my $chista = param('chista_carta_e');


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CREATE  WEBPAGE
##  ======  =======

##  open webpage
print $amsubs{mk_amtophtml}("../config/topnav.html");

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  cases:
##    *  first arrive or browsing words
##    *  submission good
##    *  submission fail -- send them back
##    *  annotating -- auto mode vs. word by word
##

if ( ! defined $cagna && ! defined $chista && ! defined $palora && ! defined $lastauto && ! defined $coll ) {
    ##  case where user first arrives
    ##     * no "cagna" or "chista", therefore no form submitted
    ##     * no "palora" defined, so not annotating (and no form submitted)
    ##     * not in auto-mode
    ##     * no "collection" defined


    ##  landing page with alphabetical list of lists
    print $amsubs{make_welcome_msg}();
    print $amsubs{make_alfa_welcome}( $amlsrf , \%amsubs , $vbsubs, $nupages );
   

} elsif (  ! defined $cagna && ! defined $chista && ! defined $palora && ! defined $lastauto && defined $coll ) {
    ##  case where user wants to browse a collection
    ##     * no "cagna" or "chista", therefore no form submitted
    ##     * no "palora" defined, so not annotating (and no form submitted)
    ##     * not in auto-mode
    ##     * "collection" is defined
    ##  
    ##  note:  either arriving from the home page or from previous word

    ##  browsing words one page of collection     
    print $amsubs{make_alfa_coll}( $coll , $amlsrf , \%amsubs , $vbsubs , $lastauto , $nupages );


} elsif (  ! defined $cagna && ! defined $chista && ( defined $palora || $lastauto eq "auto" ) ) {
    ##  case where user wants to annotate "palora"
    ##     * no "cagna" or "chista", therefore no form submitted
    ##     * "collection" is ambiguous, but already handled above
    ##     * "palora" is defined or in "auto-mode"
    ##  therefore must want to annotate "palora" or in "auto-mode"

    
    ##  if in auto-mode, then generate $palora at random
    ##  NB:  making $palora local here !!
    my $palora = ( $lastauto eq "auto" ) ? $amsubs{get_random_word}($amlsrf) : $palora ;
    my $askORthank = "askhelp" ;
    print make_tests( $palora , $askORthank , $lastauto ) ;


} elsif ( defined $chista && ( ! defined $palora || ($amsubs{decode_carta}($cagna) ne $chista) ) ) {
    ##  case where user submitted an annotation
    ##  input NOT VALID --> fail
    ##     *  "chista" defined, but either:
    ##            >   "cagna" and "chista" do not match  OR
    ##            >   "palora" not defined  (we need "palora" to annotate)
    ##     *  "collection" is ambiguous, but already handled above

    ## $cagna = $amsubs{decode_carta}($cagna);     
    ## print '<p>test failed</p>' . "\n";
    ## print '<p>cagna: '. $cagna .' --  chista: '. $chista .'</p>' . "\n";
    
    ##  the question now is:  did they just hit "spidiscimi", meaning "go to next"
    ##  or did they submit garbage?  or worse, did they submit malicious code?

    ##  what information have we collected?
    my $adj_FEMSI  = param('adj_FEMSI');
    my $noun_PLEND = param('noun_PLEND');
    my $vb_PRI     = param('vb_PRI');
    my $vb_PAI     = param('vb_PAI');
    my $vb_PAP     = param('vb_PAP');
    my $vb_ADJ     = param('vb_ADJ');

    my $poetry     = param('poetry');
    $poetry  = ( ! defined $poetry || $poetry eq 'Raccuntami puisia!' ) ? undef : $poetry ;

    ##  if they are all undefined, then assume that user wishes to skip
    ##    1.   if ( ! defined $lastauto ) send them back home -- should not occur!
    ##    2.  if ($lastauto eq "auto") select new word
    ##    3.  if "lastauto" is a collection name, then send them back to that collection
    ##    4.  if "lastauto" is not a collection name, send them home
    ##  otherwise send them back to the word they were annotating

    if ( ! defined $adj_FEMSI  && 
	 ! defined $noun_PLEND && 
	 ! defined $vb_PRI && ! defined $vb_PAI && ! defined $vb_PAP && ! defined $vb_ADJ && 
	 ! defined $poetry ) {

	##  SKIP  CASES	
	if ( ! defined $lastauto && ! defined $palora ) { 
	    ##  SKIP  #1  -- "lastauto" not defined
	    ##  send them back home -- should not occur!
	    print $amsubs{make_welcome_msg}();
	    print $amsubs{make_alfa_welcome}( $amlsrf , \%amsubs , $vbsubs, $nupages );

	} elsif ( $lastauto eq "auto" ) {
	    ##  SKIP  #2  -- automode
	    my $palora = $amsubs{get_random_word}($amlsrf) ;	    
	    my $askORthank = "askhelp" ;
	    print make_tests( $palora , $askORthank , $lastauto ) ;

	} elsif ( $lastauto =~ /^alfa_p[0-9][0-9]$/ ) {
	    ##  SKIP  #3  -- go back to collection 
	    ##  note first and fifth arguments passed are "lastauto"
	    print $amsubs{make_alfa_coll}( $lastauto , $amlsrf , \%amsubs , $vbsubs , $lastauto , $nupages );
	    
	} else {
	    ##  SKIP  #4  -- "lastauto" is not a collection name
	    ##  send them back home -- should not occur!
	    print $amsubs{make_welcome_msg}();
	    print $amsubs{make_alfa_welcome}( $amlsrf , \%amsubs , $vbsubs, $nupages );
	}

    } else {
	##  RETURN    -- return to word annotating
	##  send them back to the word that they were annotating
	## 
	##  just in case "palora" is not defined, select word at random -- should not occur
	my $palora = ( ! defined  $palora ) ? $amsubs{get_random_word}($amlsrf) : $palora ;
	my $askORthank = "askhelp" ;
	print make_tests( $palora , $askORthank , $lastauto ) ;
    }


} elsif ( defined $palora && defined $cagna && defined $chista && $amsubs{decode_carta}($cagna) eq $chista ) {
    ##  case where user submitted an annotation
    ##  input VALID --> success
    ##     *  "cagna" and "chista" defined
    ##     *  "palora" is defined
    ##     *  "collection" is ambiguous, but already handled above

    ##  
    ##  must validate the input, then use "collection" to decide 
    ##  if the user is returned to the lists or to a randomly chosen next word

    ##  first validate input -- only check is the card game
    ##     *  maybe we can play a "wing-T" formation?  
    ##     *  just let 'em through and delete the bad submissions later?
    ##     *  either way, this is going to be messy

    ##  
    ##  ##   CODE  TO  STORE  DATA  HERE
    ##  
    

    ##  where to now?  back to list or to next word?
    ##     *  if arrived from browsing a collection, then send them back to that list
    ##     *  if arrived from the home page, then send them a random next word ("auto mode")
    
    if ( ! defined $coll && ( ! defined $lastauto || $lastauto eq "auto" || $lastauto !~ /^alfa_p[0-9][0-9]$/ ) ) {

	##  send them new word -- AUTO MODE
	my $palora = $amsubs{get_random_word}($amlsrf) ;	    
	my $askORthank = "thankyou" ;
	print make_tests( $palora , $askORthank , $lastauto ) ;

    } else {	
	##  we can do this because of the way the IF-ELSE command is defined 
	my $coll = ( ! defined $coll ) ? $lastauto : $coll ;
	
	##  say thank you
	my $thanks ;
	$thanks .= '<p style="margin-top: 0em; margin-bottom: 1em; text-align: center;">' ;
	$thanks .= '<b><i><span class="lightcolor">Grazzii pi l' . "'" . 'aiutu!</span></i></b></p>' . "\n" ; 
	print $thanks ; 

	##  send them back to the list where they came from	
	##  browsing words one page of collection
	print $amsubs{make_alfa_coll}( $coll , $amlsrf , \%amsubs , $vbsubs , $lastauto , $nupages );
    }

} else {
    ##  reaching this point should not be possible
    ##  print '<p>welcome back my friends<br>to the show that never ends,<br>step inside, step inside</p>' . "\n";

    ##  send them back home
    ##  landing page with alphabetical list of lists
    print $amsubs{make_welcome_msg}();
    print $amsubs{make_alfa_welcome}( $amlsrf , \%amsubs , $vbsubs, $nupages );
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  close webpage
print $ddsubs{mk_foothtml}("../config/navbar-footer.html");

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
## #  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## 

##  SUBROUTINES
##  ===========

sub make_tests {

    ##  only arguments, everything else is globals
    my $palora     = $_[0] ;
    my $askORthank = $_[1] ;
    my $lastauto   = $_[2] ;
   
    ##  prepare html
    my $othtml ;
    
    $othtml .= $amsubs{make_form_top}();
    $othtml .= $amsubs{offer_translation}( $palora , $amlsrf , \%amsubs , $vbsubs , $askORthank );
    
    ##  collect information about grammar 
    ##  single words only
    if ( ! defined $amlist{$palora}{part_speech} || ! defined $amlist{$palora}{palora} ) {
	my $blah = "no grammar to ask about" ;
    } elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "verb" && $amlist{$palora}{palora} =~ /^[a-zàèìòù]+$/i) {
	$othtml .= $amsubs{test_verb}( $palora , $amlsrf , \%amsubs , $vbsubs , $vbconj );
	
    } elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "noun" && $amlist{$palora}{palora} =~ /^[a-zàèìòù]+$/i) {
	$othtml .= $amsubs{test_noun}( $palora , $amlsrf , $nounpls , $vbsubs );
	
    } elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "adj"  && $amlist{$palora}{palora} =~ /^[a-zàèìòù]+$/i) {
	$othtml .= $amsubs{test_adj}( $palora ,  $amlsrf , $vbsubs , \%amsubs ) ; 
    }	
    ##  collect poetry and close
    $othtml .= $amsubs{make_poetry}() ;	
    $othtml .= $amsubs{make_namefield}();
    $othtml .= $amsubs{deal_cards}( \%amsubs , $palora , $lastauto );
    $othtml .= $amsubs{make_form_bottom}();
 
    ##  return the html
    return $othtml ;
}
