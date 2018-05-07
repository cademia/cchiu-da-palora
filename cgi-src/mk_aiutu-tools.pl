#!/usr/bin/env perl

##  "mk_aiutu-tools.pl" -- makes tools for web interface to "Aiùtami!"
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

use strict;
use warnings;
use Storable qw( nstore ) ;
{   no warnings;             
    $Storable::Deparse = 1;  
    ## $Storable::Eval    = 1;  
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

my $otfile = '../cgi-lib/aiutu-tools' ; 

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES  for  AIUTAMI
##  ===========  ===  =======

##  make time and date stamps
sub datestamp {
    my($mday, $month, $year)=(localtime)[3,4,5]; 
    $year += 1900 ; 
    $month = sprintf( "%02d" , $month + 1) ;
    $mday = sprintf( "%02d" , $mday ) ;
    my $ot = $year . "-" . $month . "-" . $mday ;
    return $ot ;
}

sub timestamp {
    my($sec, $min, $hour)=(localtime)[0,1,2]; 
    $hour = sprintf( "%02d" , $hour ) ;
    $min  = sprintf( "%02d" , $min  ) ;
    $sec  = sprintf( "%02d" , $sec  ) ;
    my $ot = $hour . "-" . $min . "-" . $sec ;
    return $ot ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make link with part of speech
sub make_link {
    
    my $palora   = $_[0] ; ##  hash key
    my $display  = $_[1] ; ##  what to display
    my $lastauto = $_[2] ; ##  "home","auto","verbs_p02"
    my $partsp   = $_[3] ; ##  part of speech

    ##  "At least make it look Sicilian!"
    $partsp =~ s/^verb$/verbu/ ;
    $partsp =~ s/^noun$/sust./ ;
    $partsp =~ s/^adj$/agg./ ;
    $partsp =~ s/^adv$/avv./ ;
    $partsp =~ s/^prep$/prip./ ;
    $partsp =~ s/^pron$/prun./ ;

    ##  replace squote
    $display =~ s/_SQUOTE_/'/g;
    
    ##  link with part of speech
    my $othtml ;
    $othtml .= '<a href="/cgi-bin/aiutami.pl?';
    $othtml .= 'palora=' . $palora ;
    $othtml .= '&lastauto=' . $lastauto ;
    $othtml .= '">' . $display  ; 
    $othtml .= '</a> <small>{'. $partsp .'}</small>' . "\n" ;
    
    return $othtml ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##


##  for welcome page -- make list of lists of words 
sub make_alfa_index {

    ##  list of words and list of subs
    my %amlist     = %{ $_[0] } ; 
    my %amsubs     = %{ $_[1] } ; 
    my %vbsubs     = %{ $_[2] } ; 
    my $nupages    =    $_[3]   ; ## NUmber of pages -- divisible by four

    ##  get sorted list of keys
    my $rid_all_accents = sub {	
	##  grave accents
	my $rid = $vbsubs{rid_accents}( $_[0] ) ; 
	##  circumflex_accents
	$rid =~ s/\303\242/a/g; 
	$rid =~ s/\303\252/e/g; 
	$rid =~ s/\303\256/i/g; 
	$rid =~ s/\303\264/o/g; 
	$rid =~ s/\303\273/u/g; 
	$rid =~ s/\303\202/A/g; 
	$rid =~ s/\303\212/E/g; 
	$rid =~ s/\303\216/I/g; 
	$rid =~ s/\303\224/O/g; 
	$rid =~ s/\303\233/U/g; 
	##  replace squote
	$rid =~ s/_SQUOTE_/'/g;
	return $rid ;
    };
    
    my @amkeys = sort { lc(&{$rid_all_accents}($a)) cmp lc(&{$rid_all_accents}($b)) } keys %amlist ;

    ##  calculate keys per page
    my $keysperpage = int( $#amkeys / $nupages ) + 1 ; 

    ##  output to a hash with array of keys and with scalar of html
    my %othash ;

    for my $i (0..$nupages-1) {

	##  index where we start and end
	my $bgn = $i * $keysperpage ;
	my $end = $bgn + $keysperpage - 1 ; 
	if ( $end > $#amkeys ) { 
	    $end = $#amkeys ; 
	}
	
	##  get the first and last hash keys on this page
	my $first = lc( &{$rid_all_accents}($amkeys[$bgn]) );
	my $last  = lc( &{$rid_all_accents}($amkeys[$end]) );
	
	##  just give me the first four characters
	$first = substr( $first , 0 , 4 ) ; 
	$last  = substr( $last  , 0 , 4 ) ; 

	##  index info
	my $pagenum = sprintf( "%02d" , $i ) ; 
	my $collname = 'alfa_p'. $pagenum ; 
	my $title = $first . ' &ndash; '  . $last ; 
	
	my $othtml ;
	$othtml .= '<p style="text-align: center; margin-top: 0.1em; margin-bottom: 0.1em;">' ; 
	$othtml .= '<a href="/cgi-bin/aiutami.pl?coll=' . $collname .'">' ; 
	$othtml .= $title . '</a></p>' . "\n" ; 

	##  send it to the hash
	@{$othash{$collname}{listkeys}} = @amkeys[$bgn..$end] ;
	$othash{$collname}{html}        = $othtml  ;
	$othash{$collname}{title}       = $title   ;
	$othash{$collname}{pagenum}     = $pagenum ;
    }
    ##  return the othash
    return %othash ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  for welcome page -- make html for list of lists on landing page
sub make_alfa_welcome {

    ##  list of words and list of subs
    my $amlsrf     =    $_[0]   ; 
    my %amsubs     = %{ $_[1] } ; 
    my $vbsubs_ref =    $_[2]   ; 
    my $nupages    =    $_[3]   ; ## NUmber of pages -- divisible by four

    ##  make the lists
    my %lists = $amsubs{make_alfa_index}( $amlsrf , \%amsubs , $vbsubs_ref , $nupages ) ;

    ##  divide them into columns
    my @collkeys = sort( keys %lists ); 
    my $nupercol = int(($#collkeys + 1)/4);
    
    ## output to html
    my $othtml ;
    $othtml .= '<div><h3 style="margin-top: 0em;">Dizziunariu di Dieli</h3></div>' . "\n" ; 

    $othtml .= '<div class="listall">' . "\n" ; 
    $othtml .= '<div class="row">' . "\n" ; 

    $othtml .= '<div class="rolltb">' . "\n" ; 
    $othtml .= '<div class="rolldk">' . "\n" ; 
    { 	my $colnum = 0 ;
	my $bgn = $colnum * $nupercol ;
	my $end = $bgn + $nupercol - 1 ;
	for my $i ($bgn..$end) {
	    $othtml .= $lists{$collkeys[$i]}{html} ; 
	}
    }
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '<div class="rolldk">' . "\n" ; 
    { 	my $colnum = 1 ;
	my $bgn = $colnum * $nupercol ;
	my $end = $bgn + $nupercol - 1 ;
	for my $i ($bgn..$end) {
	    $othtml .= $lists{$collkeys[$i]}{html} ; 
	}
    }
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 

    $othtml .= '<div class="rolltb">' . "\n" ; 
    $othtml .= '<div class="rolldk">' . "\n" ; 
    { 	my $colnum = 2 ;
	my $bgn = $colnum * $nupercol ;
	my $end = $bgn + $nupercol - 1 ;
	for my $i ($bgn..$end) {
	    $othtml .= $lists{$collkeys[$i]}{html} ; 
	}
    }
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '<div class="rolldk">' . "\n" ; 
    { 	my $colnum = 3 ;
	my $bgn = $colnum * $nupercol ;
	my $end = $#collkeys ;
	for my $i ($bgn..$end) {
	    $othtml .= $lists{$collkeys[$i]}{html} ; 
	}
    }
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 

    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    
    $othtml .= '<p style="margin-bottom: 0.5em; text-align: center;">Grazii a'."\n";
    $othtml .= '  <a href="http://www.dieli.net/" target="_blank">Arthur Dieli</a>'."\n";
    $othtml .= '  pi cumpilari stu dizziunariu.</p>'."\n";

    return $othtml ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make one page of an alphabetical collection
sub make_alfa_coll {
    
    my $coll   =    $_[0]   ;
    my $amlsrf =    $_[1]   ;
    my %amsubs = %{ $_[2] } ;  
    my %vbsubs = %{ $_[3] } ;  
    my $lastauto =  $_[4]   ;  $lastauto = ( ! defined $lastauto || $lastauto eq "home" ) ? $coll : $lastauto ;
    my $nupages  =  $_[5]   ;
    

    ##  make the lists
    my %lists = $amsubs{make_alfa_index}( $amlsrf , \%amsubs , \%vbsubs , $nupages ) ;
    
    ##  get sorted list of keys
    my $rid_all_accents = sub {	
	my $rid = $vbsubs{rid_accents}( $_[0] ) ; 
	$rid =~ s/\303\242/a/g; 
	$rid =~ s/\303\252/e/g; 
	$rid =~ s/\303\256/i/g; 
	$rid =~ s/\303\264/o/g; 
	$rid =~ s/\303\273/u/g; 
	$rid =~ s/\303\202/A/g; 
	$rid =~ s/\303\212/E/g; 
	$rid =~ s/\303\216/I/g; 
	$rid =~ s/\303\224/O/g; 
	$rid =~ s/\303\233/U/g; 
	##  replace squote
	$rid =~ s/_SQUOTE_/'/g;
	return $rid ;
    };

    ##  let's split the print over four columns
    ##  keep words together by first two letters
    my @amkeys = sort( {lc(&{$rid_all_accents}($a)) cmp lc(&{$rid_all_accents}($b))} @{$lists{$coll}{listkeys}});
    my $amkqtr = int( $#amkeys / 4 ) ; 
    
    ##  first column
    my $amstart = 0 ; 
    my $amkidx = $amkqtr ; 
    my @amkone = @amkeys[$amstart..$amkidx] ; 

    ##  second column
    $amstart = $amkidx+1 ; 
    $amkidx += $amkqtr ; 
    my @amktwo = @amkeys[$amstart..$amkidx] ; 

    ##  third column
    $amstart = $amkidx+1 ; 
    $amkidx += $amkqtr ; 
    my @amktre = @amkeys[$amstart..$amkidx] ; 
    
    ##  fourth column
    $amstart = $amkidx+1 ; 
    my @amkqtt = @amkeys[$amstart..$#amkeys] ; 
      
    ##  create navigation tools
    ( my $prev_page  =  $coll ) =~ s/alfa_p//  ;                     ##  subtract nothing
    ( my $next_page  =  $coll ) =~ s/alfa_p//  ;  $next_page +=  1 ; ##  add one 
    $prev_page = ( $prev_page eq "00" ) ? undef : 'alfa_p' . sprintf( "%02d" , $prev_page - 1 ); ##  subtract one
    $next_page = ( $next_page eq $nupages ) ? undef : 'alfa_p' . sprintf( "%02d" , $next_page ); ##  add nothing

    ##  create navigation
    my $navigation ;
    $navigation .= '  <!-- begin row div -->' . "\n";
    $navigation .= '  <div class="row">' . "\n";
    $navigation .= "\n";
    $navigation .= '    <div class="col-4 col-m-4 vanish">' . "\n";
    if ( ! defined $prev_page ) { my $blah = "do nothing"; } else { 
	my $prev_title = $lists{$prev_page}{title} ;
	$navigation .= '<p class="zero" style="text-align: left;">&lt;&lt;&nbsp;' ;
	$navigation .= '<a href="/cgi-bin/aiutami.pl?coll=' . $prev_page . '">' . $prev_title . '</a>'; 
	$navigation .= '</p>' . "\n";
    }
    $navigation .= '    </div>' . "\n";
    $navigation .= "\n";
    $navigation .= '    <div class="col-4 col-m-4 vanish">' . "\n";
    $navigation .= '      <p class="zero" style="text-align: center;">' . "\n";
    $navigation .= '	    <a href="/cgi-bin/aiutami.pl">ìnnici</a>' . "\n";
    $navigation .= '      </p>' . "\n";
    $navigation .= '    </div>' . "\n";
    $navigation .= "\n";
    $navigation .= '    <div class="col-4 col-m-4 vanish">' . "\n";
    if ( ! defined $next_page ) { my $blah = "do nothing"; } else { 
	my $next_title = $lists{$next_page}{title} ;
	$navigation .= '<p class="zero" style="text-align: right;">' . "\n";
	$navigation .= '<a href="/cgi-bin/aiutami.pl?coll=' . $next_page . '">' . $next_title . '</a>';
	$navigation .= '&nbsp;&gt;&gt;</p>' . "\n";
    }
    $navigation .= '    </div>' . "\n";
    $navigation .= '    ' . "\n";
    $navigation .= '  </div>' . "\n";
    $navigation .= '  <!-- end row div -->' . "\n";

    
    ##  create the HTML output
    my $othtml ;
    $othtml .= '<div><h3 style="margin-top: 0em;">Dizziunariu di Dieli</h3></div>' . "\n" ; 
    ##  start with navigation
    $othtml .= $navigation ; 
    ##  open the div
    $othtml .= '<div class="listall">' . "\n" ; 
    $othtml .= '<div class="row">' . "\n" ; 
    ##  open columns
    $othtml .= '<div class="rolltb">' . "\n" ; 
    $othtml .= '<div class="rolldk">' . "\n" ; 
    $othtml .= $amsubs{mk_amkcontent}( \@amkone , $amlsrf , \%amsubs , $lastauto );
    $othtml .= '</div>' . "\n" ;
    $othtml .= '<div class="rolldk">' . "\n" ; 
    $othtml .= $amsubs{mk_amkcontent}( \@amktwo , $amlsrf , \%amsubs , $lastauto );
    $othtml .= '</div>' . "\n" ;
    $othtml .= '</div>' . "\n" ;
    $othtml .= '<div class="rolltb">' . "\n" ; 
    $othtml .= '<div class="rolldk">' . "\n" ; 
    $othtml .= $amsubs{mk_amkcontent}( \@amktre , $amlsrf , \%amsubs , $lastauto );
    $othtml .= '</div>' . "\n" ;
    $othtml .= '<div class="rolldk">' . "\n" ; 
    $othtml .= $amsubs{mk_amkcontent}( \@amkqtt , $amlsrf , \%amsubs , $lastauto );
    $othtml .= '</div>' . "\n" ;
    $othtml .= '</div>' . "\n" ;
    ##  close columns
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    ##  close the div
    $othtml .= $navigation ; 
    ##  end with navigation

    $othtml .= '<p style="margin-bottom: 0.5em; text-align: center;">Grazii a'."\n";
    $othtml .= '  <a href="http://www.dieli.net/" target="_blank">Arthur Dieli</a>'."\n";
    $othtml .= '  pi cumpilari stu dizziunariu.</p>'."\n";

    return $othtml ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make columns for part of speech list
sub mk_amkcontent {

    my @amkargs = @{ $_[0] } ;
    my %amlist  = %{ $_[1] } ;
    my %amsubs  = %{ $_[2] } ;  
    ##  my %vbsubs  = %{ $_[3] } ;  
    my $lastauto  =  $_[3]   ;  
    
    ##  create the HTML
    my $hold_letter = "" ; 
    my $othtml ;
    
    ##  make each entry
    foreach my $hkey (@amkargs) {
	
	my $display = $amlist{$hkey}{palora} ;
	my $hashkey = $amlist{$hkey}{hashkey} ;
	my $partsp  = $amlist{$hkey}{part_speech} ;
	
	##  ##  print initial letter if necessary
	##  my $initial_letter = lc(substr($vbsubs{rid_accents}($display),0,2)) ; 
	##  if ( $initial_letter ne $hold_letter ) {
	##      $hold_letter = $initial_letter ; 
	##      $othtml .= '<p style="margin-left: 10px"><b><i>' . uc($hold_letter) . '</i></b></p>' . "\n" ;
	##  }
	
	##  prepare output
	my $link = $amsubs{make_link}( $hashkey , $display , $lastauto , $partsp ) ;
	$othtml .= '<p class="zero">' . $link . '</p>' . "\n" ; 
    }
    
    return $othtml ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  create a card deck and select five cards, with one for captcha
sub play_cards {

    my %carti = (
	
	"c01" => { image => "/config/carti/asucoppi.jpg", name => "as'i coppi",},
	"m01" => { image => "/config/carti/asumazzi.jpg", name => "as'i mazzi",},
	"o01" => { image => "/config/carti/asudoru.jpg" , name => "asu d'oru" ,},
	"s01" => { image => "/config/carti/asuspadi.jpg", name => "as'i spati",},

	"c02" => { image => "/config/carti/ducoppi.jpg" , name => "du'i coppi",},
	"m02" => { image => "/config/carti/duimazzi.jpg", name => "du'i mazzi",},
	"o02" => { image => "/config/carti/duoru.jpg"   , name => "du'oru",},
	"s02" => { image => "/config/carti/duispati.jpg", name => "du'i spati",},

	"c03" => { image => "/config/carti/tricoppi.jpg", name => "tri di coppi",},
	"m03" => { image => "/config/carti/trimazzi.jpg", name => "tri di mazzi",},
	"o03" => { image => "/config/carti/trioru.jpg"  , name => "tri di oru",},
	"s03" => { image => "/config/carti/trispadi.jpg", name => "tri di spati",},

	"c04" => { image => "/config/carti/quattrucoppi.jpg", name => "quattru di coppi",},
	"m04" => { image => "/config/carti/quattrumazzi.jpg", name => "quattru di mazzi",},
	"o04" => { image => "/config/carti/quattruoru.jpg"  , name => "quattr'oru",},
	"s04" => { image => "/config/carti/quattruspati.jpg", name => "quattr'i spati",},

	"c05" => { image => "/config/carti/cincucoppi.jpg", name => "cincu di coppi",},
	"m05" => { image => "/config/carti/cincumazzi.jpg", name => "cincu di mazzi",},
	"o05" => { image => "/config/carti/cincoru.jpg"   , name => "cinc'oru",},
	"s05" => { image => "/config/carti/cincuspati.jpg", name => "cinc'i spati",},

	"c06" => { image => "/config/carti/seicoppi.jpg", name => "sei di coppi",},
	"m06" => { image => "/config/carti/seimazzi.jpg", name => "sei di mazzi",},
	"o06" => { image => "/config/carti/seoru.jpg"   , name => "sei di oru",},
	"s06" => { image => "/config/carti/seispati.jpg", name => "sei di spati",},

	"c07" => { image => "/config/carti/setticoppi.jpg", name => "setti di coppi",},
	"m07" => { image => "/config/carti/settimazzi.jpg", name => "setti di mazzi",},
	"o07" => { image => "/config/carti/settoru.jpg"   , name => "sett'oru",},
	"s07" => { image => "/config/carti/settispati.jpg", name => "setti di spati",},

	"c08" => { image => "/config/carti/donnacoppi.jpg", name => "donna di coppi",},
	"m08" => { image => "/config/carti/donnamazzi.jpg", name => "donna di mazzi",},
	"o08" => { image => "/config/carti/donnaoru.jpg"  , name => "donna di oru",},
	"s08" => { image => "/config/carti/donnaspati.jpg", name => "donna di spati",},

	"c09" => { image => "/config/carti/cavadducoppi.jpg", name => "cavaddu di coppi",}, 
	"m09" => { image => "/config/carti/cavaddumazzi.jpg", name => "cavaddu di mazzi",},
	"o09" => { image => "/config/carti/cavadduoru.jpg"  , name => "cavaddu di oru",},
	"s09" => { image => "/config/carti/cavadduspati.jpg", name => "cavaddu di spati",},

	"c10" => { image => "/config/carti/recoppi.jpg" , name => "re di coppi",},
	"m10" => { image => "/config/carti/remazzi.jpg" , name => "re di mazzi",},
	"o10" => { image => "/config/carti/reoru.jpg"   , name => "re di oru",},
	"s10" => { image => "/config/carti/respati.jpg" , name => "re di spati",},
	
	"a_c01" => { image => "/config/carti/quartara.jpg"   , name => "a quartara",},
	"a_m01" => { image => "/config/carti/aciolla.jpg"    , name => "a ciolla",},
	"a_o01" => { image => "/config/carti/lovufrittu.jpg" , name => "l'ovu frittu",},

	"a_m02" => { image => "/config/carti/acravatta.jpg"   , name => "a cravatta",},
	"a_c04" => { image => "/config/carti/utabbutu.jpg"    , name => "u tabbutu",},
	"a_m08" => { image => "/config/carti/agiallinusa.jpg" , name => "a giallinusa",},

	"a_o10" => { image => "/config/carti/amatta.jpg"      , name => "a matta",},
	"a_c10" => { image => "/config/carti/lorbu.jpg"       , name => "l'orbu",},

	);

    ##  randomly select five cards
    ##  may be same suit, may NOT be same rank
    my %suits = ("1" => "c", "2" => "m", "3" => "o", "4" => "s");
    my @cards ;
    until ($#cards == 4) {
	my $rank = int(rand(10)) + 1 ; 
	my $suit = int(rand(4)) + 1 ; 

	$rank = sprintf( "%02d" , $rank ) ;
	$suit = $suits{$suit} ;
	my $card = $suit . $rank ;

	if ($#cards < 0){
	    push( @cards , $card ) ;
	} else {
	    my @already = @cards ;
	    s/^[cmos]// for @already ;
	    my $regex = join( "|" , @already ) ;
	    if ( $rank !~ /$regex/ ) {
		push( @cards , $card ) ;
	    }
	}
    }

    ##  randomly select one of those five to be the picture card
    my $select = int(rand(5)) ; 
    my $picture = $cards[$select] ; 
    
    ##  which image? when alternative available, use it!
    my $image = ( $picture =~ /c01|m01|o01|m02|c04|m08|o10|c10/ ) ? "a_" . $picture : $picture ;

    ##  put everything into a hash
    my %othash ;
    $othash{picture}{key}   = $picture ;
    $othash{picture}{image} = $carti{$image}{image} ;

    ##  sub to sort the cards
    my $drop_suit = sub { 
	my $str = $_[0] ; 
	$str =~ s/^[cmos]// ; 
	return $str ; 
    };
    
    ##  push the sorted cards onto the card hash
    foreach my $card (sort { &{$drop_suit}($a) <=> &{$drop_suit}($b) } @cards) {
	my %cardhash = ( card => $card , name => $carti{$card}{name} ) ;
	push( @{$othash{cards}} , \%cardhash ) ;
    }
    
    return \%othash ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  create captcha with sicilian cards
sub deal_cards {
    
    my %amsubs   = %{ $_[0] } ;
    my $palora   =    $_[1]   ;  ##  to send the word just annotated
    my $lastauto =    $_[2]   ;  ##  and then where to send user?

    my %othash  = %{ $amsubs{play_cards}() };
    
    my $picture = $othash{picture}{key} ;
    my $image   = $othash{picture}{image} ; 
    my @cards   = @{$othash{cards}} ;
    
    my $code = $amsubs{encode_carta}( $picture ) ; 
    ## my $carta = $amsubs{decode_carta}( $code ) ; 
    
    my $othtml ; 
    ##  sending the hash key of the word we just annotated
    $othtml .= '<input type="hidden" value="'. $lastauto .'" name="lastauto">' . "\n" ;
    $othtml .= '<input type="hidden" value="'. $code .'" name="cagna">' . "\n" ;
    $othtml .= '<input type="hidden" value="'. $palora .'" name="palora">' . "\n" ;

    $othtml .= '<div class="row btop">' . "\n" ;
    $othtml .= '<div class="col-m-1 col-2"></div>' . "\n" ; 
    $othtml .= '<div class="col-m-6 col-5 tbright">' . "\n" ; 
    $othtml .= '<img style="width: 75%; max-width: 200px;" src="' . $image  . '">' ;
    $othtml .= '</div>' . "\n" ; 

    $othtml .= '<div class="col-m-4 col-4 tbleft">' . "\n" ; 
    $othtml .= '<p style="margin-bottom: 0.25em;"><span class="lightcolor"><i>' ;
    $othtml .= 'Quali carta è chista?</i></span></p>' . "\n" ; ## '&nbsp;<b>*</b>'
    $othtml .= '<div class="smallctr">' . "\n" ; 
    $othtml .= '<select name="chista_carta_e">' . "\n" ;
    $othtml .= '<option value="x90">(scegghi)' . "\n" ;
    
    foreach my $chref (@cards) {
	my %ch = %{ $chref } ;
	my $card = $ch{card} ;
	my $name = $ch{name} ;
	$othtml .= '<option value="'. $card .'">' . $name  . "\n" ;
    }
    $othtml .= '</select>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '<p style="margin-top: 0.25em;">' ; 
    $othtml .= '<small><span class="lightcolor"><i>Haiu a essiri sicuru ca tu sì essiri umanu.</i></span></small></p>' . "\n" ;
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '<div class="col-m-1 col-1"></div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ;    
    return $othtml ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sub to encode a ridiculously weak captcha
sub encode_carta {
    my $carta = $_[0] ;
    my $rand ;
    for my $i (0..4) { $rand .= int(rand(10)) ; } ;
    my $code = reverse( $rand . $carta ) ;
    return $code ;
}

##  sub to decode a ridiculously weak captcha
sub decode_carta {
    my $code = substr( $_[0] , 0 , 3 ) ; 
    my $carta = reverse( $code ) ;
    return $carta ;    
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_amtophtml {

    my $topnav = $_[0] ; 

    my $ottxt ;
    $ottxt .= "Content-type: text/html\n\n";
    $ottxt .= '<!DOCTYPE html>' . "\n" ;
    $ottxt .= '<html>' . "\n" ;
    $ottxt .= '  <head>' . "\n" ;
    $ottxt .= '    <title>Aiùtami! :: Eryk Wdowiak</title>' . "\n" ;
    $ottxt .= '    <meta name="DESCRIPTION" content="aiutami'. "'" .'nnotari nu dizzionariu sicilianu">' . "\n" ;
    $ottxt .= '    <meta name="KEYWORDS" content="Sicilian, language, dictionary">' . "\n" ;
    $ottxt .= '    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' . "\n" ;
    $ottxt .= '    <meta name="Author" content="Eryk Wdowiak">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk.css">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_theme-bklyn.css">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_widenme.css">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/cchiu_forms.css">' . "\n" ;
    $ottxt .= '    <link rel="icon" type="image/png" href="/config/eryk-icon.png">' . "\n" ;
    $ottxt .= '    <meta name="viewport" content="width=device-width, initial-scale=1">' . "\n" ;

    ##  extra CSS
    $ottxt .= '    <style>' . "\n" ;
    
#    ##  show/hide future and conditional
#    $ottxt .= '      #fticoi {  display: none; }' . "\n" ;
#    $ottxt .= '      #fticoi:target {  display: block; }' . "\n" ;
#    $ottxt .= '      #closeme {  display: none; }' . "\n" ;
#    $ottxt .= '      #closeme:target {  display: block; }' . "\n" ;

    ##  DIV -- for top and bottom borders
    $ottxt .= '      div.btop { background-color: rgb(255, 255, 204);' . "\n" ; 
    $ottxt .= '                 width: 80%;  margin: 0em auto 0em auto;' . "\n" ;
    $ottxt .= '                 padding: 7px 0px 7px 0px;' . "\n" ;
    $ottxt .= '                 border-top: 1px solid rgb(106, 2, 2);}' . "\n" ;

    $ottxt .= '      @media only screen and (max-width: 500px) { ' . "\n" ;
    $ottxt .= '          div.btop { width: 95%; }' . "\n" ;
    $ottxt .= '      }' . "\n" ;
    $ottxt .= '      div.bbot { border-bottom: 1px solid rgb(106, 2, 2); }' . "\n" ;
    $ottxt .= '      div.bside { border-left: 1px solid rgb(106, 2, 2);' . "\n" ;
    $ottxt .= '                  border-right: 1px solid rgb(106, 2, 2); }' . "\n" ;
    
    ##  zero and half paragraph spacing
    $ottxt .= '      p.zero { margin-top: 0em; margin-bottom: 0em; }' . "\n" ;
    $ottxt .= '      p.half { margin-top: 0.5em; margin-bottom: 0.5em; }' . "\n" ;

    ##  form text -- larger, different font
    $ottxt .= '      p.formtext { font-size: 1.05em; font-family: Arial, "Liberation Sans", sans-serif; }' . "\n" ;

    ##  DIV -- "tbleft", "tbright" and center them on small screens
    $ottxt .= '      @media only screen and (min-width: 480px) { ' . "\n" ;
    $ottxt .= '          div.tbright { text-align: right; }' . "\n" ;
    $ottxt .= '      }' . "\n" ;
    $ottxt .= '      @media only screen and (min-width: 480px) { ' . "\n" ;
    $ottxt .= '          div.tbleft { text-align: left; }' . "\n" ;
    $ottxt .= '      }' . "\n" ;
    $ottxt .= '      @media only screen and (max-width: 479px) { ' . "\n" ;
    $ottxt .= '          div.tbright, div.tbleft { text-align: center; }' . "\n" ;
    $ottxt .= '      }' . "\n" ;

    ##  DIV -- translations and conjugations
    $ottxt .= '      div.transconj { position: relative; margin: auto; width: 50%;}' . "\n" ;
    $ottxt .= '      @media only screen and (max-width: 835px) { ' . "\n" ;
    $ottxt .= '          div.transconj { position: relative; margin: auto; width: 90%;}' . "\n" ;
    $ottxt .= '      }' . "\n" ;

#    ##  DIV -- suggestions
#    $ottxt .= '      div.cunzigghiu { position: relative; margin: auto; width: 50%;}' . "\n" ;
#    $ottxt .= '      @media only screen and (max-width: 835px) { ' . "\n" ;
#    $ottxt .= '          div.cunzigghiu { position: relative; margin: auto; width: 90%;}' . "\n" ;
#    $ottxt .= '      }' . "\n" ;

    ##  close CSS -- close head
    $ottxt .= '    </style>' . "\n" ;
    $ottxt .= '  </head>' . "\n" ;

    open( TOPNAV , $topnav ) || die "could not read:  $topnav";
    while(<TOPNAV>){ chomp;  $ottxt .= $_ . "\n" ; };
    close TOPNAV ;

    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    $ottxt .= '    <div class="col-m-12 col-12">' . "\n" ;
    $ottxt .= '      <h1>Aiùtami!</h1>' . "\n" ;
    $ottxt .= '      <h2>di Eryk Wdowiak</h2>' . "\n" ;
    $ottxt .= '    </div>' . "\n" ;
    $ottxt .= '  </div>' . "\n" ;
    $ottxt .= '  <!-- end row div -->' . "\n" ;
    $ottxt .= '  ' . "\n" ;
    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    
    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub offer_translation {

    my $inword  =    $_[0]   ;
    my %amlist  = %{ $_[1] } ;
    my %amsubs  = %{ $_[2] } ;
    my $askORthank = $_[3]   ;  
    $askORthank = ( ! defined $askORthank || $askORthank ne "thankyou" ) ? "askhelp" : "thankyou" ; 

    ##  form of the word to display
    my $display = $amlist{ $inword }{palora};
    ##  replace squote
    $display =~ s/_SQUOTE_/'/g;
     
    ##  parti di discursu 
    my $part_speech = $amlist{ $inword }{part_speech} ;
    $part_speech =~ s/^verb$/verbu/ ;
    $part_speech =~ s/^noun$/sust./ ;
    $part_speech =~ s/^adj$/agg./ ;
    $part_speech =~ s/^adv$/avv./ ;
    $part_speech =~ s/^prep$/prip./ ;
    $part_speech =~ s/^pron$/prun./ ;

    ##  translations
    my $dieli_en = $amlist{$inword}{dieli_en};
    my $dieli_it = $amlist{$inword}{dieli_it};
    ##  replace squote
    $dieli_en =~ s/_SQUOTE_/'/g;
    $dieli_it =~ s/_SQUOTE_/'/g;

    ##  prepare output
    my $othtml ;

    ##  outer DIV to limit width
    $othtml .= '<div class="row btop">' . "\n" ; 
    if ( $askORthank eq "askhelp" ) {
	$othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.25em; text-align: center;"><i>' ;
	$othtml .= '<span class="lightcolor">Mi dici cchiù di sta palora?</i></p>' . "\n" ; 
    } else {
	$othtml .= '<p style="margin-top: 0.2em; margin-bottom: 0.25em; text-align: center;">' ;
	$othtml .= '<b><i><span class="lightcolor">Grazzii a pi l' . "'" . 'aiutu!</span></i></b></p>' . "\n" ; 
	$othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.25em; text-align: center;"><i>' ;
	$othtml .= '<span class="lightcolor">Mi dici cchiù di sta palora puru?</span></i></p>' . "\n" ; 
    }
    ##  inner DIV
    $othtml .= '<div class="transleft">' . "\n" ;
    $othtml .= '<p class="half formtext"><b><span style="font-size: 1.1em">' . $display . '</span></b>' ;    
    $othtml .= '&nbsp;&nbsp;{' . $part_speech . '}</p>' . "\n" ;

    $othtml .= '<p class="zero formtext"><b>EN:</b> &nbsp; ' . $dieli_en  . '</p>' . "\n";
    $othtml .= '<p class="zero formtext"><b>IT:</b> &nbsp; ' . $dieli_it  . '</p>' . "\n";
    $othtml .= '</div>' . "\n" ;
    ##  closing inner DIV
    $othtml .= '</div>' . "\n" ;
    ##  closing DIV to limit width

    return $othtml ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  try to repair unicode accents
sub fix_accents {
    
    my $str = $_[0] ;
    $str =~ s/(\240|\241|\242|\244|\250|\251|\252|\253|\254|\255|\256|\257|\262|\263|\264|\266|\271|\272|\273|\274|\200|\201|\202|\204|\210|\211|\212|\213|\214|\215|\216|\217|\222|\223|\224|\226|\231|\232|\233|\234)\303/\303$1/;
    return $str ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  compare difference in two strings 
##  and surround it with '<span></span>' 
sub make_lightdiff {

    my $str1 = $_[0] ; 
    my $str2 = $_[1] ; 

    ##  copy the strings
    my $ldiff1 = $str1 ;
    my $ldiff2 = $str2 ;

    if ( $ldiff1 eq $ldiff2 ) {
	my $blah = "already equivalent";
    } else {

	##  capture common prefix
	my $prefix1 ; my $prefix2 ;
	if ( ($str1 ^ $str2) =~ /^(\x00*)/ ) {
	    $prefix1 = substr( $str1, 0, $+[1] ) ;
	    $prefix2 = substr( $str2, 0, $+[1] ) ;
	}
	
	##  capture common suffix
	my $suffix1 ; my $suffix2 ;
	if ( (reverse($str1) ^ reverse($str2)) =~ /^(\x00*)/ ) {
	    $suffix1 = substr( $str1, -$+[1], length($str1) );
	    $suffix2 = substr( $str2, -$+[1], length($str2) );
	}
	
	##  make the differences lighter in color
	$ldiff1 =~ s/^($prefix1)/$1<span class="lightcolor">/;
	$ldiff2 =~ s/^($prefix2)/$1<span class="lightcolor">/;
	
	$ldiff1 =~ s/($suffix1)?$/<\/span>$1/;
	$ldiff2 =~ s/($suffix2)?$/<\/span>$1/;
    }
	
    ##  return the pair
    return( $ldiff1 , $ldiff2 ) ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  create field for submission of poetry and proverbs
sub make_poetry {

    my $othtml ; 
    $othtml .= '<div class="row btop">' . "\n" ; 
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.25em; text-align: center;">' ;
    $othtml .= '<i><span class="lightcolor">' . "\n" ; 
    $othtml .= 'Canusci na puema o nu pruverbiu tipicu di sta palora?  Scrivilu ccà!</span></i></p>' . "\n" ; 
    $othtml .= '<textarea name="poetry">Raccuntami puisia!</textarea>' . "\n"; 
    $othtml .= '</div>' . "\n" ; 
    return $othtml ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make name field for form
sub make_namefield {
    my $othtml ; 
    $othtml .= "\n" ;
    $othtml .= '<div class="row btop">' . "\n" ;
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.25em; text-align: center;">' . "\n" ; 
    $othtml .= '<i><span class="lightcolor">Pi curtisia, mi dici lu to nomu?</span></i></p>'. "\n" ; 
    $othtml .= '<div class="col-m-4 col-4 tbright">' . "\n" ; 
    $othtml .= '<p class="vanish" style="margin-top: 0.2em; margin-bottom:0.2em;">nomu:</p>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '<div class="col-m-8 col-8 tbleft">' . "\n" ; 
    $othtml .= '<input type=text name="Name" size="20" maxlength="20">' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    return $othtml ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make top of form
sub make_form_top {
    my $othtml ; 
    $othtml .= "\n" ;
    $othtml .= '<div style="margin-bottom: 0.5em; margin-top: 0em;">' . "\n" ;
    $othtml .= '<form enctype="multipart/form-data" action="/cgi-bin/aiutami.pl" method="post">' . "\n" ; 
    $othtml .= '<!-- begin form -->' . "\n" ;
    return $othtml ;
}

##  make bottom of form
sub make_form_bottom {
    my $othtml ; 
    $othtml .= "\n" ;
    $othtml .= '<div class="row btop bbot">' . "\n" ;
    $othtml .= '<div style="text-align: center;">' .  "\n" ; 
    $othtml .= '<input type="submit" value="Spidiscimi!">' . "\n" ; 
    $othtml .= '</div>' .  "\n" ; 
    $othtml .= '</div>' .  "\n" ; 
    $othtml .= '<!-- end form -->' . "\n" ;
    $othtml .= '</form>' .  "\n" ; 
    $othtml .= '</div>' .  "\n" ; 
    return $othtml ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub test_verb {

    my $palora =    $_[0] ;
    my %amlist = %{ $_[1] } ;
    my %amsubs = %{ $_[2] } ;
    my %vbsubs = %{ $_[3] } ;
    my $vbconj =    $_[4]   ;
    
    ##  collect the hash keys
    my $hashkey      = $amlist{$palora}{hashkey};
    my $noteson      = $amlist{$palora}{notes_on};
    my $display      = $amlist{$palora}{palora};
    my $part_speech  = $amlist{$palora}{part_speech};
    my $conjA        = $amlist{$palora}{verb}{conj};  ##  $conjA -- original only has one guess
    my $conjB        = $amlist{$palora}{verb}{conj};  ##  $conjB -- original only has one guess
    my $stemA        = $amlist{$palora}{verb}{stemA};
    my $bootA        = $amlist{$palora}{verb}{bootA};
    my $stemB        = $amlist{$palora}{verb}{stemB};
    my $bootB        = $amlist{$palora}{verb}{bootB};
    my $dieli_en     = $amlist{$palora}{dieli_en};
    my $dieli_it     = $amlist{$palora}{dieli_it};

    $stemA = $amsubs{fix_accents}( $stemA ) ;
    $stemB = $amsubs{fix_accents}( $stemB ) ;
    $bootA = $amsubs{fix_accents}( $bootA ) ;
    $bootB = $amsubs{fix_accents}( $bootB ) ;
        
    ##  things to look for:
    ##    *  hash keys should be equivalent:  ($palora eq $hashkey)
    ##    *  should not have entered this subroutine if:  ($noteson eq "1")

    ##  because we need to make guesses, comparisons, etc.
    ##  because (SCIRE) verbs are hard to identify
    ##  let's guess (SCIRE) when we have an opportunity
    if ( ($stemA eq $stemB) && ($bootA eq $bootB) && ($conjA eq "xxiri") && ($conjB eq "xxiri") ) {
	( $bootB = $display ) =~ s/iri$/ìsc/;
	$conjB = "sciri"
    }

    ##  conjugate the verb, two different ways
    my %protos ; 
    %{$protos{"proto_alfa"}} = ( 
	part_speech => "verb",
	verb => { conj => $conjA, stem => $stemA,  boot => $bootA, },
	);
    %{$protos{"proto_beta"}} = ( 
	part_speech => "verb",
	verb => { conj => $conjB, stem => $stemB,  boot => $bootB, },
	);
    ##  and if it's reflexive, then it's reflexive
    %{$protos{"reflex_alfa"}} = ( 
	part_speech => "verb",
	reflex => "proto_alfa",
	); 
    %{$protos{"reflex_beta"}} = ( 
	part_speech => "verb",
	reflex => "proto_beta",
	); 

    ##  conjugate the verb, two different ways
    ##  and if it's reflexive, then it's reflexive
    my %conj_alfa ; 
    my %conj_beta ; 
    if ( $display =~ /isi$/ ) {
	%conj_alfa = $vbsubs{conjugate}( "reflex_alfa" , \%protos , $vbconj , \%vbsubs ) ; 
	%conj_beta = $vbsubs{conjugate}( "reflex_beta" , \%protos , $vbconj , \%vbsubs ) ; 
    } else {
	%conj_alfa = $vbsubs{conjugate}( "proto_alfa" , \%protos , $vbconj , \%vbsubs ) ; 
	%conj_beta = $vbsubs{conjugate}( "proto_beta" , \%protos , $vbconj , \%vbsubs ) ; 
    }

    
    ##  highlight differences in present tense (PRI)(US) and (PRI)(UP)
    ( $conj_alfa{pri}{us} , $conj_beta{pri}{us} ) = 
	$amsubs{make_lightdiff}( $conj_alfa{pri}{us} , $conj_beta{pri}{us} );
    ( $conj_alfa{pri}{up} , $conj_beta{pri}{up} ) = 
	$amsubs{make_lightdiff}( $conj_alfa{pri}{up} , $conj_beta{pri}{up} );

    ##  highlight differences in past tense -- (PAI)(US) and (PAI)(DS)
    ( $conj_alfa{pai}{us} , $conj_beta{pai}{us} ) = 
	$amsubs{make_lightdiff}( $conj_alfa{pai}{us} , $conj_beta{pai}{us} );
    ( $conj_alfa{pai}{ds} , $conj_beta{pai}{ds} ) = 
	$amsubs{make_lightdiff}( $conj_alfa{pai}{ds} , $conj_beta{pai}{ds} );

    
    ##  create the HTML
    my $othtml ; 

    ##  test the present tense (PRI)
    $othtml .= '<div class="row btop">' . "\n" ; 
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; text-align: center;">' ;
    $othtml .= '<i><span class="lightcolor">' . "\n" ; 
    $othtml .= 'Ntô <b>prisenti</b>, comu si dici?</span></i></p>' . "\n" ; 
    $othtml .= '<div style="margin-left: 20px;">' . "\n" ; 
    ##  radio options (PRI)
    $othtml .= '<label class="container">"Iu ' . $conj_alfa{pri}{us} . '." &nbsp; "Nuatri ' . $conj_alfa{pri}{up} . '."' . "\n";
    my $value_pri_alfa = 'PRI' . '_conj_' . $conjA . '_stem_'. $stemA .'_boot_'. $bootA  ;
    $othtml .= '  <input type="radio" name="vb_PRI" value="' . $value_pri_alfa . '">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  if either the stems differ OR the boots differ OR the conjugations differ
    ##  then ask for comparison, otherwise ask if irregular
    if ( ($stemA ne $stemB) || ($bootA ne $bootB) || ($conjA ne $conjB) ) {
	##  radio options (PRI)
	$othtml .= '<label class="container">"Iu ' . $conj_beta{pri}{us} . '." &nbsp; "Nuatri ' . $conj_beta{pri}{up} . '."' . "\n";
	my $value_pri_beta = 'PRI' . '_conj_' . $conjB . '_stem_'. $stemB .'_boot_'. $bootB  ;
	$othtml .= '  <input type="radio" name="vb_PRI" value="' . $value_pri_beta .'">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
	##  irregular (PRI)
	$othtml .= '<label class="container">Nudda di chisti.' . "\n";
	$othtml .= '  <input type="radio" name="vb_PRI" value="PRI_Nudda">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    } else {
	##  irregular (PRI)
	$othtml .= '<label class="container">Nun accussì. &nbsp; Nun è rigulari.' . "\n";
	$othtml .= '  <input type="radio" name="vb_PRI" value="PRI_NunRigulari">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    }
    ##  nun sacciu (PRI)
    $othtml .= '<label class="container">Nun sacciu.' . "\n";
    $othtml .= '  <input type="radio" name="vb_PRI" value="PRI_NunSacciu">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  close radio (PRI)
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    ##  done with present tense (PRI)


    ##  test the preterite (PAI)  
    ##    *  do NOT report "boot" from PAI tests
    ##    *  "boot" only used to conjugate present
    $othtml .= '<div class="row btop">' . "\n" ; 
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; text-align: center;">' ;
    $othtml .= '<i><span class="lightcolor">' . "\n" ; 
    $othtml .= 'Ntô <b>passatu</b>, comu si dici?</span></i></p>' . "\n" ; 
    $othtml .= '<div style="margin-left: 20px;">' . "\n" ; 
    ##  radio options (PAI)
    $othtml .= '<label class="container">"Iu ' . $conj_alfa{pai}{us} . '." &nbsp; "Tu ' . $conj_alfa{pai}{ds} . '."' . "\n";
    my $value_pai_alfa = 'PAI' . '_conj_' . $conjA . '_stem_'. $stemA ;
    $othtml .= '  <input type="radio" name="vb_PAI" value="'. $value_pai_alfa  .'">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  if the conjugations differ
    ##  then ask for comparison, otherwise ask if irregular
    if ( ( $conj_alfa{pai}{us} ne $conj_beta{pai}{us} ) || ( $conj_alfa{pai}{ds} ne $conj_beta{pai}{ds} ) ) {
	##  radio options (PAI)
	$othtml .= '<label class="container">"Iu ' . $conj_beta{pai}{us} . '." &nbsp; "Tu ' . $conj_beta{pai}{ds} . '."' . "\n";
	my $value_pai_beta = 'PAI' . '_conj_' . $conjB . '_stem_'. $stemB ;	
	$othtml .= '  <input type="radio" name="vb_PAI" value="'. $value_pai_beta  .'">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
	##  irregular (PAI)
	$othtml .= '<label class="container">Nudda di chisti.' . "\n";
	$othtml .= '  <input type="radio" name="vb_PAI" value="PAI_Nudda">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    } else {
	##  irregular (PAI)
	$othtml .= '<label class="container">Nun accussì. &nbsp; Nun è rigulari.' . "\n";
	$othtml .= '  <input type="radio" name="vb_PAI" value="PAI_NunRigulari">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    }
    ##  nun sacciu (PAI)
    $othtml .= '<label class="container">Nun sacciu.' . "\n";
    $othtml .= '  <input type="radio" name="vb_PAI" value="PAI_NunSacciu">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  close radio (PAI)
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    ##  done with preterite (PAI)


    ##  test the past participle (PAP)
    $othtml .= '<div class="row btop">' . "\n" ; 
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; text-align: center;">' ;
    $othtml .= '<i><span class="lightcolor">' . "\n" ; 
    $othtml .= 'Comu si dici lu <b>participiu</b>?</span></i></p>' . "\n" ; 
    $othtml .= '<div style="margin-left: 20px;">' . "\n" ; 
    ##  radio options (PAP)
    $othtml .= '<label class="container">"aviri ' . $conj_alfa{pap} . '"' . "\n";
    my $value_pap_alfa = 'PAP' . '_conj_' . $conjA . '_stem_'. $stemA ;
    $othtml .= '  <input type="radio" name="vb_PAP" value="' . $value_pap_alfa .'">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  if the conjugations differ
    ##  then ask for comparison, otherwise ask if irregular
    if ( $conj_alfa{pap} ne $conj_beta{pap} ) {
	##  radio options (PAP)
	$othtml .= '<label class="container">"aviri ' . $conj_beta{pap} . '"' . "\n";
	my $value_pap_beta = 'PAP' . '_conj_' . $conjB . '_stem_'. $stemB ;
	$othtml .= '  <input type="radio" name="vb_PAP" value="' . $value_pap_beta .'">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
	##  irregular (PAP)
	$othtml .= '<label class="container">Nudda di chisti.' . "\n";
	$othtml .= '  <input type="radio" name="vb_PAP" value="PAP_Nudda">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    } else {
	##  irregular (PAP)
	$othtml .= '<label class="container">Nun accussì. &nbsp; Nun è rigulari.' . "\n";
	$othtml .= '  <input type="radio" name="vb_PAP" value="PAP_NunRigulari">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    }
    ##  nun sacciu (PAP)
    $othtml .= '<label class="container">Nun sacciu.' . "\n";
    $othtml .= '  <input type="radio" name="vb_PAP" value="PAP_NunSacciu">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  close radio (PAP)
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    ##  done with past participle (PAP)


    ##  test the adjective (ADJ)
    $othtml .= '<div class="row btop">' . "\n" ; 
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; text-align: center;">' ;
    $othtml .= '<i><span class="lightcolor">' . "\n" ; 
    $othtml .= 'Comu si dici lu <b>aggittivu</b>?</span></i></p>' . "\n" ; 
    $othtml .= '<div style="margin-left: 20px;">' . "\n" ; 
    ##  radio options (ADJ)
    my $adjA = $conj_alfa{adj} ; 
    ##  switch to (ADJ)(FEM)
    $adjA =~ s/u$/a/ ;
    $othtml .= '<label class="container">"È na cosa ' . $adjA . '."' . "\n";
    my $value_adj_alfa = 'ADJ' . '_conj_' . $conjA . '_stem_'. $stemA ;
    $othtml .= '  <input type="radio" name="vb_ADJ" value="'. $value_adj_alfa .'">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  if the conjugations differ
    ##  then ask for comparison, otherwise ask if irregular
    if ( $conj_alfa{adj} ne $conj_beta{adj} ) {
	##  radio options (ADJ)
	my $adjB = $conj_beta{adj} ; 
	##  switch to (ADJ)(FEM)
	$adjB =~ s/u$/a/ ;
	$othtml .= '<label class="container">"È na cosa ' . $adjB . '."' . "\n";
	my $value_adj_beta = 'ADJ' . '_conj_' . $conjB . '_stem_'. $stemB ;
	$othtml .= '  <input type="radio" name="vb_ADJ" value="'. $value_adj_beta .'">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
	##  irregular (ADJ)
	$othtml .= '<label class="container">Nudda di chisti.' . "\n";
	$othtml .= '  <input type="radio" name="vb_ADJ" value="ADJ_Nudda">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    } else {
	##  irregular (ADJ)
	$othtml .= '<label class="container">Nun accussì. &nbsp; Nun è rigulari.' . "\n";
	$othtml .= '  <input type="radio" name="vb_ADJ" value="ADJ_NunRigulari">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    }
    ##  nun sacciu (ADJ)
    $othtml .= '<label class="container">Nun sacciu.' . "\n";
    $othtml .= '  <input type="radio" name="vb_ADJ" value="ADJ_NunSacciu">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  close radio (ADJ)
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    ##  done with adjective (ADJ)
    
    
    return $othtml ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub test_noun { 

    my $palora       =    $_[0] ;
    my %amlist       = %{ $_[1] } ;
    my $nounpls_ref  =    $_[2] ; 
    my %vbsubs       = %{ $_[3] } ;
    ##my %amsubs       = %{ $_[x] } ;

    ##  collect the hash keys
    my $hashkey      = $amlist{$palora}{hashkey};
    my $noteson      = $amlist{$palora}{notes_on};
    my $display      = $amlist{$palora}{palora};
    my $part_speech  = $amlist{$palora}{part_speech};
    my $gender       = $amlist{$palora}{noun}{gender};  
    my $plend_alfa   = $amlist{$palora}{noun}{plend};  
    my $dieli_en     = $amlist{$palora}{dieli_en};
    my $dieli_it     = $amlist{$palora}{dieli_it};

    ##  things to look for:
    ##    *  hash keys should be equivalent:  ($palora eq $hashkey)
    ##    *  should not have entered this subroutine if:  ($noteson eq "1")
    
    ##  get the plural definite article
    my $pldefart = ( $vbsubs{rid_accents}($display) =~ /^[aeou]/ ) ? "l'" : "li" ; 

    ##  get the plural
    my $plural_alfa = $vbsubs{mk_noun_plural}( $display , $gender , $plend_alfa , $nounpls_ref );
    $plural_alfa = $pldefart . " " . $plural_alfa ; 

    ##  make options for the plural form
    my $plural_beta ;  
    my $plural_gmma ;
    my $plend_beta = "xixa" ; 
    my $plend_gmma = "xura" ; 
    if ( $gender eq "mas" && $plend_alfa eq "xi" &&  $display =~ /u$/ ) {
	$plural_beta = $vbsubs{mk_noun_plural}( $display , $gender , $plend_beta , $nounpls_ref );
	$plural_gmma = $vbsubs{mk_noun_plural}( $display , $gender , $plend_gmma , $nounpls_ref );

	$plural_beta = $pldefart . " " . $plural_beta ; 
	$plural_gmma = $pldefart . " " . $plural_gmma ; 
    }  

    ##  make output html
    my $othtml ;
    $othtml .= '<div class="row btop">' . "\n" ; 
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; text-align: center;">' ;
    $othtml .= '<i><span class="lightcolor">' . "\n" ; 
    $othtml .= 'Comu si dici lu <b>plurali</b>?</span></i></p>' . "\n" ; 
    $othtml .= '<div style="margin-left: 20px;">' . "\n" ; 

    ##  radio options 
    $othtml .= '<label class="container">"' . $plural_alfa . '"' . "\n";
    my $plend_val_alfa = 'PLEND' . '_gender_' . $gender . '_plend_'. $plend_alfa ; 
    $othtml .= '  <input type="radio" name="noun_PLEND" value="' . $plend_val_alfa . '">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    
    if ( ! defined $plural_beta && ! defined $plural_gmma ) {
	##  irregular 
	$othtml .= '<label class="container">Nun accussì. &nbsp; Nun è rigulari.' . "\n";
	$othtml .= '  <input type="radio" name="noun_PLEND" value="PLEND_NunRigulari">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    } else {
	##  radio options 
	$othtml .= '<label class="container">"' . $plural_alfa . '"&nbsp;&nbsp;o&nbsp;&nbsp;"' . $plural_beta . '"' . "\n";
	my $plend_val_beta = 'PLEND' . '_gender_' . $gender . '_plend_'. $plend_beta ; 
	$othtml .= '  <input type="radio" name="noun_PLEND" value="' . $plend_val_beta . '">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
	##  radio options 
	$othtml .= '<label class="container">"' . $plural_alfa . '"&nbsp;&nbsp;o&nbsp;&nbsp;"' . $plural_gmma . '"' . "\n";
	my $plend_val_gmma = 'PLEND' . '_gender_' . $gender . '_plend_'. $plend_gmma ; 
	$othtml .= '  <input type="radio" name="noun_PLEND" value="' . $plend_val_gmma . '">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
	##  irregular 
	$othtml .= '<label class="container">Nudda di chisti.' . "\n";
	$othtml .= '  <input type="radio" name="noun_PLEND" value="PLEND_Nudda">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    }
    ##  nun sacciu 
    $othtml .= '<label class="container">Nun sacciu.' . "\n";
    $othtml .= '  <input type="radio" name="noun_PLEND" value="PLEND_NunSacciu">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  close radio
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    ##  done with present tense
    
    return $othtml ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub test_adj {

    my $palora       =    $_[0] ;
    my %amlist       = %{ $_[1] } ;
    my %vbsubs       = %{ $_[2] } ;
    my %amsubs       = %{ $_[3] } ;

    ##  collect the hash keys
    my $hashkey      = $amlist{$palora}{hashkey};
    my $noteson      = $amlist{$palora}{notes_on};
    my $display      = $amlist{$palora}{palora};
    my $part_speech  = $amlist{$palora}{part_speech};
    my $massi        = $amlist{$palora}{adj}{massi};  
    my $dieli_en     = $amlist{$palora}{dieli_en};
    my $dieli_it     = $amlist{$palora}{dieli_it};

    ##  things to look for:
    ##    *  hash keys should be equivalent:  ($palora eq $hashkey)
    ##    *  should not have entered this subroutine if:  ($noteson eq "1")
    
    ##  get the forms
    my ( $massi_alfa , $femsi_alfa , $maspl , $fempl ) = $vbsubs{mk_adjectives}( $display );
    
    ##  make alternative if "femsi" ends in "-i"
    ( my $femsi_beta = $femsi_alfa ) =~ s/i$/a/ ;
    my $femsi_alfa_disp = $femsi_alfa ; 
    my $femsi_beta_disp = $femsi_beta ; 
    if ( $femsi_alfa ne $femsi_beta ) {
	( $femsi_alfa_disp , $femsi_beta_disp ) = $amsubs{make_lightdiff}( $femsi_alfa , $femsi_beta ); 
    }

    ##  make output html
    my $othtml ;
    $othtml .= '<div class="row btop">' . "\n" ; 
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; text-align: center;">' ;
    $othtml .= '<i><span class="lightcolor">' . "\n" ; 
    $othtml .= 'Comu si dici la forma <b>fimminili</b> di l' . "'" . ' aggitivu?</span></i></p>' . "\n" ; 
    $othtml .= '<div style="margin-left: 20px;">' . "\n" ; 
    ##  radio options 
    $othtml .= '<label class="container">"' . $femsi_alfa_disp . '"' . "\n";
    my $val_femsi_alfa = 'FEMSI' . '_' . $femsi_alfa ; 
    $othtml .= '  <input type="radio" name="adj_FEMSI" value="' . $val_femsi_alfa . '">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    if ( $femsi_alfa ne $femsi_beta ) {
	##  radio options 
	$othtml .= '<label class="container">"' . $femsi_beta_disp . '"' . "\n";
	my $val_femsi_beta = 'FEMSI' . '_' . $femsi_beta ; 
	$othtml .= '  <input type="radio" name="adj_FEMSI" value="' . $val_femsi_beta . '">' . "\n";
	$othtml .= '  <span class="checkmark"></span>' . "\n";
	$othtml .= '</label>' . "\n";
    }
    ##  irregular 
    $othtml .= '<label class="container">Nun accussì. &nbsp; Nun è rigulari.' . "\n";
    $othtml .= '  <input type="radio" name="adj_FEMSI" value="FEMSI_NunRigulari">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  nun sacciu 
    $othtml .= '<label class="container">Nun sacciu.' . "\n";
    $othtml .= '  <input type="radio" name="adj_FEMSI" value="FEMSI_NunSacciu">' . "\n";
    $othtml .= '  <span class="checkmark"></span>' . "\n";
    $othtml .= '</label>' . "\n";
    ##  close radio
    $othtml .= '</div>' . "\n" ; 
    $othtml .= '</div>' . "\n" ; 
    ##  done with present tense
    
    return $othtml ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  randomly select a word needing annotations
sub get_random_word {

    ##  fetch list of all hash keys
    my %amlist = %{ $_[0] } ; 
    my @allkeys = keys %amlist ;
    
    ##  randomly select a hash key 
    my $rand_draw = int( rand( $#allkeys + 1 ));
    my $palora = $allkeys[$rand_draw];	

    ##  keep selecting new hash keys  UNTIL
    ##  "notes_on" is undefined  &&  "part_speech" is verb, noun or adjective
    until ( ! defined $amlist{$palora}{notes_on} && $amlist{$palora}{part_speech} =~ /^verb$|^noun$|^adj$/ ) {
	$rand_draw = int( rand( $#allkeys + 1 ));
	$palora = $allkeys[$rand_draw];	    
    }
    ##  return the hash key
    return $palora ;	    
}


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  Bimminuti!
sub make_welcome_msg {
    my $othtml;
    $othtml .= "\n";
    $othtml .= '<!-- begin row div -->'."\n";
    $othtml .= '<div class="row">'."\n";
    $othtml .= '  <div class="col-m-1 col-1"></div>'."\n";
    $othtml .= '  <div class="col-m-10 col-10">'."\n";
    $othtml .= "\n";
    $othtml .= '<h3>Bimminuti!</h3>'."\n";
    $othtml .= "\n";    
    $othtml .= '<p>This page demonstrates a method of soliciting annotations to a Sicilian dictionary in a structured fashion.'."\n";
    $othtml .= '  <span style="color: rgb(204, 7, 39); font-weight: bold;">This page is under construction.</span>'."\n";
    $othtml .= '  During the construction phase, <span style="color: rgb(204, 7, 39); font-weight: bold;">no data</span>'."\n";
    $othtml .= '  is being recorded.</p>'."\n";
    $othtml .= "\n";
    $othtml .= '<p>When this page is ready, we will use it to annotate the Sicilian words in'."\n";
    $othtml .= '  <a href="http://www.dieli.net/" target="_blank">Arthur Dieli</a>'."'".'s'."\n"; 
    $othtml .= '  dictionary.  Below is an index of his work.</p>'."\n";
    $othtml .= "\n";
    $othtml .= '<p>Two modes will be available: &nbsp; "<a href="/cgi-bin/aiutami.pl?lastauto=auto">auto-mode</a>" and "browse-mode." '."\n";
    $othtml .= '  Auto-mode will solicit contributions to randomly selected words -- one word automatically following another.'."\n";
    $othtml .= '  Browse-mode will return you to the contents page after you annotate a word.'."\n";
    $othtml .= '  To start browsing, click on one of the index links below.'."\n";
    $othtml .= '  Or click here for: &nbsp; <a href="/cgi-bin/aiutami.pl?lastauto=auto">auto-mode</a>.</p>'."\n";
    $othtml .= "\n";
    ##  $othtml .= '<p></p>' . "\n"; 
    ##  $othtml .= "\n";
    ##  $othtml .= '<div style="margin-bottom: 0.5em; margin-top: 0.5em;">'."\n";
    ##  $othtml .= '<form enctype="multipart/form-data" action="/cgi-bin/aiutami.pl?lastauto=auto" method="post">'."\n";
    ##  $othtml .= '<div style="text-align: center;">'."\n";
    ##  $othtml .= '<input type="submit" value="Annutamu!">'."\n";
    ##  $othtml .= '</div>'."\n";
    ##  $othtml .= '</form>'."\n";
    ##  $othtml .= '</div>'."\n";
    ##  $othtml .= "\n";  
    $othtml .= '  </div>'."\n";   
    $othtml .= '  <div class="col-m-1 col-1"></div>'."\n";
    $othtml .= '</div>'."\n";
    $othtml .= '<!-- end row div -->'."\n";
    $othtml .= "\n";
    return $othtml;
}


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  WRAP IT ALL UP
##  ==== == === ==

##  hash to store subs for aiutami
my %amsubs ; 
$amsubs{datestamp}    = \&datestamp;
$amsubs{timestamp}    = \&timestamp;

$amsubs{make_link}         = \&make_link;

$amsubs{make_alfa_index}   = \&make_alfa_index;
$amsubs{make_alfa_welcome} = \&make_alfa_welcome;
$amsubs{make_alfa_coll}    = \&make_alfa_coll;
$amsubs{mk_amkcontent}     = \&mk_amkcontent;

$amsubs{play_cards}        = \&play_cards;
$amsubs{deal_cards}        = \&deal_cards;
$amsubs{encode_carta}      = \&encode_carta;
$amsubs{decode_carta}      = \&decode_carta;

$amsubs{mk_amtophtml}      = \&mk_amtophtml;

$amsubs{offer_translation} = \&offer_translation;

$amsubs{fix_accents}       = \&fix_accents;
$amsubs{make_lightdiff}    = \&make_lightdiff;

$amsubs{make_poetry}       = \&make_poetry;
$amsubs{make_namefield}    = \&make_namefield;
$amsubs{make_form_top}     = \&make_form_top;
$amsubs{make_form_bottom}  = \&make_form_bottom;

$amsubs{test_verb}         = \&test_verb;
$amsubs{test_noun}         = \&test_noun;
$amsubs{test_adj}          = \&test_adj;

$amsubs{get_random_word}   = \&get_random_word;

$amsubs{make_welcome_msg}  = \&make_welcome_msg;

##  store it all
nstore( { amsubs  => \%amsubs } , $otfile );  


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  À à  Â â
##  È è  Ê ê
##  Ì ì  Î î
##  Ò ò  Ô ô
##  Ù ù  Û û

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
## #  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## 
