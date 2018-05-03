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
my $nupages = 48 ; 

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
#my %amlist = %{ $amlsrf } ;

##  output file
my $otfile = '../cgi-log/aiutami_emw_' . $amsubs{datestamp}() ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  VARIABLES
##  =========

##  what information have we collected?
my $poetry = param('poetry'); 

##  what word do we wish to annotate?
my $palora = param('palora'); 
my $lgparm = "SCEN" ;

##  which collection are we looking for?
my $coll =  param('coll');

##  annotating -- auto mode vs. word by word
##  possible values -- "home","auto","alfa_p02"
my $lastauto = param('lastauto') ;
$lastauto = ( ! defined $lastauto && ! defined $coll ) ? "home" : $lastauto ;

#if ( ! defined $lastauto && ! defined $coll ) { 
#    $lastauto = "home" ;
#} elsif ( ! defined $coll ) { 
#    ##  case where "lastauto" is defined
#    ##  so leave it alone
#} else {
#    ##  "lastauto" is not defined, but "coll" is
#    $lastauto = $coll ;
#}


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

if ( ! defined $cagna && ! defined $chista && ! defined $palora && ! defined $coll) {
    ##  case where user first arrives
    ##     * no "cagna" or "chista", therefore no form submitted
    ##     * no "palora" defined, so not annotating (and no form submitted)
    ##     * no "collection" defined

    print '<p>welcome</p>' . "\n";

    ##  landing page with alphabetical list of lists
    print $amsubs{make_alfa_welcome}( $amlsrf , \%amsubs , $vbsubs, $nupages );


} elsif (  ! defined $cagna && ! defined $chista && ! defined $palora && defined $coll ) {
    ##  case where user wants to browse a collection
    ##     * no "cagna" or "chista", therefore no form submitted
    ##     * no "palora" defined, so not annotating (and no form submitted)
    ##     * "collection" is defined
    ##  
    ##  note:  either arriving from the home page or from previous word

    print '<p>welcome to the collection</p>' . "\n";

    ##  browsing words one page of collection     
    print $amsubs{make_alfa_coll}( $coll , $amlsrf , \%amsubs , $vbsubs , $lastauto , $nupages );


} elsif (  ! defined $cagna && ! defined $chista && defined $palora ) {
    ##  case where user wants to annotate "palora"
    ##     * no "cagna" or "chista", therefore no form submitted
    ##     * "collection" is ambiguous, but already handled above
    ##     * "palora" is defined
    ##  therefore must want to annotate "palora"

    ##  make new form
    print $amsubs{make_form_top}();

    ##  MUST keep "ask_help" and "offer_translation" together!!
    print $amsubs{ask_help}();
    print $amsubs{offer_translation}( $palora , $amlsrf , \%amsubs );
    ##  MUST keep "ask_help" and "offer_translation" together!!

    ##  collect information about the word
    print $amsubs{test_verb}( $palora , $amlsrf , \%amsubs , $vbsubs , $vbconj );
    print $amsubs{make_poetry}() ;

    print $amsubs{make_namefield}();
    print $amsubs{deal_cards}( \%amsubs , $palora , $lastauto );
    print $amsubs{make_form_bottom}();


} elsif ( defined $chista && ( ! defined $palora || ($amsubs{decode_carta}($cagna) ne $chista) ) ) {
    ##  case where user submitted an annotation
    ##  input NOT VALID --> fail
    ##     *  "chista" defined, but either:
    ##            >   "cagna" and "chista" do not match  OR
    ##            >   "palora" not defined  (we need "palora" to annotate)
    ##     *  "collection" is ambiguous, but already handled above

    $cagna = $amsubs{decode_carta}($cagna); 
    
    print '<p>test failed</p>' . "\n";
    print '<p>cagna: '. $cagna .' --  chista: '. $chista .'</p>' . "\n";


    ##  return them to the word that they were annotating
    print $amsubs{make_form_top}();

    ##  MUST keep "ask_help" and "offer_translation" together!!
    print $amsubs{ask_help}();
    print $amsubs{offer_translation}( $palora , $amlsrf , \%amsubs );
    ##  MUST keep "ask_help" and "offer_translation" together!!

    ##  must REPOPULATE the form !!
    print $amsubs{test_verb}( $palora , $amlsrf , \%amsubs , $vbsubs , $vbconj );
    print $amsubs{make_poetry}() ;

    print $amsubs{make_namefield}();
    print $amsubs{deal_cards}( \%amsubs , $palora , $lastauto );
    print $amsubs{make_form_bottom}();



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
    ##     *  just like the "wing-T" formation:  "Let 'em through!"
    ##     *  we can delete bad submissions later
    ##     *  but this is going to be messy!
    ##  store data in storable

    ##  where to now?  back to list or to next word?
    ##     *  if arrived from browsing a collection, then send them back to that list
    ##     *  if arrived from the home page, then send them a random next word ("auto mode")
    if ( ! defined $coll ) {

	##  send them new word -- AUTO MODE
	print $amsubs{make_form_top}();
	
	##  MUST keep "thank_you" and "offer_translation" together!!
	print $amsubs{thank_you}();
	print $amsubs{offer_translation}( $palora , $amlsrf , \%amsubs );
	##  MUST keep "thank_you" and "offer_translation" together!!
	
	##  collect information about the word
	print $amsubs{test_verb}( $palora , $amlsrf , \%amsubs , $vbsubs , $vbconj );
	print $amsubs{make_poetry}() ;
	
	print $amsubs{make_namefield}();
	print $amsubs{deal_cards}( \%amsubs , $palora , $lastauto );
	print $amsubs{make_form_bottom}();
	
    } else {
	##  send them back to the list where they came from
	
	print '<p>welcome back to the collection</p>' . "\n";

	##  browsing words one page of collection     
	print $amsubs{make_alfa_coll}( $coll , $amlsrf , \%amsubs , $vbsubs , $lastauto , $nupages );
    }

} else {
    ##  reaching this point should not be possible
    ##  send them back home

    print '<p>welcome back my friends<br>to the show that never ends,<br>step inside, step inside</p>' . "\n";

    ##  landing page with alphabetical list of lists
    print $amsubs{make_alfa_welcome}( $amlsrf , \%amsubs , $vbsubs, $nupages );

}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  close webpage
print $ddsubs{mk_foothtml}("../config/navbar-footer.html");

