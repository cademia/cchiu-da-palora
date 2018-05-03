#!/usr/bin/perl -T

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
    print $amsubs{offer_translation}( $palora , $amlsrf , \%amsubs , "askhelp");

    ##  collect information about grammar 
    ##  single words only
    if ( ! defined $amlist{$palora}{part_speech} || ! defined $amlist{$palora}{palora} ) {
	my $blah = "no grammar to ask about" ;
    } elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "verb" && $amlist{$palora}{palora} =~ /^[a-z]+$/) {
	print $amsubs{test_verb}( $palora , $amlsrf , \%amsubs , $vbsubs , $vbconj );

    } elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "noun" && $amlist{$palora}{palora} =~ /^[a-z]+$/) {
	print $amsubs{test_noun}( $palora , $amlsrf , $nounpls , $vbsubs );

    } elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "adj"  && $amlist{$palora}{palora} =~ /^[a-z]+$/) {
	print $amsubs{test_adj}( $palora ,  $amlsrf , $vbsubs , \%amsubs ) ; 
    }
    ##  collect poetry and close
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
    print $amsubs{offer_translation}( $palora , $amlsrf , \%amsubs , "askhelp");

    ##  must REPOPULATE the form !!
    ##  collect information about grammar 
    ##  single words only
    if ( ! defined $amlist{$palora}{part_speech} || ! defined $amlist{$palora}{palora} ) {
	my $blah = "no grammar to ask about" ;
    } elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "verb" && $amlist{$palora}{palora} =~ /^[a-z]+$/) {
	print $amsubs{test_verb}( $palora , $amlsrf , \%amsubs , $vbsubs , $vbconj );

    } elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "noun" && $amlist{$palora}{palora} =~ /^[a-z]+$/) {
	print $amsubs{test_noun}( $palora , $amlsrf , $nounpls , $vbsubs );

    } elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "adj"  && $amlist{$palora}{palora} =~ /^[a-z]+$/) {
	print $amsubs{test_adj}( $palora ,  $amlsrf , $vbsubs , \%amsubs ) ; 
    }
    ##  collect poetry and close
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
	print $amsubs{offer_translation}( $palora , $amlsrf , \%amsubs , "thankyou");
	
	##  collect information about grammar 
	##  single words only
	if ( ! defined $amlist{$palora}{part_speech} || ! defined $amlist{$palora}{palora} ) {
	    my $blah = "no grammar to ask about" ;
	} elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "verb" && $amlist{$palora}{palora} =~ /^[a-z]+$/) {
	    print $amsubs{test_verb}( $palora , $amlsrf , \%amsubs , $vbsubs , $vbconj );

	} elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "noun" && $amlist{$palora}{palora} =~ /^[a-z]+$/) {
	    print $amsubs{test_noun}( $palora , $amlsrf , $nounpls , $vbsubs );
	    
	} elsif ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} eq "adj"  && $amlist{$palora}{palora} =~ /^[a-z]+$/) {
	    print $amsubs{test_adj}( $palora ,  $amlsrf , $vbsubs , \%amsubs ) ; 
	}	
	##  collect poetry and close
	print $amsubs{make_poetry}() ;	
	print $amsubs{make_namefield}();
	print $amsubs{deal_cards}( \%amsubs , $palora , $lastauto );
	print $amsubs{make_form_bottom}();
	
    } else {
	##  send them back to the list where they came from
	
	## print '<p>welcome back to the collection</p>' . "\n";

	##  browsing words one page of collection     
	print $amsubs{make_alfa_coll}( $coll , $amlsrf , \%amsubs , $vbsubs , $lastauto , $nupages );
    }

} else {
    ##  reaching this point should not be possible
    ##  send them back home

    ## print '<p>welcome back my friends<br>to the show that never ends,<br>step inside, step inside</p>' . "\n";

    ##  landing page with alphabetical list of lists
    print $amsubs{make_alfa_welcome}( $amlsrf , \%amsubs , $vbsubs, $nupages );

}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  close webpage
print $ddsubs{mk_foothtml}("../config/navbar-footer.html");

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
## #  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## 
