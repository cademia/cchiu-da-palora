#!/usr/bin/env perl

##  "mk_aiutu-hashes.pl" -- converts Aiutami data into hashes
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
no warnings qw( uninitialized );

use Text::CSV_XS ; 
use Storable qw( retrieve ) ;
{   no warnings;  
    ## $Storable::Deparse = 1;  
    $Storable::Eval    = 1;  
}

#  ##  ##  ##  ##  ##  ##  ##  ##

##  input and output files
my $infile = "sicilian_2018-10-18_v1.csv";
my $otfile = "sicilian_2018-10-18_v1.pl";

##  retrieve aiutami list
my $amlsrf = retrieve('bkp-lib/aiutu-list_2018-10-18' );
my %amlist = %{ $amlsrf } ;

##  retrieve hashes and subroutines
my $vthash  = retrieve('../../cgi-lib/verb-tools' );
my $vbconj  = $vthash->{vbconj} ;
my $vbsref  = $vthash->{vbsubs} ;
my %vbsubs  = %{$vbsref} ;
my $nounpls = $vthash->{nounpls} ;

#  ##  ##  ##  ##  ##  ##  ##  ##

##  get column headings
open( INFILE , $infile ) || die "could not open $infile" ; 
chomp( my $header = <INFILE> ) ; 
close INFILE ; 
my @colnames = read_csv( $header ) ; 

##  open input and output files 
open( OTFILE , ">$otfile" ) || die "could not overwrite $otfile";
open( INFILE ,   $infile  ) || die "could not open $infile";
<INFILE> while $. < 1 ; 
while(<INFILE>){
    chomp;
    my $line = $_ ;

    ##  fix swedish
    $line =~ s/Ã /~aG~/g; 
    $line =~ s/Ã¨/~eG~/g; 
    $line =~ s/Ã¬/~iG~/g; 
    $line =~ s/Ã²/~oG~/g; 
    $line =~ s/Ã¹/~uG~/g; 

    ##  now read the CSV fields
    my @cols = read_csv($line) ;

    ##  fix swedish again
    s/~aG~/à/g for @cols;
    s/~eG~/è/g for @cols;
    s/~iG~/ì/g for @cols;
    s/~oG~/ò/g for @cols;
    s/~uG~/ù/g for @cols;

    ##  assign column names
    my %ch ; 
    foreach my $i (0..$#cols) {	
	$ch{ $colnames[$i] } = $cols[$i] ; 
    }

    ##  what's the word?  what's the part of speech?
    my $hkey = $ch{"palora"};

    my $display   = $amlist{$hkey}{palora};
    my $hashkey   = $amlist{$hkey}{hashkey};
    my $partsp    = $amlist{$hkey}{part_speech};
    my $dieli_en  = $amlist{$hkey}{dieli_en};
    my $dieli_it  = $amlist{$hkey}{dieli_it};

    ##  print out the hash
    print OTFILE "\n";
    print OTFILE '##  '. $ch{"index"} .' -- '. $ch{"timestamp"}  ."\n";
    print OTFILE '##  '. $ch{"name"}  ."\n";
    print OTFILE '##  '. $ch{"ip_address"} .' -- '. $ch{"user_agent"}  ."\n";
    if ($ch{"lost_cardgame"} ne "NULL") {
	    print OTFILE '##  '. 'LOST  CARDGAME'  ."\n";
    }
    
    if ( $partsp eq "verb" ) {
	my ( $ottxt , $pri_txt , $pai_txt , $pap_txt , $adj_txt ) = 
	    mk_vbhash( $display , $dieli_en , $dieli_it , $ch{"poetry"} , 
		       $ch{"vb_pri"}, $ch{"vb_pai"}, $ch{"vb_pap"}, $ch{"vb_adj"});

	print OTFILE '##  '."\n";
	print OTFILE '##    present:  '. $pri_txt ."\n";
	print OTFILE '##  preterite:  '. $pai_txt ."\n";
	print OTFILE '##  past part:  '. $pap_txt ."\n";
	print OTFILE '##  adjective:  '. $adj_txt ."\n";
	print OTFILE $ottxt ."\n";
	
    } elsif ( $partsp eq "noun" ) {
	my ( $ottxt , $plural ) = mk_nnhash( $display , $dieli_en , $dieli_it , $ch{"poetry"} , $hkey , $ch{"noun_plend"});
	print OTFILE '##  '."\n";
	print OTFILE '##  single:  '. $display ."\n";
	print OTFILE '##  plural:  '. $plural ."\n";
	print OTFILE $ottxt ."\n";
	
    } elsif ( $partsp eq "adj" ) {
	my ( $ottxt , $femsi ) = mk_ajhash( $display , $dieli_en , $dieli_it , $ch{"poetry"} , $ch{"adj_femsi"});
	print OTFILE '##  '."\n";
	print OTFILE '##  fem. form:  '. $femsi ."\n";
	print OTFILE $ottxt ."\n";
	
    } else {
	my $ottxt = mk_othash( $display , $dieli_en , $dieli_it , $ch{"poetry"} , $partsp );
	print OTFILE $ottxt ."\n";
    }
    
    print OTFILE "\n";
    print OTFILE '##  ##  ##  ##  ##  ##  ##  ##  ##' ."\n";
    print OTFILE '##  ##  ##  ##  ##  ##  ##  ##  ##' ."\n";
    print OTFILE "\n";
}
close INFILE ;
close OTFILE ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  "index","timestamp","ip_address","user_agent","lost_cardgame","palora","name",
##  "vb_pri","vb_pai","vb_pap","vb_adj","noun_plend","adj_femsi","poetry"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