##  WEBPAGE  CREATED !!
##  =======  ======= ==


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
   ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========





##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  




##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  READY TO GO
##  ===== == ==



##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SCRAPS FOR LATER
##  ====== === =====

sub pos_tests {

    my $othtml ; 
    
    ##  print translations and notes
    #print $ccsubs{mk_dielitrans}( $palora , $lgparm , \%vnotes , $vbconj , $vbsubs ) ;
    #print $ccsubs{mk_notex}( $palora , \%vnotes , \%ccsubs ) ;

    ##  are we working with a verb, noun or adjective?
    my $isverb = ( ! defined $vnotes{ $palora }{verb}     && 
		   ! defined $vnotes{ $palora }{reflex}   && 
		   ! defined $vnotes{ $palora }{prepend}            ) ? "false" : "true" ;
    my $isnoun = ( ! defined $vnotes{ $palora }{noun}               ) ? "false" : "true" ;
    my $isadj  = ( $vnotes{ $palora }{part_speech} ne "adj" ) ? "false" : "true" ;
    
    ##  "other" parts of speech currently include:  {adv} {prep} {pron}
     my $isother  = ( ! defined $vnotes{ $palora }{part_speech} ) ? "false" : "true" ;
    
    if ( $isverb eq "true" ) {
	#print $ccsubs{mk_conjhtml}( $palora , $lgparm , \%vnotes , $vbconj , $vbsubs ) ;
	
    } elsif ( $isnoun eq "true" ) {
	#print $ccsubs{mk_nounhtml}( $palora , $lgparm , \%vnotes , $nounpls , $vbsubs ) ;
	
    } elsif ( $isadj  eq "true" ) {
	#print $ccsubs{mk_adjhtml}( $palora , $lgparm , \%vnotes , $vbsubs ) ;
	
    } elsif ( $isother  eq "true" ) {
	my $blah = "do nothing here.  we just want to avoid error message below." ; 
	
    } else {
	##  outer DIV to limit width
	my $othtml ; 
	$othtml .= '<div class="transconj">' . "\n" ; 
	$othtml .= '<div class="row">' . "\n" ; 
	$othtml .= '<p>' . "nun c'è" . ' na annotazzioni dâ palora: &nbsp; <b>' . $palora . '</b></p>' . "\n" ;
	$othtml .= '</div>' . "\n" ; 
	$othtml .= '</div>' . "\n" ; 
	#print $othtml ; 
	#print $ccsubs{mk_showall}(  \%vnotes , $vbconj , $vbsubs , $adjustone , $adjusttwo , $adjusttre ) ;
     }

    return $othtml ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
## #  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## 

##  ##  aiutami tools
##  my $amhash = retrieve('../cgi-lib/aiutu-tools' );
##  my %amsubs = %{ $amhash->{amsubs} } ;
##  
##  $amsubs{datestamp}         ;
##  $amsubs{timestamp}         ;
##  
##  $amsubs{play_cards}        ;
##  $amsubs{deal_cards}        ;
##  $amsubs{encode_carta}      ;
##  $amsubs{decode_carta}      ;
##  
##  $amsubs{mk_amtophtml}      ;
##  $amsubs{thank_you}         ;
##  $amsubs{make_namefield}    ;
##  $amsubs{make_form_top}     ;
##  $amsubs{make_form_bottom}  ;
##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  
##  ##  vocabulary tools
##  my $vthash  = retrieve('../cgi-lib/verb-tools' );
##  my $vbconj  = $vthash->{vbconj} ;
##  my $vbsubs  = $vthash->{vbsubs} ;
##  my $nounpls = $vthash->{nounpls} ;
##  
##  ##  vocabulary notes
##  my $vnhash = retrieve('../cgi-lib/vocab-notes' );
##  my %vnotes = %{ $vnhash } ;
##  
##  ##  verb conjugation subroutines
##  $vbsubs{mk_forms}       ;
##  $vbsubs{conjugate}      ;
##  $vbsubs{conjreflex}     ;
##  $vbsubs{conjnonreflex}  ;
##  $vbsubs{rid_accents}    ;
##  ##$vbsubs{rid_penult_accent}; ## experimental
##  
##  ##  noun and adjective subroutines
##  $vbsubs{mk_adjectives}  ;
##  $vbsubs{mk_noun_plural} ;
##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  
##  ##  "cchiu-da-palora" and "dieli dictionary"
##  my $cchash = retrieve('../cgi-lib/cchiu-tools' );
##  my %ccsubs = %{ $cchash->{ccsubs} } ;
##  my %ddsubs = %{ $cchash->{ddsubs} } ;
##  
##  $ccsubs{mk_nounhtml}    ;	   ##  $ddsubs{uniq}         ;	 
##  $ccsubs{mk_adjhtml}     ;	   ##  $ddsubs{mk_search}    ;	 
##  $ccsubs{mk_conjhtml}    ;	   ##  $ddsubs{translate}    ;	 
##  				   ##  				 
##  $ccsubs{mk_dielitrans}  ; 	   ##  $ddsubs{mk_ddtophtml} ;	 
##  $ccsubs{mk_notex}       ;	   ##  $ddsubs{mk_newform}   ;	 
##  $ccsubs{mk_notex_list}  ;	   ##  				 
##  				   ##  $ddsubs{thank_dieli}  ;	 
##  $ccsubs{mk_showall}     ; 	   ##  $ddsubs{mk_foothtml}  ;      
##  $ccsubs{mk_vnkcontent}  ;
##  
##  $ccsubs{mk_cctophtml}   ;
##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  À à  Â â
##  È è  Ê ê
##  Ì ì  Î î
##  Ò ò  Ô ô
##  Ù ù  Û û

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