##  extract fields from a CSV line
sub read_csv {
    
    my $line = $_[0] ; 

    my $csv = Text::CSV_XS->new() ; 
    $csv->parse( $line ) ; 
    my @fields = $csv->fields() ; 
    
    return @fields ; 
}

##  create CSV string
sub write_csv {

    my @cols = @_ ; 

    my $csv = Text::CSV_XS->new;
    $csv->combine (@cols) ;
    my $string = $csv->string ; 

    return $string ; 
}

##  ##  ##  ##  ##  ##  ##  ##  ##

##  create verb hash
sub mk_vbhash {

    my $dieli    = $_[0];
    my @dieli_en = split( ', ', $_[1] );
    my @dieli_it = split( ', ', $_[2] );

    my $poetry   = $_[3];
    $poetry =~ s/\n/","/g;
    
    my $vb_pri = $_[4];  my $pri_txt;
    my $vb_pai = $_[5];  my $pai_txt;
    my $vb_pap = $_[6];  my $pap_txt;
    my $vb_adj = $_[7];  my $adj_txt;

    ##  hold onto these 
    my $conj = $vb_pri ; 
    $conj =~ s/^PRI_conj_//;
    $conj =~ s/_stem_.*_boot_.*$//;

    my $stem_pri = $vb_pri ; 
    $stem_pri =~ s/^PRI_conj_.*_stem_//;
    $stem_pri =~ s/_boot_.*$//;

    my $boot_pri = $vb_pri ; 
    $boot_pri =~ s/^PRI_conj_.*_stem_.*_boot_//;

    ##  prepare output text
    my $ottxt ;
    $ottxt .= "\n";
    $ottxt .= '##  ##  ##  ##  ##  ##  ##  ##  ##' . "\n";
    $ottxt .= "\n";
    ##$ottxt .= '##  ##  ' . $dieli . ' -- Aiùtami hash' . "\n";
    $ottxt .= '%{ $vnotes{"' . $dieli . '"} } = (' . "\n";
    $ottxt .= '    ##  display_as => "' . $dieli . '",' . "\n";
    $ottxt .= '    dieli => ["' . $dieli . '",],' . "\n";
    $ottxt .= '    dieli_en => ['; 
    foreach my $listing (@dieli_en) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    $ottxt .= '    dieli_it => ['; 
    foreach my $listing (@dieli_it) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    if ( $poetry ne "NULL" ) {
	$ottxt .= '    notex => ["'. $poetry .'",],' . "\n";
    } else {
	$ottxt .= '    ##  notex => ["","",],' . "\n";
    }
    $ottxt .= '    part_speech => "verb",' . "\n";
   
    $ottxt .= '    verb => {' . "\n";

    if ( $vb_pri eq "PRI_Nudda" || $vb_pri eq "PRI_NunSacciu" || $vb_pri eq "PRI_NunRigulari" || 
	 $vb_pri eq "NULL" || $vb_pri eq "invalid" ) {
	$ottxt .= ' 	##  conj => "' . "" . '",' . "\n";
	$ottxt .= ' 	##  stem => "' . "" . '",' ."\n";
	$ottxt .= ' 	##  boot => "' . "" . '",' ."\n";
    } else {
	$ottxt .= ' 	conj => "' . $conj . '",' . "\n";
	$ottxt .= ' 	stem => "' . $stem_pri . '",' ."\n";
	$ottxt .= ' 	boot => "' . $boot_pri . '",' ."\n";
    }

    $ottxt .= ' 	irrg => {' . "\n";
    ##  $ottxt .= '##  	    ##  inf => "",' . "\n";

    ##  PRI -- present
    if ( $vb_pri eq "PRI_Nudda" || $vb_pri eq "PRI_NunSacciu" || $vb_pri eq "PRI_NunRigulari" || 
	 $vb_pri eq "NULL" || $vb_pri eq "invalid" ) {

	( $pri_txt = $vb_pri ) =~ s/PRI_//; 
	$ottxt .= '	    ##  pri => { us => "", ds => "", ts => "", up => "", dp => "", tp => ""},' . "\n";
	
    } else {
	my %protos ; 
	%{$protos{"proto_pri"}} = ( 
	    part_speech => "verb",
	    verb => { conj => $conj, stem => $stem_pri,  boot => $boot_pri, },
	    );
	my %qkconj = $vbsubs{conjugate}( "proto_pri" , \%protos , $vbconj , $vbsref ) ; 
	
	$pri_txt = "Iu ". $qkconj{pri}{us} .". Nuatri ". $qkconj{pri}{up} ."."; 
    }

    ## $ottxt .= '##  	    ##  pim => { ds => "", ts => "", up => "", dp => "", tp => ""},' . "\n";

    ##  PAI -- preterite
    if ( $vb_pai eq "PAI_Nudda" || $vb_pai eq "PAI_NunSacciu" || $vb_pai eq "PAI_NunRigulari" || 
	 $vb_pai eq "NULL" || $vb_pai eq "invalid" ) {

	( $pai_txt = $vb_pai ) =~ s/PAI_//;	
	$ottxt .= '##  	    pai => { quad = ""},' . "\n";
	
    } else {

	my $conj_pai = $vb_pai ; 
	$conj_pai =~ s/^PAI_conj_//;
	$conj_pai =~ s/_stem_.*$//;

	my $stem_pai = $vb_pai ; 
	$stem_pai =~ s/^PAI_conj_.*_stem_//;

	my %protos ; 
	%{$protos{"proto_pai"}} = ( 
	    part_speech => "verb",
	    verb => { conj => $conj_pai, stem => $stem_pai,  boot => "xxx", },
	    );
	my %qkconj = $vbsubs{conjugate}( "proto_pai" , \%protos , $vbconj , $vbsref ) ; 
	
	$pai_txt = "Iu ". $qkconj{pai}{us} .". Tu ". $qkconj{pai}{ds} ."."; 

	if ( $stem_pai ne $stem_pri ) {
	    $ottxt .= '##  	    pai => { quad = "'. $stem_pai  .'"},' . "\n";
	}
    }

    ## $ottxt .= '##  	    ##  imi => { us => "", ds => "", ts => "", up => "", dp => "", tp => ""},' . "\n";
    ## $ottxt .= '##  	    ##  ims => { us => "", ds => "", ts => "", up => "", dp => "", tp => ""},' . "\n";
    ## $ottxt .= '##  	    ##  fti => { stem => ""},' . "\n";
    ## $ottxt .= '##  	    ##  coi => { stem => ""},' . "\n";

    ##  PAP -- past participle
    if ( $vb_pap eq "PAP_Nudda" || $vb_pap eq "PAP_NunSacciu" || $vb_pap eq "PAP_NunRigulari" || 
	 $vb_pap eq "NULL" || $vb_pap eq "invalid" ) {

	( $pap_txt = $vb_pap ) =~ s/PAP_//; 
	$ottxt .= '	    ##  pap => "",' . "\n";
	
    } else {

	my $conj_pap = $vb_pap ; 
	$conj_pap =~ s/^PAP_conj_//;
	$conj_pap =~ s/_stem_.*$//;

	my $stem_pap = $vb_pap ; 
	$stem_pap =~ s/^PAP_conj_.*_stem_//;

	my %protos ; 
	%{$protos{"proto_pap"}} = ( 
	    part_speech => "verb",
	    verb => { conj => $conj_pap, stem => $stem_pap,  boot => "xxx", },
	    );
	my %qkconj = $vbsubs{conjugate}( "proto_pap" , \%protos , $vbconj , $vbsref ) ; 
	
	$pap_txt = "aviri ". $qkconj{pap} ."."; 

	if ( $stem_pap ne $stem_pri ) {
	    $ottxt .= '	    ##  pap => "'. $stem_pap  .'",' . "\n";
	}	
    }

    ##  ADJ -- adjective
    if ( $vb_adj eq "ADJ_Nudda" || $vb_adj eq "ADJ_NunSacciu" || $vb_adj eq "ADJ_NunRigulari" ||
	 $vb_adj eq "NULL" || $vb_adj eq "invalid" ) {

	( $adj_txt = $vb_adj ) =~ s/ADJ_//; 
	$ottxt .= '	    ##  adj => "",' . "\n";

    } else {

	my $conj_adj = $vb_adj ; 
	$conj_adj =~ s/^ADJ_conj_//;
	$conj_adj =~ s/_stem_.*$//;

	my $stem_adj = $vb_adj ; 
	$stem_adj =~ s/^ADJ_conj_.*_stem_//;

	
	my %protos ; 
	%{$protos{"proto_adj"}} = ( 
	    part_speech => "verb",
	    verb => { conj => $conj_adj, stem => $stem_adj,  boot => "xxx", },
	    );
	my %qkconj = $vbsubs{conjugate}( "proto_adj" , \%protos , $vbconj , $vbsref ) ; 
	
	( my $qkadj = $qkconj{adj} ) =~ s/u$/a/;
	
	$adj_txt = "una cosa ". $qkadj ."."; 

	if ( $stem_adj ne $stem_pri ) {
	    $ottxt .= '	    ##  adj => "'. $stem_adj  .'",' . "\n";
	}	
    }
    
    $ottxt .= ' 	},' . "\n";
    $ottxt .= '     },);' . "\n";


    my $rid_irrg = ' 	irrg => \{' ."\n". ' 	\},' ."\n";
    $ottxt =~ s/$rid_irrg//;
    
    return( $ottxt , $pri_txt , $pai_txt , $pap_txt , $adj_txt ); 
}

##  ##  ##  ##  ##  ##  ##  ##  ##

###  create reflexive verb hash
#sub mk_rvhash {
#    
#    my $dieli    = $_[0]   ;
#    ( my $nonrv = $dieli ) =~ s/si$// ;
#
#    my @dieli_en = split( ', ', $_[1] );
#    my @dieli_it = split( ', ', $_[2] );
#
#    my $ottxt ;
#    $ottxt .= "\n";
#    $ottxt .= '##  ##  ##  ##  ##  ##  ##  ##  ##' . "\n";
#    $ottxt .= "\n";
#    ##$ottxt .= '##  ##  ' . $dieli . ' -- Aiùtami hash' . "\n";
#    $ottxt .= '%{ $vnotes{"' . $dieli . '"} } = (' . "\n";
#    $ottxt .= '    dieli => ["' . $dieli . '"],' . "\n";
#    $ottxt .= '    dieli_en => ['; 
#    foreach my $listing (@dieli_en) { $ottxt .= '"' . $listing . '",';};
#    $ottxt .= '],' . "\n";
#    $ottxt .= '    dieli_it => ['; 
#    foreach my $listing (@dieli_it) { $ottxt .= '"' . $listing . '",';};
#    $ottxt .= '],' . "\n";
#    $ottxt .= '    part_speech => "verb",' . "\n";
#    $ottxt .= '    reflex => "' . $nonrv . '",' . "\n";
#    $ottxt .= '    );' . "\n";
#    return $ottxt ;
#}

##  ##  ##  ##  ##  ##  ##  ##  ##

##  create noun hash
sub mk_nnhash {

    my $dieli    = $_[0]   ;
    my @dieli_en = split( ', ', $_[1] );
    my @dieli_it = split( ', ', $_[2] );

    my $poetry   = $_[3];
    $poetry =~ s/\n/","/g;

    my $hkey = $_[4];
    my $ngp  = $_[5];

    ##  gender from Dieli
    my $gender = $amlist{$hkey}{noun}{gender};

    ##  holder for plural
    my $plural_txt ;
    
    my $ottxt ;
    $ottxt .= "\n";
    $ottxt .= '##  ##  ##  ##  ##  ##  ##  ##  ##' . "\n";
    $ottxt .= "\n";
    ##$ottxt .= '##  ##  ' . $dieli . ' -- Aiùtami hash' . "\n";
    $ottxt .= '%{ $vnotes{"' . $dieli . '_noun"} } = (' . "\n";
    $ottxt .= '    display_as => "' . $dieli . '",' . "\n";
    $ottxt .= '    dieli => ["' . $dieli . '",],' . "\n";
    $ottxt .= '    dieli_en => ['; 
    foreach my $listing (@dieli_en) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    $ottxt .= '    dieli_it => ['; 
    foreach my $listing (@dieli_it) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    if ( $poetry ne "NULL" ) {
	$ottxt .= '    notex => ["'. $poetry .'",],' . "\n";
    } else {
	$ottxt .= '    ##  notex => ["","",],' . "\n";
    }
    $ottxt .= '    part_speech => "noun",' . "\n";
    
    
    if ( $ngp eq "PLEND_Nudda" || $ngp eq "PLEND_NunSacciu" || $ngp eq "PLEND_NunRigulari" || 
	 $ngp eq "NULL" || $ngp eq "invalid" ) {

	( $plural_txt = $ngp ) =~ s/^PLEND_//;
	
	$ottxt .= '    noun => {' . "\n";
	$ottxt .= '	gender => "' . $gender . '",' . "\n";
	$ottxt .= '	##  plend => "'  . "" . '",' . "\n";
	$ottxt .= '##  	##  plural => "",' . "\n";
	$ottxt .= '    },);' . "\n";

    } else {

	##  gender from Aiutami (itself taken from Dieli)
	my $gender_ngp = $ngp ; 
	$gender_ngp =~ s/^PLEND_gender_//;
	$gender_ngp =~ s/_plend_.*$//;

	##  plend from Aiutami
	my $plend_ngp  = $ngp ;
	$plend_ngp =~ s/^PLEND_gender_.*_plend_//;

	$plural_txt = $vbsubs{mk_noun_plural}( $dieli , $gender , $plend_ngp , $nounpls );

	##  use gender from Dieli and plend from Aiutami
	$ottxt .= '    noun => {' . "\n";
	$ottxt .= ' 	gender => "' . $gender . '",' . "\n";
	$ottxt .= ' 	plend => "'  . $plend_ngp  . '",' . "\n";
	$ottxt .= ' 	##  plural => "",' . "\n";
	$ottxt .= '    },);' . "\n";
    }    
    
    return( $ottxt , $plural_txt ); 
}

##  ##  ##  ##  ##  ##  ##  ##  ##

##  create adjective hash
sub mk_ajhash {

    my $dieli    = $_[0];
    my @dieli_en = split( ', ', $_[1] );
    my @dieli_it = split( ', ', $_[2] );

    my $poetry   = $_[3];
    $poetry =~ s/\n/","/g;
    
    my $femsi    = $_[4];

    ##  holder for femsi form
    my $femsi_form ;
    
    my $ottxt ;
    $ottxt .= "\n";
    $ottxt .= '##  ##  ##  ##  ##  ##  ##  ##  ##' . "\n";
    $ottxt .= "\n";
    ##$ottxt .= '##  ##  ' . $dieli . ' -- Aiùtami hash' . "\n";
    $ottxt .= '%{ $vnotes{"' . $dieli . '_adj"} } = (' . "\n";
    $ottxt .= '    display_as => "' . $dieli . '",' . "\n";
    $ottxt .= '    dieli => ["' . $dieli . '",],' . "\n";
    $ottxt .= '    dieli_en => ['; 
    foreach my $listing (@dieli_en) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    $ottxt .= '    dieli_it => ['; 
    foreach my $listing (@dieli_it) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    if ( $poetry ne "NULL" ) {
	$ottxt .= '    notex => ["'. $poetry .'",],' . "\n";
    } else {
	$ottxt .= '    ##  notex => ["","",],' . "\n";
    }    
    $ottxt .= '    part_speech => "adj",' . "\n";

    
    if ( $femsi eq "FEMSI_Nudda" || $femsi eq "FEMSI_NunSacciu" || $femsi eq "FEMSI_NunRigulari" ||
	 $femsi eq "NULL" || $femsi eq "invalid" ) {

	( $femsi_form = $femsi ) =~ s/FEMSI_// ;

	$ottxt .= '    adj => {' . "\n";
	$ottxt .= '	##  femsi => "' . "" . '",' . "\n";
	$ottxt .= '##  	##  invariant => 1,' . "\n";
	$ottxt .= '##  	##  may_precede => 1,' . "\n";
	$ottxt .= '##  	##  massi_precede => "' . ""  . '",' . "\n";
	$ottxt .= '    },);' . "\n";
    } else {
	( $femsi_form = $femsi ) =~ s/FEMSI_// ;
	
	$ottxt .= '    adj => {' . "\n";
	$ottxt .= '	femsi => "'    . $femsi_form . '",' . "\n";
	$ottxt .= '    },);' . "\n";
    }

    return( $ottxt , $femsi_form ); 
}

##  ##  ##  ##  ##  ##  ##  ##  ##

##  create other hash
sub mk_othash {

    my $dieli    = $_[0];
    my @dieli_en = split( ', ', $_[1] );
    my @dieli_it = split( ', ', $_[2] );

    my $poetry   = $_[3];
    $poetry =~ s/\n/","/g;
    
    my $sc_part  = $_[4];
    
    my $ottxt ;
    $ottxt .= "\n";
    $ottxt .= '##  ##  ##  ##  ##  ##  ##  ##  ##' . "\n";
    $ottxt .= "\n";
    ##$ottxt .= '##  ##  ' . $dieli . ' -- Aiùtami hash' . "\n";
    $ottxt .= '%{ $vnotes{"' . $dieli . '_' . $sc_part  . '"} } = (' . "\n";
    $ottxt .= '    display_as => "' . $dieli . '",' . "\n";
    $ottxt .= '    dieli => ["' . $dieli . '",],' . "\n";
    $ottxt .= '    dieli_en => ['; 
    foreach my $listing (@dieli_en) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    $ottxt .= '    dieli_it => ['; 
    foreach my $listing (@dieli_it) { $ottxt .= '"' . $listing . '",';};
    $ottxt .= '],' . "\n";
    if ( $poetry ne "NULL" ) {
	$ottxt .= '    notex => ["'. $poetry .'",],' . "\n";
    } else {
	$ottxt .= '    ##  notex => ["","",],' . "\n";
    }  
    $ottxt .= '    part_speech => "' . $sc_part . '",' . "\n";
    $ottxt .= '    );' . "\n";
    
    return $ottxt ; 
}
