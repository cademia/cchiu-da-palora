#!/usr/bin/env perl

##  "mk_dieli-edits.pl" -- edits the Dieli dictionary
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
use Storable qw( retrieve nstore ) ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  list of Dieli hashes
my $dieli_sc_dict = '../cgi-lib/dieli-sc-dict' ; 
my $dieli_en_dict = '../cgi-lib/dieli-en-dict' ; 
my $dieli_it_dict = '../cgi-lib/dieli-it-dict' ; 

##  retrieve SiCilian
my %dieli_sc = %{ retrieve( $dieli_sc_dict ) } ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  HOMONYMS
##  ========

##  $ ./query-dieli.pl sc viviri
##  	0  ==  viviri {v} --> bere {v} --> drink {v}
##  	1  ==  viviri {v} --> vivere {v} --> live {v}
##  
${$dieli_sc{"viviri"}[0]}{"linkto"} = "viviri_drink";
${$dieli_sc{"viviri"}[1]}{"linkto"} = "viviri_live";


##  $ ./query-dieli.pl sc strittu corpu 
##  
##  	0  ==  corpu {m} --> colpo {m} --> blow {n}
##  	1  ==  corpu {m} --> corpo {m} --> body {n}
##  	2  ==  corpu {m} --> colpo {m} --> bump {n}
##  	3  ==  corpu {} --> <br> {} --> corpus {}
##  	4  ==  corpu {} --> colpo {} --> hit {}
##  	5  ==  corpu {m} --> <br> {m} --> shot {n}
##  	6  ==  corpu {m} --> colpo {m} --> stroke {n}
${$dieli_sc{"corpu"}[0]}{"linkto"} = "corpu_blow";
${$dieli_sc{"corpu"}[1]}{"linkto"} = "corpu_body";
${$dieli_sc{"corpu"}[2]}{"linkto"} = "corpu_blow";
${$dieli_sc{"corpu"}[3]}{"linkto"} = "corpu_body";
${$dieli_sc{"corpu"}[4]}{"linkto"} = "corpu_blow";
${$dieli_sc{"corpu"}[5]}{"linkto"} = "corpu_blow";
${$dieli_sc{"corpu"}[6]}{"linkto"} = "corpu_blow";

${$dieli_sc{"corpu"}[3]}{"sc_part"} = '{m}';
${$dieli_sc{"corpu"}[3]}{"en_part"} = '{n}';
${$dieli_sc{"corpu"}[4]}{"sc_part"} = '{m}';
${$dieli_sc{"corpu"}[4]}{"it_part"} = '{m}';
${$dieli_sc{"corpu"}[4]}{"en_part"} = '{n}';
${$dieli_sc{"corpu"}[5]}{"it_part"} = '{}';

##  $ ./query-dieli.pl sc strittu amuri
##  	0  ==  amuri {f} --> mora {f} --> blackberry {n}
##  	1  ==  amuri {m} --> amore {m} --> love {n}
${$dieli_sc{"amuri"}[0]}{"linkto"} = "amuri_blackberry";
${$dieli_sc{"amuri"}[1]}{"linkto"} = "amuri_love";

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  ADJECTIVES
##  ==========

##  $ ./query-dieli.pl sc strittu giuvina
##  	0  ==  giuvina {adj} --> giovanotta {adj} --> young boy {adj}
${$dieli_sc{"giuvina"}[0]}{"en_word"} = 'young girl';
${$dieli_sc{"giuvina"}[0]}{"en_part"} = '{n}';

##  $ ./query-dieli.pl sc strittu giuvini 
##  	0  ==  giuvini {adj} --> giovanotto {adj} --> young boy {adj}
${$dieli_sc{"giuvini"}[0]}{"en_part"} = '{n}';

##  $ ./query-dieli.pl sc strittu pèggiu
## 	0  ==  pèggiu {adj} --> <br> {adj} --> bad {adj}
## 	1  ==  pèggiu {} --> <br> {} --> worse {}
## 	2  ==  pèggiu {adj} --> peggio {adj} --> worse {adj}
## 	3  ==  pèggiu {adv} --> peggio {adv} --> worse {adv}
${$dieli_sc{"pèggiu"}[0]}{"it_part"} = '{}';
${$dieli_sc{"pèggiu"}[1]}{"sc_part"} = '{adj}';
${$dieli_sc{"pèggiu"}[1]}{"en_part"} = '{adj}';

##  $ ./query-dieli.pl sc strittu 'u pèggiu'
## 	0  ==  u pèggiu {} --> <br> {} --> worse {n}
## 	1  ==  u pèggiu {adj} --> <br> {adj} --> worst {adj}
## 	2  ==  u pèggiu {} --> <br> {} --> worst {n}
${$dieli_sc{"u pèggiu"}[0]}{"sc_part"} = '{adj}';
${$dieli_sc{"u pèggiu"}[1]}{"it_word"} = 'il peggiore';
${$dieli_sc{"u pèggiu"}[2]}{"sc_part"} = '{adj}';

##  $ ./query-dieli.pl sc strittu 'u peggiu'
##  	0  ==  u peggiu {} --> <br> {} --> the worst {}
##  	1  ==  u peggiu {adj} --> pessimo {adj} --> worst {adj}
${$dieli_sc{"u peggiu"}[0]}{"sc_part"} = '{adj}';

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  NOUNS
##  =====

##  $ ./query-dieli.pl sc strittu jardinu 
##  	0  ==  jardinu {} --> giardino {} --> garden {}
${$dieli_sc{"jardinu"}[0]}{"sc_part"} = '{m}';
${$dieli_sc{"jardinu"}[0]}{"it_part"} = '{m}';
${$dieli_sc{"jardinu"}[0]}{"en_part"} = '{n}';

## $ ./query-dieli.pl sc strittu pizzu
## 	0  ==  pizzu {m} --> becco {m} --> beak {n}
## 	1  ==  pizzu {m} --> bustarella {f} --> bribe {n}
## 	2  ==  pizzu {f} --> vetta {f} --> peak {n}
${$dieli_sc{"pizzu"}[2]}{"sc_part"} = '{m}';

## $ ./query-dieli.pl sc strittu beccu
## 	0  ==  beccu {} --> <br> {} --> beak {}
## 	1  ==  beccu {m} --> becco {m} --> beak {n}
## 	2  ==  beccu {n} --> corna {n} --> cuckold {n}
## 	3  ==  beccu {m} --> becco {m} --> nozzle {n}
## 	4  ==  beccu {m} --> <br> {m} --> spout {n}
${$dieli_sc{"beccu"}[0]}{"sc_part"} = '{m}';
${$dieli_sc{"beccu"}[0]}{"en_part"} = '{n}';
${$dieli_sc{"beccu"}[2]}{"sc_part"} = '{m}';

## $ ./query-dieli.pl sc strittu tabbaccaru
## 	0  ==  tabbaccaru {f} --> tabaccheria {f} --> cigar shop {n}
${$dieli_sc{"tabbaccaru"}[0]}{"sc_part"} = '{m}';

## $ ./query-dieli.pl sc strittu vasuni
## 	0  ==  vasuni {m} --> bacio {m} --> kiss {n}
## 	1  ==  vasuni {f} --> <br> {f} --> smack (kiss) {n}
${$dieli_sc{"vasuni"}[1]}{"sc_part"} = '{m}';

## $ ./query-dieli.pl sc strittu voscu
## 	0  ==  voscu {m} --> bosco {m} --> forest {n}
## 	1  ==  voscu {m} --> parco {m} --> park {n}
## 	2  ==  voscu {m} --> bosco {m} --> wood {n}
## 	3  ==  voscu {p} --> <br> {} --> woods {n}
${$dieli_sc{"voscu"}[3]}{"sc_part"} = '{m}';

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  EXAMPLES of VERBS
##  ======== == =====

##  $ ./query-dieli.pl sc pari
##  	0  ==  pari {} --> manifesta {} --> be revealed {}
##  	1  ==  pari {v} --> <br> {v} --> seem {v}
##  	2  ==  pari {} --> <br> {} --> show {}
##  
{ my $search = "pari" ; 
  foreach my $index (0..2) {
      $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
      ${$dieli_sc{$search}[$index]}{"linkto"} = "pàriri" ;
  }
}

##  $ ./query-dieli.pl sc vèstiti 
##  	0  ==  vèstiti {v} --> <br> {v} --> dress {v}
##  	1  ==  vèstiti {} --> <br> {} --> dress up {}
##  	2  ==  vèstiti {v} --> <br> {} --> put on clothing {v}
##  
{ my $search = "vèstiti" ; 
  foreach my $index (0..2) {
      $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
      ${$dieli_sc{$search}[$index]}{"linkto"} = "vistirisi" ;
  }
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  VERBS
##  =====

##  $ ./query-dieli.pl sc allungari
##  	0  ==  allungari {} --> allongare {} --> defer {}
##  	1  ==  allungari {} --> farsene {} --> defer {}
##  	3  ==  allungari {} --> allongare {} --> lengthen {}
##  	4  ==  allungari {} --> farsene {} --> lengthen {}
##  	5  ==  allungari {} --> allungare {} --> prolong {}
##  
foreach my $index (0,1,3,4,5) { 
    my $search = "allungari" ; 
    $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc chiùdiri 
##  	0  ==  chiùdiri {} --> chiudere {} --> close {}
##  
{ my $search = "chiùdiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc perdiri
##  	0  ==  perdiri {} --> perdere {} --> lose {}
##  
{ my $search = "perdiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc veniri
##  	0  ==  veniri {} --> <br> {} --> arrive {}
## 
{ my $search = "veniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc viviri
##  	1  ==  viviri {} --> vivere {} --> live {}
##  
{ my $search = "viviri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vuliri
##  	0  ==  vuliri {} --> volere {} --> want {}
##  
{ my $search = "vuliri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  


##  $ ./query-dieli.pl sc abbagnari
##  	0  ==  abbagnari {} --> pucciare {} --> wet {}
##  
{ my $search = "abbagnari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbasiliscari
##  	0  ==  abbasiliscari {} --> trasecolare {} --> be dumbfounded {}
##  
{ my $search = "abbasiliscari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbastari
##  	0  ==  abbastari {} --> bastare {} --> be enough {}
##  
{ my $search = "abbastari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbianchiari
##  	0  ==  abbianchiari {} --> imbiancare {} --> whiten {}
##  
{ my $search = "abbianchiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbijari
##  	0  ==  abbijari {} --> avviare {} --> lead {}
##  
{ my $search = "abbijari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbinnari
##  	0  ==  abbinnari {vf} --> bendare {v} --> blindfold {v}
##  
{ my $search = "abbinnari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbuffuniari
##  	0  ==  abbuffuniari {} --> prendere in giro {} --> make fun of {}
##  
{ my $search = "abbuffuniari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbuffuniari
##  	1  ==  abbuffuniari {} --> prendere in giro {} --> string along {}
##  
{ my $search = "abbuffuniari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbàttiri
##  	0  ==  abbàttiri {} --> abbattere {} --> defeat {}
##  
{ my $search = "abbàttiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbàttiri
##  	1  ==  abbàttiri {} --> sconfiggere {} --> defeat {}
##  
{ my $search = "abbàttiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbàttiri
##  	2  ==  abbàttiri {} --> abbattere {} --> knock down {}
##  
{ my $search = "abbàttiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc abbàttiri
##  	3  ==  abbàttiri {} --> sconfiggere {} --> knock down {}
##  
{ my $search = "abbàttiri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accalari
##  	0  ==  accalari {} --> abbassare {} --> lower {}
##  
{ my $search = "accalari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accalarisi
##  	0  ==  accalarisi {} --> abbassarsi {} --> lower oneself {}
##  
{ my $search = "accalarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accalarisi
##  	1  ==  accalarisi {} --> abbassarsi {} --> stoop {}
##  
{ my $search = "accalarisi" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accanzari
##  	2  ==  accanzari {} --> ottenere {} --> obtain {}
##  
{ my $search = "accanzari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accapari
##  	1  ==  accapari {} --> finire {} --> finish {v}
##  
{ my $search = "accapari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accapari
##  	2  ==  accapari {} --> terminare {} --> finish {v}
##  
{ my $search = "accapari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accaparrari
##  	0  ==  accaparrari {} --> abbrancare {} --> grasp {}
##  
{ my $search = "accaparrari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accaparrari
##  	1  ==  accaparrari {} --> afferrare {} --> grasp {}
##  
{ my $search = "accaparrari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accaparrari
##  	2  ==  accaparrari {} --> abbrancare {} --> seize {}
##  
{ my $search = "accaparrari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accucchiari
##  	0  ==  accucchiari {} --> abbinare {} --> bring together {}
##  
{ my $search = "accucchiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accucchiari
##  	1  ==  accucchiari {} --> accoppiare {} --> bring together {}
##  
{ my $search = "accucchiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accucchiari
##  	2  ==  accucchiari {} --> accoppiare {} --> match {}
##  
{ my $search = "accucchiari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accuminciari
##  	0  ==  accuminciari {} --> cominciare {} --> begin {}
##  
{ my $search = "accuminciari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accuminzari
##  	0  ==  accuminzari {} --> cominciare {v} --> begin {v}
##  
{ my $search = "accuminzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accuminzari
##  	1  ==  accuminzari {} --> <br> {} --> commence {}
##  
{ my $search = "accuminzari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accurdari
##  	3  ==  accurdari {} --> <br> {} --> pacify {}
##  
{ my $search = "accurdari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accurdari
##  	6  ==  accurdari {} --> accordare {} --> tune an instrument {}
##  
{ my $search = "accurdari" ; my $index = 6 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accurdunari
##  	0  ==  accurdunari {} --> cingere {} --> encircle {}
##  
{ my $search = "accurdunari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc accurdunari
##  	2  ==  accurdunari {} --> cingere {} --> surround {}
##  
{ my $search = "accurdunari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addicchiarari
##  	0  ==  addicchiarari {} --> richiedere {} --> appoint {}
##  
{ my $search = "addicchiarari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addicchiarari
##  	1  ==  addicchiarari {} --> dichiarare {} --> certify {}
##  
{ my $search = "addicchiarari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addicchiarari
##  	2  ==  addicchiarari {} --> dichiarare {} --> declare {}
##  
{ my $search = "addicchiarari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addicchiarari
##  	3  ==  addicchiarari {} --> dichiarare {} --> profess {}
##  
{ my $search = "addicchiarari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addifènniri
##  	0  ==  addifènniri {} --> difendere {} --> defend {}
##  
{ my $search = "addifènniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addifènniri
##  	1  ==  addifènniri {} --> difendere {} --> protect {}
##  
{ my $search = "addifènniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addifènniri
##  	2  ==  addifènniri {} --> difendere {} --> stand up for {}
##  
{ my $search = "addifènniri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addimurari
##  	0  ==  addimurari {} --> ritardare {} --> be late {}
##  
{ my $search = "addimurari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addipìnciri
##  	0  ==  addipìnciri {n} --> dipingere {} --> depict {}
##  
{ my $search = "addipìnciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addipìnciri
##  	1  ==  addipìnciri {} --> dipingere {} --> paint {}
##  
{ my $search = "addipìnciri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addiscìnniri
##  	0  ==  addiscìnniri {} --> discendere {} --> descend {}
##  
{ my $search = "addiscìnniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addisiari
##  	1  ==  addisiari {} --> <br> {} --> want {}
##  
{ my $search = "addisiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addisiari
##  	3  ==  addisiari {} --> <br> {} --> yearn {}
##  
{ my $search = "addisiari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addivirtirisi
##  	2  ==  addivirtirisi {} --> divertirsi {} --> have fun {}
##  
{ my $search = "addivirtirisi" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc addumari
##  	1  ==  addumari {} --> accendere {} --> light (turn on a) {}
##  
{ my $search = "addumari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc affrigiri
##  	0  ==  affrigiri <br> --> affliggersi {v} --> grieve {v}
##  
{ my $search = "affrigiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc aggarrari
##  	0  ==  aggarrari {} --> acciuffare {} --> catch {}
##  
{ my $search = "aggarrari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc aggarrari
##  	1  ==  aggarrari {} --> afferrare {} --> catch {}
##  
{ my $search = "aggarrari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc aggarrari
##  	2  ==  aggarrari {} --> acciuffare {} --> grasp {}
##  
{ my $search = "aggarrari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc aggarrari
##  	3  ==  aggarrari {} --> afferrare {} --> grasp {}
##  
{ my $search = "aggarrari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc aggarrari
##  	4  ==  aggarrari {} --> acciuffare {} --> seize {}
##  
{ my $search = "aggarrari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc aggarrari
##  	5  ==  aggarrari {} --> afferrare {} --> seize {}
##  
{ my $search = "aggarrari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc agghiuriscari
##  	0  ==  agghiuriscari {} --> domare {} --> subdue {}
##  
{ my $search = "agghiuriscari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc aggiri
##  	1  ==  aggiri {vi} --> agire {vi} --> behave {vi}
##  
{ my $search = "aggiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc agguantari
##  	2  ==  agguantari {} --> stringere con la mano {} --> squeeze with the hands {}
##  
{ my $search = "agguantari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc aghhiùttiri
##  	0  ==  aghhiùttiri {} --> inghiottire {} --> swallow {}
##  
{ my $search = "aghhiùttiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc agnunari
##  	0  ==  agnunari {} --> accantonare {} --> corner {}
##  
{ my $search = "agnunari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc agnunari
##  	1  ==  agnunari {} --> mettere in un angolo {} --> corner {}
##  
{ my $search = "agnunari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc allavancari
##  	0  ==  allavancari {} --> crollare {} --> break down {}
##  
{ my $search = "allavancari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc allavancari
##  	1  ==  allavancari {} --> rovinare {} --> cave in {}
##  
{ my $search = "allavancari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc allazzari
##  	0  ==  allazzari {} --> allacciare {} --> fasten {}
##  
{ my $search = "allazzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc allazzari
##  	1  ==  allazzari {} --> allacciare {} --> tie {}
##  
{ my $search = "allazzari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc allisciari
##  	0  ==  allisciari {} --> accarezzare {} --> caress {}
##  
{ my $search = "allisciari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc allisciari
##  	1  ==  allisciari {} --> accarezzare {} --> pet {v}
##  
{ my $search = "allisciari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc alluntanari
##  	0  ==  alluntanari {} --> <br> {} --> move away from {}
##  
{ my $search = "alluntanari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc amari
##  	0  ==  amari {} --> amare {} --> love {v}
##  
{ my $search = "amari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc amari
##  	1  ==  amari {} --> <br> {} --> prefer {}
##  
{ my $search = "amari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ambintarisi
##  	0  ==  ambintarisi {} --> ambientarsi {} --> calm down {}
##  
{ my $search = "ambintarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ambintarisi
##  	1  ==  ambintarisi {} --> calmarsi {} --> calm down {}
##  
{ my $search = "ambintarisi" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ambintarisi
##  	2  ==  ambintarisi {} --> riposare {} --> calm down {}
##  
{ my $search = "ambintarisi" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammaccari
##  	0  ==  ammaccari {} --> ammaccare {} --> bruise {}
##  
{ my $search = "ammaccari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammaccari
##  	1  ==  ammaccari {} --> premere {} --> bruise {}
##  
{ my $search = "ammaccari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammaistrari
##  	1  ==  ammaistrari {} --> istruire {} --> teach {}
##  
{ my $search = "ammaistrari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammaistrari
##  	2  ==  ammaistrari {} --> istruire {} --> train {}
##  
{ my $search = "ammaistrari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammarazzari
##  	4  ==  ammarazzari {} --> iingombrare {} --> obstruct {}
##  
{ my $search = "ammarazzari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammarazzari
##  	5  ==  ammarazzari {} --> imbarazzare {} --> obstruct {}
##  
{ my $search = "ammarazzari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammazzari
##  	1  ==  ammazzari {} --> uccidere {} --> murder {}
##  
{ my $search = "ammazzari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammisurari
##  	0  ==  ammisurari {} --> misurare {} --> measure {v}
##  
{ my $search = "ammisurari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammuccarisi
##  	0  ==  ammuccarisi {} --> mangiarsi {} --> eat one's words {}
##  
{ my $search = "ammuccarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammuccarisi
##  	1  ==  ammuccarisi {} --> mangiarsi {} --> mumble {}
##  
{ my $search = "ammuccarisi" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammugghiari
##  	0  ==  ammugghiari {} --> avvolgere {} --> cover {}
##  
{ my $search = "ammugghiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammuntuari
##  	0  ==  ammuntuari {} --> citare {} --> cite {}
##  
{ my $search = "ammuntuari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammuntuari
##  	1  ==  ammuntuari {} --> nominare {} --> mention {}
##  
{ my $search = "ammuntuari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammurrari
##  	1  ==  ammurrari {} --> Imbronciarsi {} --> cloud over {}
##  
{ my $search = "ammurrari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammurrari
##  	2  ==  ammurrari {} --> esaurire {} --> exhaust (a mine) {}
##  
{ my $search = "ammurrari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammurrari
##  	3  ==  ammurrari {} --> ostruire {} --> obstruct {}
##  
{ my $search = "ammurrari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammurrari
##  	4  ==  ammurrari {} --> arenarsi {} --> run aground {}
##  
{ my $search = "ammurrari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammurrari
##  	5  ==  ammurrari {} --> Imbronciarsi {} --> sulk {}
##  
{ my $search = "ammurrari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
  ${$dieli_sc{$search}[$index]}{"it_word"} = "imbronciarsi";
}

##  $ ./query-dieli.pl sc ammustrari
##  	2  ==  ammustrari {} --> mostrare {} --> point out {}
##  
{ my $search = "ammustrari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammuttunari
##  	0  ==  ammuttunari {} --> imbottire {} --> pad {}
##  
{ my $search = "ammuttunari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ammuttunari
##  	1  ==  ammuttunari {} --> imbottire {} --> stuff {}
##  
{ my $search = "ammuttunari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc annagghiari
##  	0  ==  annagghiari {} --> afferrare {} --> catch {}
##  
{ my $search = "annagghiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc annagghiari
##  	2  ==  annagghiari {} --> afferrare {} --> seize {}
##  
{ my $search = "annagghiari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc annari
##  	0  ==  annari {} --> partire {} --> leave {}
##  
{ my $search = "annari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc annijari
##  	0  ==  annijari {} --> annegare {} --> be drowned {}
##  
{ my $search = "annijari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc anniminari
##  	1  ==  anniminari {} --> indovinare {} --> predict {}
##  
{ my $search = "anniminari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc anniscari
##  	0  ==  anniscari {} --> adescare {} --> catch {}
##  
{ my $search = "anniscari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc anniscari
##  	1  ==  anniscari {} --> adescare {} --> lure {}
##  
{ my $search = "anniscari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc annunziari
##  	0  ==  annunziari {} --> preannunciare {} --> foretell {}
##  
{ my $search = "annunziari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc appartèniri
##  	0  ==  appartèniri {} --> appartenere {} --> belong (to) {}
##  
{ my $search = "appartèniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc apprittari
##  	0  ==  apprittari {} --> insistere {} --> insist {}
##  
{ my $search = "apprittari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc apprittari
##  	1  ==  apprittari {} --> insistere {} --> persist {}
##  
{ my $search = "apprittari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc appuiari
##  	1  ==  appuiari {} --> appoggiare {} --> lay {}
##  
{ my $search = "appuiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc appuiari
##  	2  ==  appuiari {} --> appoggiare {} --> lean {}
##  
{ my $search = "appuiari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc appuiari
##  	3  ==  appuiari {} --> appoggiare {} --> lean on {}
##  
{ my $search = "appuiari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arraggiunari
##  	1  ==  arraggiunari {} --> discutere con calma {} --> reason {v}
##  
{ my $search = "arraggiunari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arribbummari
##  	1  ==  arribbummari {} --> rimbombare {} --> rumble {}
##  
{ my $search = "arribbummari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arribbummari
##  	2  ==  arribbummari {} --> rimbombare {} --> thunder {}
##  
{ my $search = "arribbummari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arribbuttari
##  	0  ==  arribbuttari {} --> rigettare {} --> reject {}
##  
{ my $search = "arribbuttari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arribbuttari
##  	1  ==  arribbuttari {} --> rigettare {} --> turn down {}
##  
{ my $search = "arribbuttari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arribbuttari
##  	2  ==  arribbuttari {} --> rigettare {} --> turn down {}
##  
{ my $search = "arribbuttari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arricchiri
##  	2  ==  arricchiri {} --> arricchire {} --> make rich {}
##  
{ my $search = "arricchiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arricintari
##  	1  ==  arricintari {} --> sciacquare {} --> wash {}
##  
{ my $search = "arricintari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arricriarisi
##  	1  ==  arricriarisi {} --> divertire {} --> have fun {}
##  
{ my $search = "arricriarisi" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arricriarisi
##  	2  ==  arricriarisi {} --> provare piacere {} --> have fun {}
##  
{ my $search = "arricriarisi" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arricriarisi
##  	3  ==  arricriarisi {} --> divertire {} --> have pleasure {}
##  
{ my $search = "arricriarisi" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arricriarisi
##  	4  ==  arricriarisi {} --> provare piacere {} --> have pleasure {}
##  
{ my $search = "arricriarisi" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arricògghiri
##  	0  ==  arricògghiri {} --> raccogliere {} --> assemble {}
##  
{ my $search = "arricògghiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrifriddari
##  	0  ==  arrifriddari {} --> raffreddare {} --> cool {}
##  
{ my $search = "arrifriddari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrignari
##  	0  ==  arrignari {} --> regnare {} --> reign {}
##  
{ my $search = "arrignari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arripassari
##  	0  ==  arripassari {} --> ripassare {} --> check {}
##  
{ my $search = "arripassari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arripassari
##  	1  ==  arripassari {} --> ripassare {} --> go over again {}
##  
{ my $search = "arripassari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arripizzari
##  	1  ==  arripizzari {} --> rammendare {} --> mend {v}
##  
{ my $search = "arripizzari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arripizzari
##  	2  ==  arripizzari {} --> rappacificare {} --> mend {v}
##  
{ my $search = "arripizzari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arripizzari
##  	3  ==  arripizzari {} --> rattoppare {} --> mend {v}
##  
{ my $search = "arripizzari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arriscèdiri
##  	1  ==  arriscèdiri {} --> frugare {} --> rummage through {}
##  
{ my $search = "arriscèdiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arriscèdiri
##  	2  ==  arriscèdiri {} --> perquisire {} --> search {}
##  
{ my $search = "arriscèdiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrisittari
##  	0  ==  arrisittari {} --> riordinare {} --> arrange {}
##  
{ my $search = "arrisittari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrisittari
##  	1  ==  arrisittari {} --> riordinare {} --> tidy up {}
##  
{ my $search = "arrisittari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunchiari
##  	0  ==  arrunchiari {} --> radunare {} --> assemble {}
##  
{ my $search = "arrunchiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunzari
##  	0  ==  arrunzari {} --> radunare {} --> assemble {}
##  
{ my $search = "arrunzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunzari
##  	1  ==  arrunzari {} --> <br> {} --> heap {}
##  
{ my $search = "arrunzari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunzari
##  	2  ==  arrunzari {} --> ammonticchiare {} --> heap up {}
##  
{ my $search = "arrunzari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunzari
##  	3  ==  arrunzari {} --> lavorare male {} --> heap up {}
##  
{ my $search = "arrunzari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunzari
##  	4  ==  arrunzari {} --> <br> {} --> pile {}
##  
{ my $search = "arrunzari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunzari
##  	5  ==  arrunzari {} --> ammonticchiare {} --> pile {}
##  
{ my $search = "arrunzari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunzari
##  	6  ==  arrunzari {} --> lavorare male {} --> pile {}
##  
{ my $search = "arrunzari" ; my $index = 6 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunzari
##  	7  ==  arrunzari {} --> ammonticchiare {} --> push {}
##  
{ my $search = "arrunzari" ; my $index = 7 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunzari
##  	8  ==  arrunzari {} --> lavorare male {} --> push {}
##  
{ my $search = "arrunzari" ; my $index = 8 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrunzari
##  	9  ==  arrunzari {} --> spingere {} --> push {}
##  
{ my $search = "arrunzari" ; my $index = 9 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrusicari
##  	2  ==  arrusicari {} --> rodere {} --> nibble {}
##  
{ my $search = "arrusicari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arruspigghiari
##  	0  ==  arruspigghiari {} --> svegliare {} --> awaken {}
##  
{ my $search = "arruspigghiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrùstiri
##  	0  ==  arrùstiri {} --> arrostire {} --> grill {}
##  
{ my $search = "arrùstiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc arrùstiri
##  	2  ==  arrùstiri {} --> arrostire {} --> toast {}
##  
{ my $search = "arrùstiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ascutari
##  	0  ==  ascutari {} --> <br> {} --> listen {}
##  
{ my $search = "ascutari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ascutari
##  	1  ==  ascutari {} --> ascoltare {} --> listen to {}
##  
{ my $search = "ascutari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ascutari
##  	2  ==  ascutari {} --> seguire il consiglio {} --> listen to {}
##  
{ my $search = "ascutari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assaggiari
##  	1  ==  assaggiari {} --> assaggiare {} --> try (sample) {}
##  
{ my $search = "assaggiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assapurari
##  	1  ==  assapurari {} --> assaggiare {} --> test {}
##  
{ my $search = "assapurari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assapurari
##  	2  ==  assapurari {} --> gustare {} --> test {}
##  
{ my $search = "assapurari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assapurari
##  	3  ==  assapurari {} --> gustare {} --> try {}
##  
{ my $search = "assapurari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assapurari
##  	4  ==  assapurari {} --> assaggiare {} --> try (sample) {}
##  
{ my $search = "assapurari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assicunnari
##  	2  ==  assicunnari {} --> replicare {} --> repeat {}
##  
{ my $search = "assicunnari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assicunnari
##  	3  ==  assicunnari {} --> ripetere {} --> repeat {}
##  
{ my $search = "assicunnari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assicurari
##  	1  ==  assicurari {} --> assicurare {} --> ensure {}
##  
{ my $search = "assicurari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assicurari
##  	3  ==  assicurari {} --> assicurare {} --> make safe {}
##  
{ my $search = "assicurari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assicurari
##  	4  ==  assicurari {} --> rendere sicuro {} --> make safe {}
##  
{ my $search = "assicurari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assintari
##  	0  ==  assintari {} --> assestare {} --> balance (ledger) {}
##  
{ my $search = "assintari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assintumari
##  	1  ==  assintumari {} --> svenire {} --> pass out {}
##  
{ my $search = "assintumari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assuggittari
##  	0  ==  assuggittari {} --> assoggettare {} --> subject (submit to) {}
##  
{ my $search = "assuggittari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assumigghiari
##  	1  ==  assumigghiari {} --> assomigliare {} --> make similar (to) {}
##  
{ my $search = "assumigghiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assuttigghiari
##  	6  ==  assuttigghiari {} --> assottigliare {} --> summarize {}
##  
{ my $search = "assuttigghiari" ; my $index = 6 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assuttigghiari
##  	7  ==  assuttigghiari {} --> riassumere {} --> summarize {}
##  
{ my $search = "assuttigghiari" ; my $index = 7 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assuzzari
##  	0  ==  assuzzari {} --> pareggiare {} --> balance {}
##  
{ my $search = "assuzzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assuzzari
##  	2  ==  assuzzari {} --> pareggiare {} --> level {}
##  
{ my $search = "assuzzari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc assuzzari
##  	3  ==  assuzzari {} --> pareggiare {} --> make equal {}
##  
{ my $search = "assuzzari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc attigghiari
##  	0  ==  attigghiari {m} --> solleticare {m} --> tickle {n}
##  
{ my $search = "attigghiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc attigghiari
##  	1  ==  attigghiari {m} --> solleticare {m} --> whet {n}
##  
{ my $search = "attigghiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc attruvari
##  	0  ==  attruvari {} --> trovare {} --> find {}
##  
{ my $search = "attruvari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc attuari
##  	0  ==  attuari {} --> rializzari {} --> carry out {v}
##  
{ my $search = "attuari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc atturrari
##  	0  ==  atturrari {} --> tostare {} --> roast coffee {}
##  
{ my $search = "atturrari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc atturrari
##  	1  ==  atturrari {} --> tostare {} --> toast bread {v}
##  
{ my $search = "atturrari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc aumintari
##  	2  ==  aumintari {} --> aumentare {} --> raise {}
##  
{ my $search = "aumintari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc avantari
##  	0  ==  avantari {vr} --> vantarsi {vr} --> swagger {vr}
##  
{ my $search = "avantari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc avantari
##  	1  ==  avantari {vr} --> vantarsi {vr} --> vaunt {vr}
##  
{ my $search = "avantari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc avantari
##  	2  ==  avantari {vr} --> vantarsi {vr} --> brag {vr}
##  
{ my $search = "avantari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc aviri
##  	1  ==  aviri {} --> <br> {} --> own (property) {}
##  
{ my $search = "aviri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc avvicinarisi
##  	0  ==  avvicinarisi {m} --> avvicinarsi {m} --> approach {n}
##  
{ my $search = "avvicinarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc azziccari
##  	0  ==  azziccari {} --> infilzari {} --> pierce {}
##  
{ my $search = "azziccari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc azziccari
##  	1  ==  azziccari {} --> infilzari {} --> spear {}
##  
{ my $search = "azziccari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc azziccari
##  	2  ==  azziccari {} --> infilzari {} --> stick {}
##  
{ my $search = "azziccari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc azziccari
##  	3  ==  azziccari {} --> infilzari {} --> string {}
##  
{ my $search = "azziccari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc babÏari
##  	0  ==  babÏari {} --> scherzare {} --> joke {}
##  
{ undef( $dieli_sc{"babÏari"} ) ;
  ##  QUESTION:  is "babÏari" the correct form?  
  ##     *  if so, we should include it along with note on etymology
  my $search = "babìari" ; my $index = 0 ; 
  ${$dieli_sc{$search}[$index]}{"sc_word"} = "babìari";
  ${$dieli_sc{$search}[$index]}{"it_word"} = "scherzare";
  ${$dieli_sc{$search}[$index]}{"en_word"} = "joke";
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc bazzicari
##  	0  ==  bazzicari {} --> bazzicare {} --> attend {}
##  
{ my $search = "bazzicari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc bazzicari
##  	2  ==  bazzicari {} --> bazzicare {} --> hang about {}
##  
{ my $search = "bazzicari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc bazzicari
##  	3  ==  bazzicari {} --> bazzicare {} --> see (regularly) {}
##  
{ my $search = "bazzicari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc bazzicari
##  	4  ==  bazzicari {} --> frequentare {} --> see (regularly) {}
##  
{ my $search = "bazzicari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cafuddari
##  	0  ==  cafuddari {} --> picchiare {} --> beat {}
##  
{ my $search = "cafuddari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc calari
##  	0  ==  calari {} --> abbassare {} --> diminish {}
##  
{ my $search = "calari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc calari
##  	1  ==  calari {} --> calare {} --> diminish {}
##  
{ my $search = "calari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc calari
##  	2  ==  calari {} --> abbassare {} --> lower {}
##  
{ my $search = "calari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc calari
##  	3  ==  calari {} --> calare {} --> lower {}
##  
{ my $search = "calari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc campari
##  	0  ==  campari {} --> <br> {} --> be alive {}
##  
{ my $search = "campari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc campari
##  	1  ==  campari {} --> <br> {} --> live {}
##  
{ my $search = "campari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc canciari
##  	4  ==  canciari {} --> cambiare {} --> modify {}
##  
{ my $search = "canciari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc capiri
##  	0  ==  capiri {} --> entrarci {} --> be relevant {}
##  
{ my $search = "capiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc capiri
##  	1  ==  capiri {} --> starci {} --> be relevant {}
##  
{ my $search = "capiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc capiri
##  	4  ==  capiri {} --> entrarci {} --> matter {}
##  
{ my $search = "capiri" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc capiri
##  	5  ==  capiri {} --> starci {} --> matter {}
##  
{ my $search = "capiri" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc carculari
##  	2  ==  carculari {} --> valutare {} --> evaluate {}
##  
{ my $search = "carculari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc carruzziari
##  	0  ==  carruzziari {} --> portare in giro in macchina {} --> tour {}
##  
{ my $search = "carruzziari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cascari
##  	1  ==  cascari {} --> <br> {} --> fall {}
##  
{ my $search = "cascari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cascari
##  	2  ==  cascari {} --> cadere {} --> fall (down) {}
##  
{ my $search = "cascari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cascari
##  	3  ==  cascari {} --> cadere {} --> flop {}
##  
{ my $search = "cascari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc chianciri
##  	0  ==  chianciri {} --> <br> {} --> cry {}
##  
{ my $search = "chianciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc chianciri
##  	1  ==  chianciri {} --> <br> {} --> mourn for {}
##  
{ my $search = "chianciri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc chiànciri
##  	1  ==  chiànciri {} --> piangere {v} --> grieve {v}
##  
{ my $search = "chiànciri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ciaccari
##  	5  ==  ciaccari {} --> dissodare {} --> till {v}
##  
{ my $search = "ciaccari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc citari
##  	0  ==  citari {} --> citare {} --> cite {}
##  
{ my $search = "citari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cogghiri
##  	0  ==  cogghiri {} --> cogliere {} --> collect {}
##  
{ my $search = "cogghiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc confinari
##  	0  ==  confinari {} --> confinare {} --> bound {v}
##  
{ my $search = "confinari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc confinari
##  	1  ==  confinari {} --> confinare {} --> confine {}
##  
{ my $search = "confinari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc confinari
##  	2  ==  confinari {} --> confinare {} --> limit {}
##  
{ my $search = "confinari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cuariari
##  	0  ==  cuariari {} --> riscaldare {} --> heat {}
##  
{ my $search = "cuariari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cuariari
##  	1  ==  cuariari {} --> riscaldare {} --> warm {}
##  
{ my $search = "cuariari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cuincìdiri
##  	1  ==  cuincìdiri {} --> coincidere {} --> fall on (a date) {}
##  
{ my $search = "cuincìdiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cullabburari
##  	0  ==  cullabburari {} --> collaborare {} --> collaborate {}
##  
{ my $search = "cullabburari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cullabburari
##  	1  ==  cullabburari {} --> collaborare {} --> contribute {}
##  
{ my $search = "cullabburari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cullabburari
##  	2  ==  cullabburari {} --> collaborare {} --> cooperate {}
##  
{ my $search = "cullabburari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cummattiri
##  	0  ==  cummattiri {} --> combattere {} --> annoy {}
##  
{ my $search = "cummattiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cummattiri
##  	1  ==  cummattiri {} --> <br> {} --> assault {}
##  
{ my $search = "cummattiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cummattiri
##  	3  ==  cummattiri {} --> avere a che fare {} --> be busy {}
##  
{ my $search = "cummattiri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cummattiri
##  	6  ==  cummattiri {} --> <br> {} --> deal {}
##  
{ my $search = "cummattiri" ; my $index = 6 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cummèttiri
##  	0  ==  cummèttiri {} --> commettere {} --> assemble {}
##  
{ my $search = "cummèttiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cumprumìntiri
##  	0  ==  cumprumìntiri {} --> rischiare {} --> compromise {v}
##  
{ my $search = "cumprumìntiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cumprumìntiri
##  	1  ==  cumprumìntiri {} --> compromettere {} --> make a compromise {}
##  
{ my $search = "cumprumìntiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cumprumìntiri
##  	2  ==  cumprumìntiri {} --> rischiare {} --> make a compromise {}
##  
{ my $search = "cumprumìntiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cumpurtarisi
##  	0  ==  cumpurtarisi {vi} --> comportarsi {vi} --> behave {vi}
##  
{ my $search = "cumpurtarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cumpòniri
##  	0  ==  cumpòniri {} --> comporre {} --> arrange {}
##  
{ my $search = "cumpòniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cumpòniri
##  	2  ==  cumpòniri {} --> comporre {} --> put together {}
##  
{ my $search = "cumpòniri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cumunicari
##  	2  ==  cumunicari {} --> comunicare {} --> participate {}
##  
{ my $search = "cumunicari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cunchiùdiri
##  	0  ==  cunchiùdiri {} --> concludere {} --> conclude {}
##  
{ my $search = "cunchiùdiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cuncèdiri
##  	1  ==  cuncèdiri {} --> concedere {} --> concede {}
##  
{ my $search = "cuncèdiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cundùciri
##  	0  ==  cundùciri {} --> condurre  {} --> drive  {v}
##  
{ my $search = "cundùciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cunfunniri
##  	4  ==  cunfunniri {} --> confondere {} --> mix up {}
##  
{ my $search = "cunfunniri" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cunnannari
##  	0  ==  cunnannari {} --> condannare {} --> condemn {}
##  
{ my $search = "cunnannari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cunnannari
##  	2  ==  cunnannari {} --> condannare {} --> sentence {}
##  
{ my $search = "cunnannari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cunnùciri
##  	1  ==  cunnùciri {} --> condurre {} --> conduct {}
##  
{ my $search = "cunnùciri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cunnùciri
##  	2  ==  cunnùciri {} --> condurre  {} --> drive  {v}
##  
{ my $search = "cunnùciri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cunnùciri
##  	3  ==  cunnùciri {} --> condurre {} --> lead {}
##  
{ my $search = "cunnùciri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cunsumari
##  	0  ==  cunsumari {} --> consumare {} --> consume {}
##  
{ my $search = "cunsumari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cuntari
##  	0  ==  cuntari v{} --> contare {v} --> count {v}
##  
{ my $search = "cuntari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cuntrastari
##  	2  ==  cuntrastari {} --> <br> {} --> contest {}
##  
{ my $search = "cuntrastari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cuntèniri
##  	1  ==  cuntèniri {} --> contenere {} --> curb {}
##  
{ my $search = "cuntèniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cuntèniri
##  	2  ==  cuntèniri {} --> contenere {} --> curb {}
##  
{ my $search = "cuntèniri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cuntèniri
##  	3  ==  cuntèniri {} --> contenere {} --> hold back {}
##  
{ my $search = "cuntèniri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cunzigghiari
##  	1  ==  cunzigghiari {} --> consigliare {} --> cousel {}
##  
{ my $search = "cunzigghiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
  ${$dieli_sc{$search}[$index]}{"en_word"} = "counsel";
}

##  $ ./query-dieli.pl sc cupunari
##  	1  ==  cupunari {} --> coperchiare {} --> put a lid on {}
##  
{ my $search = "cupunari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc curari
##  	2  ==  curari {} --> <br> {} --> mind {v}
##  
{ my $search = "curari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc curarisi
##  	0  ==  curarisi {} --> preoccuparti {} --> worry oneself {}
##  
{ my $search = "curarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc curcarisi
##  	0  ==  curcarisi {} --> addormentarsi {} --> go to sleep {}
##  
{ my $search = "curcarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc curreggiri
##  	0  ==  curreggiri {} --> correggere {} --> grade (an exam) {}
##  
{ my $search = "curreggiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc curreggiri
##  	2  ==  curreggiri {} --> correggere {} --> rectify {}
##  
{ my $search = "curreggiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc currispùnniri
##  	0  ==  currispùnniri {} --> correspondere {} --> coincide {}
##  
{ my $search = "currispùnniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc currispùnniri
##  	1  ==  currispùnniri {} --> correspondere {} --> correspond {}
##  
{ my $search = "currispùnniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cutturiari
##  	0  ==  cutturiari {} --> assillare {} --> harass {}
##  
{ my $search = "cutturiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cutturiari
##  	1  ==  cutturiari {} --> tampinare {} --> harass {}
##  
{ my $search = "cutturiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cutturiari
##  	2  ==  cutturiari {} --> assillare {} --> pester {}
##  
{ my $search = "cutturiari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cutturiari
##  	3  ==  cutturiari {} --> tampinare {} --> pester {}
##  
{ my $search = "cutturiari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc càriri
##  	0  ==  càriri {} --> cadere {} --> fall {}
##  
{ my $search = "càriri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cèdiri
##  	0  ==  cèdiri {} --> cedere {} --> concede {}
##  
{ my $search = "cèdiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc cèdiri
##  	1  ==  cèdiri {} --> cedere {} --> transfer an entitlement {}
##  
{ my $search = "cèdiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc dicìdiri
##  	0  ==  dicìdiri {} --> decidere {} --> choose {}
##  
{ my $search = "dicìdiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc dicìdiri
##  	1  ==  dicìdiri {} --> decidere {} --> decide {}
##  
{ my $search = "dicìdiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc difùnniri
##  	0  ==  difùnniri {} --> disseminare {} --> circulate {}
##  
{ my $search = "difùnniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc difùnniri
##  	1  ==  difùnniri {} --> diffondere {} --> diffuse {}
##  
{ my $search = "difùnniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc difùnniri
##  	2  ==  difùnniri {} --> disseminare {} --> disseminate {}
##  
{ my $search = "difùnniri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc diminuiri
##  	0  ==  diminuiri {} --> abbassare {} --> diminish {}
##  
{ my $search = "diminuiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc diminuiri
##  	1  ==  diminuiri {} --> calare {} --> diminish {}
##  
{ my $search = "diminuiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc dipusitari
##  	2  ==  dipusitari {} --> deporre {} --> store {}
##  
{ my $search = "dipusitari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc dipusitari
##  	3  ==  dipusitari {} --> depositare {} --> store {}
##  
{ my $search = "dipusitari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc diriggiri
##  	0  ==  diriggiri {} --> dirigere {} --> direct {}
##  
{ my $search = "diriggiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc diriggiri
##  	3  ==  diriggiri {} --> menare {} --> lead {v}
##  
{ my $search = "diriggiri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc discrìviri
##  	2  ==  discrìviri {} --> descrivere {} --> trace {}
##  
{ my $search = "discrìviri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc discùrriri
##  	0  ==  discùrriri {} --> discutere {} --> argue {}
##  
{ my $search = "discùrriri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc divirtirisi
##  	0  ==  divirtirisi {} --> divertirsi {} --> enjoy {}
##  
{ my $search = "divirtirisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc divirtirisi
##  	3  ==  divirtirisi {} --> divertirsi {} --> have fun {}
##  
{ my $search = "divirtirisi" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc duviri
##  	4  ==  duviri {} --> dovere qc {} --> owe {}
##  
{ my $search = "duviri" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc firari
##  	0  ==  firari {} --> fidare {} --> trust {}
##  
{ my $search = "firari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc firriari
##  	1  ==  firriari {} --> circondare {} --> encircle {}
##  
{ my $search = "firriari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc firriari
##  	2  ==  firriari {} --> girare {} --> encircle {}
##  
{ my $search = "firriari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc firriari
##  	3  ==  firriari {} --> circondare {} --> revolve {}
##  
{ my $search = "firriari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc firriari
##  	4  ==  firriari {} --> girare {} --> revolve {}
##  
{ my $search = "firriari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc firriari
##  	5  ==  firriari {} --> circondare {} --> turn {}
##  
{ my $search = "firriari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc firriari
##  	6  ==  firriari {} --> girare {} --> turn {}
##  
{ my $search = "firriari" ; my $index = 6 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc frequentari
##  	1  ==  frequentari {} --> frequentare {} --> hang about {}
##  
{ my $search = "frequentari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc fequentari
##  	0  ==  fequentari {} --> frequentare {} --> attend {}
##  
{ undef( $dieli_sc{"fequentari"} ) ;
  my $search = "frequentari" ; 
  my %th ;  
  $th{"sc_word"} = $search       ; $th{"sc_part"} = "{v}" ;
  $th{"it_word"} = "frequentare" ; $th{"it_part"} = "{v}" ;
  $th{"en_word"} = "attend"      ; $th{"en_part"} = "{v}" ;  
  push( @{ $dieli_sc{$search} } , \%th ) ;
}

##  $ ./query-dieli.pl sc fruttari
##  	0  ==  fruttari {} --> generare {} --> be fruitful {}
##  
{ my $search = "fruttari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc fruttari
##  	1  ==  fruttari {} --> produrre frutta {} --> be fruitful {}
##  
{ my $search = "fruttari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc fruttari
##  	4  ==  fruttari {} --> generare {} --> generate {}
##  
{ my $search = "fruttari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc fruttari
##  	5  ==  fruttari {} --> produrre frutta {} --> generate {}
##  
{ my $search = "fruttari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc funiculari
##  	0  ==  funiculari {f} --> <br> {f} --> cable car {n}
##  
{ my $search = "funiculari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc fìnciri
##  	0  ==  fìnciri {} --> fingere {} --> feign {}
##  
{ my $search = "fìnciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc gianniari
##  	0  ==  gianniari {vi} --> ingiallire {vi} --> yellow (to) {vi}
##  
{ my $search = "gianniari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc giudicari
##  	0  ==  giudicari {} --> <br> {} --> judge {v}
##  
{ my $search = "giudicari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc guadagnari
##  	3  ==  guadagnari {} --> guadagnare {} --> obtain {}
##  
{ my $search = "guadagnari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc guardari
##  	3  ==  guardari {} --> <br> {} --> regard {}
##  
{ my $search = "guardari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc guardari
##  	5  ==  guardari {} --> <br> {} --> watch {}
##  
{ my $search = "guardari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc guidari
##  	0  ==  guidari {} --> guidare {} --> conduct {}
##  
{ my $search = "guidari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc guidari
##  	5  ==  guidari {} --> guidare {} --> lead {}
##  
{ my $search = "guidari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc guidari
##  	7  ==  guidari {} --> guidare {} --> steer {v}
##  
{ my $search = "guidari" ; my $index = 7 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc guirari
##  	0  ==  guirari {} --> guidare {} --> drive {v}
##  
{ my $search = "guirari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc gurgari
##  	0  ==  gurgari {} --> sgorgare {} --> gush {}
##  
{ my $search = "gurgari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc gurgari
##  	1  ==  gurgari {} --> sgorgare {} --> spurt out {}
##  
{ my $search = "gurgari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc imbriacari
##  	0  ==  imbriacari {} --> <br> {} --> be drunk {}
##  
{ my $search = "imbriacari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc impijurari
##  	0  ==  impijurari {} --> <br> {} --> worsen {}
##  
{ my $search = "impijurari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc impijurari
##  	1  ==  impijurari {vi} --> peggiorare {vi} --> worsen {vi}
##  
{ my $search = "impijurari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc insirtari
##  	0  ==  insirtari {} --> indovinare {} --> guess {}
##  
{ my $search = "insirtari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc inturciuniari
##  	0  ==  inturciuniari {} --> intrecciare {} --> interweave {}
##  
{ my $search = "inturciuniari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc inviari
##  	1  ==  inviari {} --> <br> {} --> ship {}
##  
{ my $search = "inviari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc iunciri
##  	1  ==  iunciri {} --> aggiungere {} --> join {}
##  
{ my $search = "iunciri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc jisari
##  	0  ==  jisari {} --> alzare {} --> hoist {}
##  
{ my $search = "jisari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc jisari
##  	1  ==  jisari {} --> alzare {} --> lift {}
##  
{ my $search = "jisari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc jissijari
##  	0  ==  jissijari {} --> gessare {} --> plaster {v}
##  
{ my $search = "jissijari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc jittari
##  	1  ==  jittari {} --> gettare {} --> fling {}
##  
{ my $search = "jittari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc jittari
##  	2  ==  jittari {} --> gettare {} --> gush {}
##  
{ my $search = "jittari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc jittari
##  	3  ==  jittari {} --> gettare {} --> sprout {}
##  
{ my $search = "jittari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc lacerari
##  	0  ==  lacerari {} --> lacerare {} --> lacerate {}
##  
{ my $search = "lacerari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc lamintarisi
##  	0  ==  lamintarisi {} --> <br> {} --> lament {}
##  
{ my $search = "lamintarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc lampiari
##  	0  ==  lampiari {} --> lampeggiare {} --> flash {}
##  
{ my $search = "lampiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc lampiari
##  	1  ==  lampiari {} --> lampeggiare {} --> flash {}
##  
{ my $search = "lampiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc lassari
##  	2  ==  lassari {} --> <br> {} --> leave {}
##  
{ my $search = "lassari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc lassari
##  	3  ==  lassari {} --> lasciare {} --> leave {}
##  
{ my $search = "lassari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc lauriari
##  	0  ==  lauriari {} --> laureare {} --> confer a degree {}
##  
{ my $search = "lauriari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc lazzariari
##  	1  ==  lazzariari {} --> ferire {} --> injure {}
##  
{ my $search = "lazzariari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc lazzariari
##  	2  ==  lazzariari {} --> ferire {} --> wound {}
##  
{ my $search = "lazzariari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc limitari
##  	0  ==  limitari {} --> circoscrivere {} --> bound {v}
##  
{ my $search = "limitari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc limitari
##  	1  ==  limitari {} --> limitare {} --> bound {v}
##  
{ my $search = "limitari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc limitari
##  	2  ==  limitari {} --> circoscrivere {} --> limit {}
##  
{ my $search = "limitari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc limitari
##  	3  ==  limitari {} --> limitare {} --> limit {v}
##  
{ my $search = "limitari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc limitari
##  	4  ==  limitari {} --> circoscrivere {} --> mark the bounds of {}
##  
{ my $search = "limitari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc lippiari
##  	0  ==  lippiari {} --> mangiucchiare {} --> nibble {}
##  
{ my $search = "lippiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mancari
##  	2  ==  mancari {} --> mancare {} --> lack {v}
##  
{ my $search = "mancari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mannari
##  	1  ==  mannari {} --> mandare {} --> send {}
##  
{ my $search = "mannari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mannari
##  	2  ==  mannari {} --> spedire {} --> send {}
##  
{ my $search = "mannari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mantèniri
##  	0  ==  mantèniri {} --> mantenere {} --> keep {}
##  
{ my $search = "mantèniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mantèniri
##  	1  ==  mantèniri {} --> mantenere {} --> maintain {}
##  
{ my $search = "mantèniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc massacrari
##  	0  ==  massacrari {} --> <br> {} --> massacre {}
##  
{ my $search = "massacrari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc massacrari
##  	1  ==  massacrari {} --> <br> {} --> slaughter {v}
##  
{ my $search = "massacrari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc matuciari
##  	0  ==  matuciari {} --> avere rapporti omosessuali {} --> have homosexual relations {}
##  
{ my $search = "matuciari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc migghiurari
##  	1  ==  migghiurari {} --> migliorare {} --> get better {}
##  
{ my $search = "migghiurari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc migghiurari
##  	3  ==  migghiurari {} --> migliorare {} --> make progress {}
##  
{ my $search = "migghiurari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc minuzzari
##  	0  ==  minuzzari {} --> tagliuzzare {} --> mince {}
##  
{ my $search = "minuzzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc misurari
##  	2  ==  misurari {} --> misurare {} --> measure {v}
##  
{ my $search = "misurari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mmarcari
##  	2  ==  mmarcari {} --> imbarcare {} --> embark {}
##  
{ my $search = "mmarcari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mmarcari
##  	3  ==  mmarcari {} --> imbarcare {} --> load {}
##  
{ my $search = "mmarcari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mmintari
##  	0  ==  mmintari {} --> inventare {} --> invent {}
##  
{ my $search = "mmintari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mmintari
##  	1  ==  mmintari {} --> mentire {} --> invent {}
##  
{ my $search = "mmintari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mmintari
##  	2  ==  mmintari {} --> inventare {} --> lie (fabricate) {}
##  
{ my $search = "mmintari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mmintari
##  	3  ==  mmintari {} --> mentire {} --> lie (fabricate) {}
##  
{ my $search = "mmintari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mmriacari
##  	0  ==  mmriacari {} --> <br> {} --> get drunk {}
##  
{ my $search = "mmriacari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mpidiri
##  	1  ==  mpidiri {} --> impedire {} --> obstruct {}
##  
{ my $search = "mpidiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc mpidiri
##  	2  ==  mpidiri {} --> impedire {} --> prevent (from) {}
##  
{ my $search = "mpidiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc strittu mpòniri
##  	0  ==  mpòniri {v} --> imporre  {v} --> impose  {v}
##  
{ my $search = "mpòniri" ; my $index = 0 ; 
  ##  need to remove trailing space
  ${$dieli_sc{$search}[$index]}{"it_word"} = "imporre" ;
  ${$dieli_sc{$search}[$index]}{"en_word"} = "impose" ;
}

##  $ ./query-dieli.pl sc munnari
##  	0  ==  munnari {} --> sbucciare {} --> peel {}
##  
{ my $search = "munnari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc muriri
##  	0  ==  muriri {} --> morire {} --> come an end {}
##  
{ my $search = "muriri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
  ##  ##  "come to an end" ... but let's conserve Dr. Dieli's work
}

##  $ ./query-dieli.pl sc nasciri
##  	0  ==  nasciri {} --> <br> {} --> be born {}
##  
{ my $search = "nasciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc navicari
##  	0  ==  navicari {} --> navigare {} --> navigate {}
##  
{ my $search = "navicari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc navicari
##  	1  ==  navicari {} --> navigare {} --> sail {}
##  
{ my $search = "navicari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ncassari
##  	1  ==  ncassari {} --> esigere {} --> collect (taxes) {}
##  
{ my $search = "ncassari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ncassari
##  	2  ==  ncassari {} --> riscuotere {} --> drawdown {}
##  
{ my $search = "ncassari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ncucchiari
##  	0  ==  ncucchiari {} --> mettere insieme {} --> bring together {}
##  
{ my $search = "ncucchiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ncucchiari
##  	1  ==  ncucchiari {} --> mettere insieme {} --> match {}
##  
{ my $search = "ncucchiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ncuminzari
##  	0  ==  ncuminzari {} --> cominciare {v} --> begin {v}
##  
{ my $search = "ncuminzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ngianniari
##  	0  ==  ngianniari {vi} --> ingiallire {vi} --> yellow (to) {vi}
##  
{ my $search = "ngianniari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ngranciari
##  	0  ==  ngranciari {} --> soffriggere {} --> fry lightly {}
##  
{ my $search = "ngranciari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ngrifarisi
##  	0  ==  ngrifarisi {r} --> arricciarsi {r} --> wrinkle {r}
##  
{ my $search = "ngrifarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc niguzziari
##  	0  ==  niguzziari {} --> commerciare {} --> deal {}
##  
{ my $search = "niguzziari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc niguzziari
##  	1  ==  niguzziari {} --> negoziare {} --> deal {}
##  
{ my $search = "niguzziari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc niguzziari
##  	2  ==  niguzziari {} --> negoziare {} --> negotiate {}
##  
{ my $search = "niguzziari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc niguzziari
##  	4  ==  niguzziari {} --> commerciare {} --> trade {}
##  
{ my $search = "niguzziari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc niguzziari
##  	5  ==  niguzziari {} --> negoziare {} --> trade {}
##  
{ my $search = "niguzziari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ntagghiari
##  	0  ==  ntagghiari {} --> incidere {} --> carve {}
##  
{ my $search = "ntagghiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ntagghiari
##  	1  ==  ntagghiari {} --> incidere {} --> cut into {}
##  
{ my $search = "ntagghiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ntraminzari
##  	0  ==  ntraminzari {} --> includere {} --> include {}
##  
{ my $search = "ntraminzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ntraminzari
##  	1  ==  ntraminzari {} --> intramezzare {} --> include {}
##  
{ my $search = "ntraminzari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ntrubbulari
##  	0  ==  ntrubbulari {} --> intorbidire {} --> cloud {}
##  
{ my $search = "ntrubbulari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ntrubbulari
##  	1  ==  ntrubbulari {} --> intorbidire {} --> make turbid {}
##  
{ my $search = "ntrubbulari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc nutari
##  	0  ==  nutari {} --> annotare {} --> annotate {}
##  
{ my $search = "nutari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc nutari
##  	1  ==  nutari {} --> contrassegnare {} --> mark {}
##  
{ my $search = "nutari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc nutari
##  	4  ==  nutari {} --> notare {} --> notice {}
##  
{ my $search = "nutari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc nzajari
##  	1  ==  nzajari {} --> indossare {} --> try on {}
##  
{ my $search = "nzajari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc nzitari
##  	0  ==  nzitari {} --> innestare {} --> graft {}
##  
{ my $search = "nzitari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc nzitari
##  	1  ==  nzitari {} --> innestare {} --> prune {}
##  
{ my $search = "nzitari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc nzullintari
##  	0  ==  nzullintari {} --> istigare {} --> incite {}
##  
{ my $search = "nzullintari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc nzullintari
##  	1  ==  nzullintari {} --> provocare {} --> provoke {}
##  
{ my $search = "nzullintari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc nzullintari
##  	2  ==  nzullintari {} --> provocare {} --> provoke {}
##  
{ my $search = "nzullintari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ottèniri
##  	1  ==  ottèniri {} --> ottenere {} --> get {}
##  
{ my $search = "ottèniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc passari
##  	0  ==  passari {n} --> <br> {} --> be worth {}
##  	1  ==  passari {} --> menare {} --> lead {v}
##  	2  ==  passari {v} --> passare {v} --> pass {v}
##  	3  ==  passari {v} --> passare {v} --> pass over to {v}
##  
{ my $search = "passari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
  ##  it seems this should be a verb, right ???
}
{ my $search = "passari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc persuàdiri
##  	0  ==  persuàdiri {} --> persuadere {} --> convince {}
##  
{ my $search = "persuàdiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc persuàdiri
##  	2  ==  persuàdiri {} --> persuadere {} --> talk into {}
##  
{ my $search = "persuàdiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pigghiari
##  	1  ==  pigghiari {} --> prendere {} --> get {}
##  
{ my $search = "pigghiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pigghiari
##  	4  ==  pigghiari {} --> <br> {} --> seize {}
##  
{ my $search = "pigghiari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc piniari
##  	0  ==  piniari {} --> penare {} --> suffer {}
##  
{ my $search = "piniari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pinnuliari
##  	0  ==  pinnuliari {} --> penzolare {} --> dangle {}
##  
{ my $search = "pinnuliari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pinzari
##  	0  ==  pinzari {} --> pensare {} --> believe {}
##  
{ my $search = "pinzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pinzari
##  	1  ==  pinzari {} --> pensare {} --> imagine {}
##  
{ my $search = "pinzari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc piriculari
##  	1  ==  piriculari {} --> <br> {} --> jeopardize {}
##  
{ my $search = "piriculari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pirnuttari
##  	0  ==  pirnuttari {} --> pernottare {} --> spend the night {}
##  
{ my $search = "pirnuttari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pirsivirari
##  	0  ==  pirsivirari {} --> <br> {} --> persevere {}
##  
{ my $search = "pirsivirari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pittari
##  	0  ==  pittari {} --> dipingere {} --> paint {}
##  
{ my $search = "pittari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pratticari
##  	0  ==  pratticari {} --> praticare {} --> engage in {}
##  
{ my $search = "pratticari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc premiri
##  	0  ==  premiri {} --> <br> {} --> be concerned with {}
##  
{ my $search = "premiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc presumiri
##  	3  ==  presumiri {} --> <br> {} --> presume {}
##  
{ my $search = "presumiri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc presumiri
##  	4  ==  presumiri {} --> <br> {} --> presume {}
##  
{ my $search = "presumiri" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc prifiriri
##  	0  ==  prifiriri {n} --> preferire {} --> like better {}
##  
{ my $search = "prifiriri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc prifiriri
##  	1  ==  prifiriri {n} --> preferire {} --> prefer {}
##  
{ my $search = "prifiriri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc prilivari
##  	0  ==  prilivari {} --> prelevare {} --> collect {}
##  
{ my $search = "prilivari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc prilivari
##  	2  ==  prilivari {} --> prelevare {} --> withdraw (banking) {}
##  
{ my $search = "prilivari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc prisirvari
##  	0  ==  prisirvari {} --> conservare {} --> conserve {}
##  
{ my $search = "prisirvari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc prisirvari
##  	1  ==  prisirvari {} --> conservare {} --> preserve {}
##  
{ my $search = "prisirvari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pritènniri
##  	0  ==  pritènniri {} --> pretendere {} --> claim {}
##  
{ my $search = "pritènniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pritènniri
##  	1  ==  pritènniri {} --> pretendere {} --> expect {}
##  
{ my $search = "pritènniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pritènniri
##  	2  ==  pritènniri {} --> pretendere {} --> pretend {}
##  
{ my $search = "pritènniri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc proseguiri
##  	0  ==  proseguiri {} --> proseguire {} --> continue {}
##  
{ my $search = "proseguiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc prudùciri
##  	0  ==  prudùciri {} --> produrre {} --> bear {}
##  
{ my $search = "prudùciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc prudùciri
##  	2  ==  prudùciri {} --> produrre {} --> yield {}
##  
{ my $search = "prudùciri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc prupòniri
##  	0  ==  prupòniri {} --> proporre  {} --> propose  {v}
##  
{ my $search = "prupòniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
  ##  also need to remove trailing space
  ${$dieli_sc{$search}[$index]}{"it_word"} = "proporre" ;
  ${$dieli_sc{$search}[$index]}{"en_word"} = "propose" ;
}

##  $ ./query-dieli.pl sc pruvari
##  	3  ==  pruvari {} --> provare {} --> try {}
##  
{ my $search = "pruvari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pròjiri
##  	1  ==  pròjiri {} --> porgere {} --> hold out {}
##  
{ my $search = "pròjiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pulizziari
##  	0  ==  pulizziari {} --> pulire {} --> clean {}
##  
{ my $search = "pulizziari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc puntificari
##  	0  ==  puntificari {} --> comandare {} --> pontificate {v}
##  
{ my $search = "puntificari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pàrtiri
##  	0  ==  pàrtiri {} --> partire {} --> leave {}
##  
{ my $search = "pàrtiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pùnciri
##  	0  ==  pùnciri {} --> pungere {} --> prick {}
##  
{ my $search = "pùnciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pùnciri
##  	2  ==  pùnciri {} --> <br> {} --> puncture {}
##  
{ my $search = "pùnciri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pùnciri
##  	3  ==  pùnciri {} --> <br> {} --> spur {}
##  
{ my $search = "pùnciri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pùnciri
##  	4  ==  pùnciri {} --> pungere {} --> sting {}
##  
{ my $search = "pùnciri" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc pùnciri
##  	5  ==  pùnciri {} --> <br> {} --> urge {}
##  
{ my $search = "pùnciri" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc quagghiari
##  	0  ==  quagghiari {} --> coagulare {} --> clot {}
##  
{ my $search = "quagghiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc quagghiari
##  	1  ==  quagghiari {} --> rapprendersi {} --> coagulate {}
##  
{ my $search = "quagghiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc racumannari
##  	0  ==  racumannari {} --> raccomandare {} --> recommend {}
##  
{ my $search = "racumannari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc radunari
##  	3  ==  radunari {} --> radunare {} --> rally (troops) {}
##  
{ my $search = "radunari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc rallintari
##  	0  ==  rallintari {} --> <br> {} --> ease {}
##  
{ my $search = "rallintari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc raspari o rattari
##  	0  ==  raspari o rattari {} --> grattare {} --> scratch {}
##  
{ my $search = "raspari o rattari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc regnari
##  	0  ==  regnari {} --> <br> {} --> prevail {}
##  
{ my $search = "regnari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc regnari
##  	1  ==  regnari {} --> <br> {} --> reign {}
##  
{ my $search = "regnari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc rettificari
##  	0  ==  rettificari {} --> rettificare {} --> rectify {}
##  
{ my $search = "rettificari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ribbàttiri
##  	0  ==  ribbàttiri {} --> ribattere {} --> refute {}
##  
{ my $search = "ribbàttiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ribbàttiri
##  	1  ==  ribbàttiri {} --> rintuzzare {} --> refute {}
##  
{ my $search = "ribbàttiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ricchiri
##  	1  ==  ricchiri {} --> arricchire {} --> make rich {}
##  
{ my $search = "ricchiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ricunzignari
##  	0  ==  ricunzignari {} --> restituire {} --> give back {}
##  
{ my $search = "ricunzignari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ricunzignari
##  	1  ==  ricunzignari {} --> restituire {} --> restore {}
##  
{ my $search = "ricunzignari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc riddùciri
##  	0  ==  riddùciri {} --> ridurre {} --> lessen {}
##  
{ my $search = "riddùciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc riddùciri
##  	1  ==  riddùciri {} --> ridurre {} --> lower {}
##  
{ my $search = "riddùciri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ridiri
##  	0  ==  ridiri {} --> ridere {} --> laugh {}
##  
{ my $search = "ridiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ringrazziari
##  	0  ==  ringrazziari {} --> <br> {} --> give thanks {}
##  
{ my $search = "ringrazziari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ringrazziari
##  	1  ==  ringrazziari {} --> <br> {} --> show gratitude {}
##  
{ my $search = "ringrazziari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc risbigghiari
##  	0  ==  risbigghiari {} --> svegliare {} --> awaken {}
##  
{ my $search = "risbigghiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ruinari
##  	1  ==  ruinari {} --> rovinare {} --> spoil {}
##  
{ my $search = "ruinari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc runfuliari
##  	2  ==  runfuliari {} --> ronzare {} --> hum {}
##  
{ my $search = "runfuliari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc runfuliari
##  	3  ==  runfuliari {} --> russare {} --> hum {}
##  
{ my $search = "runfuliari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc rènniri
##  	0  ==  rènniri {} --> rendere {} --> give back {}
##  
{ my $search = "rènniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc rènniri
##  	4  ==  rènniri {} --> rendere {} --> yield {}
##  
{ my $search = "rènniri" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc rùmpiri
##  	0  ==  rùmpiri {} --> rompere {} --> break {}
##  
{ my $search = "rùmpiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbagghiari
##  	0  ==  sbagghiari {} --> sbagliare {} --> err {}
##  
{ my $search = "sbagghiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbagghiari
##  	1  ==  sbagghiari {} --> sbagliare {} --> make a mistake {}
##  
{ my $search = "sbagghiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbagliari
##  	0  ==  sbagliari {} --> sbagliare {} --> mistake {}
##  
{ my $search = "sbagliari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbariari
##  	0  ==  sbariari {} --> diminuire {} --> decrease {}
##  
{ my $search = "sbariari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbariari
##  	1  ==  sbariari {} --> passare {} --> disappear {}
##  
{ my $search = "sbariari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbariari
##  	2  ==  sbariari {} --> svanire {} --> disappear {}
##  
{ my $search = "sbariari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbariari
##  	4  ==  sbariari {} --> passare {} --> vanish {}
##  
{ my $search = "sbariari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbariari
##  	5  ==  sbariari {} --> svanire {} --> vanish {}
##  
{ my $search = "sbariari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbrazzari
##  	0  ==  sbrazzari {} --> <br> {} --> bare one's arms {}
##  
{ my $search = "sbrazzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbrijari
##  	0  ==  sbrijari {} --> sbrigare {} --> bring to a conclusion {}
##  
{ my $search = "sbrijari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbrucculari
##  	1  ==  sbrucculari {} --> escodellare {} --> dish out {}
##  
{ my $search = "sbrucculari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sbucciari
##  	2  ==  sbucciari {n} --> sbucciare {} --> peel {}
##  
{ my $search = "sbucciari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scadiri
##  	0  ==  scadiri {} --> scadere {} --> become due {}
##  
{ my $search = "scadiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scadiri
##  	1  ==  scadiri {} --> scadere {} --> decline (in value) {}
##  
{ my $search = "scadiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scampaniari
##  	0  ==  scampaniari {} --> squillare {} --> blare {}
##  
{ my $search = "scampaniari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scatinari
##  	0  ==  scatinari {} --> scatenare {} --> let loose {}
##  
{ my $search = "scatinari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scatinari
##  	1  ==  scatinari {} --> scatenare {} --> unchain {}
##  
{ my $search = "scatinari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scattari
##  	0  ==  scattari {} --> sanguinare (del naso) {} --> bloody nose {}
##  
{ my $search = "scattari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scattari
##  	4  ==  scattari {} --> scoppiettare {} --> crackle (fire) {}
##  
{ my $search = "scattari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc schirzari
##  	0  ==  schirzari {} --> scherzare {} --> jest {}
##  
{ my $search = "schirzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc schirzari
##  	1  ==  schirzari {} --> scherzare {} --> joke {}
##  
{ my $search = "schirzari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc schirzari
##  	2  ==  schirzari {} --> scherzare {} --> make fun (of) {}
##  
{ my $search = "schirzari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc schirzari
##  	3  ==  schirzari {} --> scherzare {} --> tease {}
##  
{ my $search = "schirzari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sciddicari
##  	0  ==  sciddicari {} --> scivolare {} --> slide {}
##  
{ my $search = "sciddicari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sciddicari
##  	1  ==  sciddicari {} --> scivolare {} --> slip {}
##  
{ my $search = "sciddicari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sciusciari
##  	1  ==  sciusciari {} --> soffiare {} --> exhale {}
##  
{ my $search = "sciusciari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sciògghiri
##  	1  ==  sciògghiri {} --> svolgere {} --> find a solution {}
##  
{ my $search = "sciògghiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scrìviri
##  	0  ==  scrìviri {} --> scrivere {v} --> attribute (to) {v}
##  
{ my $search = "scrìviri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scucchiari
##  	0  ==  scucchiari {} --> staccare {} --> detach {}
##  
{ my $search = "scucchiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scucchiari
##  	1  ==  scucchiari {} --> staccare {} --> pull off {}
##  
{ my $search = "scucchiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scuitari
##  	0  ==  scuitari {} --> stuzzicare {} --> stir {}
##  
{ my $search = "scuitari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sculari
##  	0  ==  sculari {} --> scolare {} --> drain {}
##  
{ my $search = "sculari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sculari
##  	1  ==  sculari {} --> sgocciolare {} --> drain {}
##  
{ my $search = "sculari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scummigghiari
##  	1  ==  scummigghiari {} --> scoprire {} --> expose {}
##  
{ my $search = "scummigghiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scummèttiri
##  	0  ==  scummèttiri {} --> scommettere {} --> bet {}
##  
{ my $search = "scummèttiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scummèttiri
##  	1  ==  scummèttiri {} --> scommettere {} --> wager {}
##  
{ my $search = "scummèttiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scuncicari
##  	1  ==  scuncicari {} --> stuzzichiari {} --> prick {}
##  
{ my $search = "scuncicari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scuppiari
##  	0  ==  scuppiari {} --> esplodere {} --> blow up {}
##  
{ my $search = "scuppiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scuppiari
##  	1  ==  scuppiari {} --> esplodere {} --> burst {}
##  
{ my $search = "scuppiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scuppiari
##  	2  ==  scuppiari {} --> esplodere {} --> explode {}
##  
{ my $search = "scuppiari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scupriri
##  	3  ==  scupriri {} --> scoprire {} --> find out {}
##  
{ my $search = "scupriri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scuttari
##  	0  ==  scuttari {} --> <br> {} --> discount {}
##  
{ my $search = "scuttari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc scìnniri
##  	1  ==  scìnniri {} --> scendere {} --> descend {}
##  
{ my $search = "scìnniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sentiri
##  	0  ==  sentiri {} --> ascoltare {} --> listen {}
##  
{ my $search = "sentiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sentu riri
##  	0  ==  sentu riri {} --> io affermo {} --> assert {}
##  
{ my $search = "sentu riri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
  ${dieli_sc{$search}[$index]}{"linkto"} = "sèntiri";
}

##  $ ./query-dieli.pl sc sentu riri
##  	1  ==  sentu riri {} --> io affermo {} --> hearsay {}
##  
{ my $search = "sentu riri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
  ${dieli_sc{$search}[$index]}{"linkto"} = "sèntiri";
}

##  $ ./query-dieli.pl sc serviri
##  	2  ==  serviri {} --> <br> {} --> be useful {}
##  
{ my $search = "serviri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sfardari
##  	0  ==  sfardari {} --> lacerare {} --> tear up {}
##  
{ my $search = "sfardari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sfardari
##  	1  ==  sfardari {} --> stracciare {} --> tear up {}
##  
{ my $search = "sfardari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sfari
##  	0  ==  sfari {} --> <br> {} --> kill {}
##  
{ my $search = "sfari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sfari
##  	2  ==  sfari {} --> <br> {} --> waste {}
##  
{ my $search = "sfari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sfazzari
##  	0  ==  sfazzari {} --> <br> {} --> suffer {}
##  
{ my $search = "sfazzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sfracari
##  	0  ==  sfracari {} --> sprecare {} --> squander {}
##  
{ my $search = "sfracari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sfracari
##  	1  ==  sfracari {} --> sprecare {} --> waste {}
##  
{ my $search = "sfracari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sfunnari
##  	0  ==  sfunnari {} --> sfondare {} --> break through {}
##  
{ my $search = "sfunnari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sghiddari
##  	1  ==  sghiddari {} --> scizzare {} --> slip away {}
##  
{ my $search = "sghiddari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sghiddari
##  	2  ==  sghiddari {} --> sgusciare {} --> slip away {}
##  
{ my $search = "sghiddari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sicutari
##  	0  ==  sicutari {} --> proseguire {} --> carry on {v}
##  
{ my $search = "sicutari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sicutari
##  	1  ==  sicutari {} --> <br> {} --> continue {}
##  
{ my $search = "sicutari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sicutari
##  	2  ==  sicutari {} --> seguitare {} --> continue {}
##  
{ my $search = "sicutari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sicutari
##  	3  ==  sicutari {} --> proseguire {} --> continue with {}
##  
{ my $search = "sicutari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sicutari
##  	5  ==  sicutari {} --> proseguire {} --> go on {}
##  
{ my $search = "sicutari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sicutari
##  	6  ==  sicutari {} --> seguitare {} --> go on {}
##  
{ my $search = "sicutari" ; my $index = 6 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sicutari
##  	7  ==  sicutari {} --> persistere {} --> persist {}
##  
{ my $search = "sicutari" ; my $index = 7 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc siddiarisi
##  	0  ==  siddiarisi {} --> prenderla a male {} --> be annoyed {}
##  
{ my $search = "siddiarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc siddiarisi
##  	1  ==  siddiarisi {} --> scocciarsi {} --> be bored {}
##  
{ my $search = "siddiarisi" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc siminari
##  	0  ==  siminari {} --> seminare {} --> disseminate {v}
##  
{ my $search = "siminari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc siminari
##  	1  ==  siminari {} --> seminare {} --> inseminate {v}
##  
{ my $search = "siminari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc siminari
##  	3  ==  siminari {} --> seminare {} --> seed {v}
##  
{ my $search = "siminari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc siquitari
##  	0  ==  siquitari {} --> <br> {} --> continue {}
##  
{ my $search = "siquitari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc siquitari
##  	2  ==  siquitari {} --> <br> {} --> pursue {}
##  
{ my $search = "siquitari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc smagghiari
##  	0  ==  smagghiari {} --> smagliare (pe una catena) {} --> break (eg a chain) {}
##  
{ my $search = "smagghiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sminittiari
##  	0  ==  sminittiari {} --> rovinare appositamente {} --> destroy on purpose {}
##  
{ my $search = "sminittiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sminittiari
##  	1  ==  sminittiari {} --> rovinare appositamente {} --> ruin on purpose {}
##  
{ my $search = "sminittiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sminnari
##  	1  ==  sminnari {} --> sciupare {} --> spoil {}
##  
{ my $search = "sminnari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sminnari
##  	2  ==  sminnari {} --> rovinare {} --> waste {}
##  
{ my $search = "sminnari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sminnari
##  	3  ==  sminnari {} --> sciupare {} --> waste {}
##  
{ my $search = "sminnari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc smuddicari
##  	0  ==  smuddicari {} --> sbriciolare {} --> break in pieces {}
##  
{ my $search = "smuddicari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc smòviri
##  	0  ==  smòviri {} --> rimuovere {} --> dismiss {}
##  
{ my $search = "smòviri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spaccari
##  	4  ==  spaccari {} --> spaccare {} --> split {}
##  
{ my $search = "spaccari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spacinziari
##  	0  ==  spacinziari {} --> fare perdere la pazienza {} --> lose patience {}
##  
{ my $search = "spacinziari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spagghiari
##  	3  ==  spagghiari {} --> <br> {} --> winnow {}
##  
{ my $search = "spagghiari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spampinari
##  	0  ==  spampinari {} --> togliere le foglie o i fiori {} --> lose leaves {}
##  
{ my $search = "spampinari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sparagnari
##  	0  ==  sparagnari {} --> <br> {} --> conserve {}
##  
{ my $search = "sparagnari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sparagnari
##  	1  ==  sparagnari {} --> <br> {} --> save {}
##  
{ my $search = "sparagnari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spardari
##  	0  ==  spardari {} --> strappare {} --> tear up {}
##  
{ my $search = "spardari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spardari
##  	1  ==  spardari {} --> strappare {} --> wring {}
##  
{ my $search = "spardari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spasciari
##  	0  ==  spasciari {} --> spaccare {} --> wreck {}
##  
{ my $search = "spasciari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sperdiri
##  	1  ==  sperdiri {} --> <br> {} --> lose {}
##  
{ my $search = "sperdiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spiacari
##  	0  ==  spiacari {} --> spiegare {} --> make clear {}
##  
{ my $search = "spiacari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spianari
##  	1  ==  spianari {} --> spianare {} --> level {}
##  
{ my $search = "spianari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spiari
##  	1  ==  spiari {} --> interrogare {} --> examine {}
##  
{ my $search = "spiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spidiri
##  	1  ==  spidiri {} --> spedire {} --> mail {}
##  
{ my $search = "spidiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spidiri
##  	2  ==  spidiri {} --> spedire {} --> send {}
##  
{ my $search = "spidiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spidiri
##  	3  ==  spidiri {} --> spedire {} --> ship {v}
##  
{ my $search = "spidiri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spinniciarisi
##  	0  ==  spinniciarisi {} --> scervellarsi {} --> rack one's brain {}
##  
{ my $search = "spinniciarisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spiriri
##  	2  ==  spiriri {vi} --> sparire {vi} --> disappear {vi}
##  
{ my $search = "spiriri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spirlùciri
##  	2  ==  spirlùciri {} --> rilucere {} --> shine brightly {}
##  
{ my $search = "spirlùciri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spirlùciri
##  	3  ==  spirlùciri {} --> risplendere {} --> shine brightly {}
##  
{ my $search = "spirlùciri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spirlùciri
##  	4  ==  spirlùciri {} --> rilucere {} --> sparkle {}
##  
{ my $search = "spirlùciri" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spirlùciri
##  	5  ==  spirlùciri {} --> risplendere {} --> sparkle {}
##  
{ my $search = "spirlùciri" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spriparari
##  	0  ==  spriparari {} --> sparecchiare {} --> clear away {}
##  
{ my $search = "spriparari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sprèmiri
##  	0  ==  sprèmiri {} --> <br> {} --> squeeze {}
##  
{ my $search = "sprèmiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sprèmiri
##  	1  ==  sprèmiri {} --> <br> {} --> wring {}
##  
{ my $search = "sprèmiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spugghiari
##  	0  ==  spugghiari {} --> spogliare {} --> deprive {}
##  
{ my $search = "spugghiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spugghiari
##  	1  ==  spugghiari {} --> spogliarsi {} --> disrobe {}
##  
{ my $search = "spugghiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spugghiari
##  	2  ==  spugghiari {} --> spogliare {} --> divest (of) {}
##  
{ my $search = "spugghiari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spuntari
##  	0  ==  spuntari {} --> spuntare {} --> sprout {}
##  
{ my $search = "spuntari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spusari
##  	1  ==  spusari {} --> <br> {} --> wed {}
##  
{ my $search = "spusari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spustari
##  	1  ==  spustari {} --> spostare {} --> move {}
##  
{ my $search = "spustari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spustari
##  	5  ==  spustari {} --> spostare {} --> shift {}
##  
{ my $search = "spustari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spàrtiri
##  	1  ==  spàrtiri {} --> dividere {} --> divide {}
##  
{ my $search = "spàrtiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spènniri
##  	0  ==  spènniri {} --> spendere {} --> spend {}
##  
{ my $search = "spènniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc spìnciri
##  	1  ==  spìnciri {} --> calpestare {} --> tread on {}
##  
{ my $search = "spìnciri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc squatrari
##  	0  ==  squatrari {} --> guardare attentamente {} --> describe {}
##  
{ my $search = "squatrari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc squatrari
##  	1  ==  squatrari {} --> dividere in riquadri il terreno {} --> divide up land in squares {}
##  
{ my $search = "squatrari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc squatrari
##  	2  ==  squatrari {} --> guardare attentamente {} --> look at closely {}
##  
{ my $search = "squatrari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc squatrari
##  	3  ==  squatrari {} --> scrutare {} --> measure {v}
##  
{ my $search = "squatrari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc squatrari
##  	4  ==  squatrari {} --> squadrare {} --> square {}
##  
{ my $search = "squatrari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc squatriari
##  	0  ==  squatriari {} --> squadrare {} --> square {}
##  
{ my $search = "squatriari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
  ##  ##  do NOT include this "linkto", but keep as a "reminder"
  ##  ##  "reminder" to include in the "dieli" field of the %{$vnotes{"squatrari"}}
  ##  ##  ${$dieli_sc{$search}[$index]}{"linkto"} = "squatrari";
}

##  $ ./query-dieli.pl sc stabbiliri
##  	2  ==  stabbiliri {} --> fissare {} --> stabilize {}
##  
{ my $search = "stabbiliri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc stabbiliri
##  	3  ==  stabbiliri {} --> stabilire {} --> stabilize {}
##  
{ my $search = "stabbiliri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc stancari
##  	0  ==  stancari {vi} --> riposarsi {vi} --> lie down {vi}
##  
{ my $search = "stancari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc statizzari
##  	0  ==  statizzari {vi} --> far estate {vi} --> summer {vi}
##  
{ my $search = "statizzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc stenniri
##  	0  ==  stenniri {} --> stendere {} --> hang out {}
##  
{ my $search = "stenniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc stenniri
##  	1  ==  stenniri {} --> stendere {} --> lay {}
##  
{ my $search = "stenniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc strammari
##  	1  ==  strammari {} --> sconvolgere {} --> upset {}
##  
{ my $search = "strammari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc strazzari
##  	1  ==  strazzari {} --> lacerare {} --> tear off {}
##  
{ my $search = "strazzari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc strazzari
##  	2  ==  strazzari {} --> stracciare {} --> tear off {}
##  
{ my $search = "strazzari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc strazzari
##  	3  ==  strazzari {} --> strappare {} --> tear off {}
##  
{ my $search = "strazzari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc strazzari
##  	4  ==  strazzari {} --> strappare {} --> tear up {}
##  
{ my $search = "strazzari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc strummintari
##  	0  ==  strummintari {} --> escogitare {} --> devise {}
##  
{ my $search = "strummintari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc strìnciri
##  	0  ==  strìnciri {} --> stringere {} --> squeeze {}
##  
{ my $search = "strìnciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc strìnciri
##  	1  ==  strìnciri {} --> stringere {} --> tighten {}
##  
{ my $search = "strìnciri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc stuzzicari
##  	0  ==  stuzzicari {n} --> stuzzicare {v} --> poke {v}
##  
{ my $search = "stuzzicari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc stùrciri
##  	0  ==  stùrciri {} --> storcere {} --> twist {}
##  
{ my $search = "stùrciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc stùrciri
##  	1  ==  stùrciri {} --> torcere {} --> twist {}
##  
{ my $search = "stùrciri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc stùrciri
##  	2  ==  stùrciri {} --> storcere {} --> wring out {}
##  
{ my $search = "stùrciri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc stùrciri
##  	3  ==  stùrciri {} --> torcere {} --> wring out {}
##  
{ my $search = "stùrciri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc succeriri
##  	0  ==  succeriri {} --> avvenire {} --> happen {}
##  
{ my $search = "succeriri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc succèdiri
##  	0  ==  succèdiri {} --> succedere {} --> befall {}
##  
{ my $search = "succèdiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc succèdiri
##  	2  ==  succèdiri {} --> succedere {} --> succeed (throne) {}
##  
{ my $search = "succèdiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suffriri
##  	0  ==  suffriri {} --> <br> {} --> bear {}
##  
{ my $search = "suffriri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suffriri
##  	1  ==  suffriri {} --> <br> {} --> endure {}
##  
{ my $search = "suffriri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suliri
##  	1  ==  suliri {} --> <br> {} --> be normal {}
##  
{ my $search = "suliri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suliri
##  	2  ==  suliri {} --> <br> {} --> be usual {}
##  
{ my $search = "suliri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc summergiri
##  	0  ==  summergiri {} --> <br> {} --> overwhelm {}
##  
{ my $search = "summergiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc supirari
##  	1  ==  supirari {} --> superare {} --> overtake {}
##  
{ my $search = "supirari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suppòniri
##  	0  ==  suppòniri {} --> presupporre {} --> assume {}
##  
{ my $search = "suppòniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suppòniri
##  	1  ==  suppòniri {} --> presupporre {} --> presuppose {}
##  
{ my $search = "suppòniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suppòniri
##  	2  ==  suppòniri {} --> presupporre {} --> presuppose {}
##  
{ my $search = "suppòniri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suppòniri
##  	3  ==  suppòniri {} --> presupporre {} --> suppose {}
##  
{ my $search = "suppòniri" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suprafari
##  	1  ==  suprafari {} --> <br> {} --> prevail {}
##  
{ my $search = "suprafari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suprafari
##  	2  ==  suprafari {} --> <br> {} --> win {}
##  
{ my $search = "suprafari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc supraniari
##  	2  ==  supraniari {} --> superare {} --> overcome {}
##  
{ my $search = "supraniari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc susirisi
##  	0  ==  susirisi {} --> alzarsi {} --> arise {}
##  
{ my $search = "susirisi" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suspènniri
##  	0  ==  suspènniri {} --> sospendere {} --> defer {}
##  
{ my $search = "suspènniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suspènniri
##  	2  ==  suspènniri {} --> sospendere {} --> interrupt {}
##  
{ my $search = "suspènniri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sustiniri
##  	0  ==  sustiniri {} --> sorreggere {} --> hold up {}
##  
{ my $search = "sustiniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sustiniri
##  	1  ==  sustiniri {} --> sostenere {} --> hold up {}
##  
{ my $search = "sustiniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sustiniri
##  	5  ==  sustiniri {} --> sorreggere {} --> sustain {}
##  
{ my $search = "sustiniri" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sustiniri
##  	6  ==  sustiniri {} --> sostenere {} --> sustain {}
##  
{ my $search = "sustiniri" ; my $index = 6 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suttaliniari
##  	2  ==  suttaliniari {} --> sottolineare {} --> underline {}
##  
{ my $search = "suttaliniari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suttamèttiri
##  	0  ==  suttamèttiri {} --> sottomettere {} --> subdue {}
##  
{ my $search = "suttamèttiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suttamèttiri
##  	1  ==  suttamèttiri {} --> sottomettere {} --> subject {}
##  
{ my $search = "suttamèttiri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suttamèttiri
##  	2  ==  suttamèttiri {} --> sottomettere {} --> subjugate {}
##  
{ my $search = "suttamèttiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc suttirrari
##  	0  ==  suttirrari {} --> sotterrare {} --> bury {}
##  
{ my $search = "suttirrari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc svapurari
##  	0  ==  svapurari {} --> esalare {} --> emit an odor {}
##  
{ my $search = "svapurari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc svapurari
##  	1  ==  svapurari {} --> evaporare {} --> emit an odor {}
##  
{ my $search = "svapurari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc svapurari
##  	2  ==  svapurari {} --> esalare {} --> evaporate {}
##  
{ my $search = "svapurari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc svapurari
##  	3  ==  svapurari {} --> evaporare {} --> evaporate {}
##  
{ my $search = "svapurari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc svelari
##  	0  ==  svelari {} --> scoprire {} --> expose {}
##  
{ my $search = "svelari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sìggiri
##  	0  ==  sìggiri {} --> riscuotere {} --> collect {}
##  
{ my $search = "sìggiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sòffriri
##  	0  ==  sòffriri {} --> <br> {} --> bear {}
##  
{ my $search = "sòffriri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sòffriri
##  	1  ==  sòffriri {} --> <br> {} --> manage {}
##  
{ my $search = "sòffriri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc sòffriri
##  	2  ==  sòffriri {} --> <br> {} --> sustain {}
##  
{ my $search = "sòffriri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tacchiari
##  	0  ==  tacchiari {} --> correre veloce {} --> run fast {}
##  
{ my $search = "tacchiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc taciri
##  	0  ==  taciri {} --> <br> {} --> be silent {}
##  
{ my $search = "taciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tampasiari
##  	0  ==  tampasiari {} --> andare in giro a zonzo {} --> waste time {}
##  
{ my $search = "tampasiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tappuliari
##  	0  ==  tappuliari {} --> bussare {} --> knock {}
##  
{ my $search = "tappuliari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tastari
##  	0  ==  tastari {} --> <br> {} --> sample {}
##  
{ my $search = "tastari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tastari
##  	1  ==  tastari {} --> <br> {} --> savor {}
##  
{ my $search = "tastari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tentari
##  	2  ==  tentari {} --> tentare {} --> test {}
##  
{ my $search = "tentari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tentari
##  	3  ==  tentari {} --> tentare {} --> try {}
##  
{ my $search = "tentari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ti curari
##  	0  ==  ti curari {} --> preoccuparti {} --> worry {}
##  
{ my $search = "ti curari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
  ##  ##  do NOT include this "linkto", but keep as a "reminder"
  ##  ##  "reminder" to include in the "dieli" field of %{$vnotes{"curarisi"}}
  ##  ##  ${$dieli_sc{$search}[$index]}{"linkto"} = "curarisi";
}

##  $ ./query-dieli.pl sc tinniri
##  	0  ==  tinniri {} --> mantenere {} --> maintain {}
##  
{ my $search = "tinniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tintari
##  	0  ==  tintari {} --> tentare {} --> attempt {}
##  
{ my $search = "tintari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tintari
##  	2  ==  tintari {} --> tentare {} --> tempt {}
##  
{ my $search = "tintari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tintari
##  	3  ==  tintari {} --> tentare {} --> try {}
##  
{ my $search = "tintari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc togghiri
##  	0  ==  togghiri {} --> togliere {v} --> remove {v}
##  
{ my $search = "togghiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc torciri
##  	1  ==  torciri {} --> piegare {} --> twist {}
##  
{ my $search = "torciri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc torciri
##  	2  ==  torciri {} --> torcere {} --> twist {}
##  
{ my $search = "torciri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tradùciri
##  	0  ==  tradùciri {} --> tradurre {} --> convey {}
##  
{ my $search = "tradùciri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tradùciri
##  	2  ==  tradùciri {} --> tradurre {} --> translate {}
##  
{ my $search = "tradùciri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc traficari
##  	0  ==  traficari {} --> trafficare {v} --> deal {v}
##  
{ my $search = "traficari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc traficari
##  	1  ==  traficari {} --> trafficare {v} --> do {v}
##  
{ my $search = "traficari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tralucari
##  	0  ==  tralucari {} --> trasferire {} --> move {}
##  
{ my $search = "tralucari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tralucari
##  	1  ==  tralucari {} --> traslocare {} --> move {}
##  
{ my $search = "tralucari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tralucari
##  	4  ==  tralucari {} --> trasferire {} --> transfer {}
##  
{ my $search = "tralucari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tralucari
##  	5  ==  tralucari {} --> traslocare {} --> transfer {}
##  
{ my $search = "tralucari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tramiscari
##  	0  ==  tramiscari {} --> mescolare {} --> blend {}
##  
{ my $search = "tramiscari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tramiscari
##  	1  ==  tramiscari {} --> interpolare {} --> interpolate {}
##  
{ my $search = "tramiscari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tramiscari
##  	2  ==  tramiscari {} --> interpolare {} --> mix {}
##  
{ my $search = "tramiscari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tramiscari
##  	3  ==  tramiscari {} --> mescolare {} --> mix {}
##  
{ my $search = "tramiscari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trasmìttiri
##  	2  ==  trasmìttiri {} --> trasmettere {} --> transmit {}
##  
{ my $search = "trasmìttiri" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trattari
##  	2  ==  trattari {} --> trattare {v} --> discuss {v}
##  
{ my $search = "trattari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trattari
##  	3  ==  trattari {} --> negoziare {v} --> negotiate {v}
##  
{ my $search = "trattari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trattari
##  	5  ==  trattari {} --> accogliere {v} --> receive {v}
##  
{ my $search = "trattari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trattari
##  	7  ==  trattari {} --> ospitare {v} --> welcome {v}
##  
{ my $search = "trattari" ; my $index = 7 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trattèniri
##  	0  ==  trattèniri {} --> trattenere {} --> detain {}
##  
{ my $search = "trattèniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trattèniri
##  	1  ==  trattèniri {} --> trattenere {} --> hold back {}
##  
{ my $search = "trattèniri" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trimari
##  	2  ==  trimari {} --> tremare {} --> tremble {}
##  
{ my $search = "trimari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trivuliari
##  	0  ==  trivuliari {vi} --> tribolare {vi} --> be troubled {vi}
##  
{ my $search = "trivuliari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trivuliari
##  	1  ==  trivuliari {vi} --> tribolare {vi} --> worry {vi}
##  
{ my $search = "trivuliari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trivuliari
##  	2  ==  trivuliari {vi} --> tribolare {vi} --> suffer {vi}
##  
{ my $search = "trivuliari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trucidari
##  	0  ==  trucidari {} --> <br> {} --> massacre {}
##  
{ my $search = "trucidari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc trunari
##  	0  ==  trunari {} --> tuonare {} --> thunder {}
##  
{ my $search = "trunari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc truncari
##  	0  ==  truncari {} --> interrompere {} --> break off {}
##  
{ my $search = "truncari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc truncari
##  	2  ==  truncari {} --> interrompere {} --> interrupt {}
##  
{ my $search = "truncari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc truncari
##  	3  ==  truncari {} --> interrompere {} --> terminate {}
##  
{ my $search = "truncari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc truppicari
##  	0  ==  truppicari {} --> <br> {} --> stumble {}
##  
{ my $search = "truppicari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc truppiddiari
##  	1  ==  truppiddiari {} --> camminare saltellando {} --> walk hopping {}
##  
{ my $search = "truppiddiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tuculiari
##  	0  ==  tuculiari {} --> dimenare {} --> rouse {}
##  
{ my $search = "tuculiari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tuculiari
##  	1  ==  tuculiari {} --> muovere {} --> rouse {}
##  
{ my $search = "tuculiari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tuculiari
##  	2  ==  tuculiari {} --> scuotere {} --> rouse {}
##  
{ my $search = "tuculiari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tuculiari
##  	3  ==  tuculiari {} --> dimenare {} --> stir {}
##  
{ my $search = "tuculiari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tuculiari
##  	4  ==  tuculiari {} --> muovere {} --> stir {}
##  
{ my $search = "tuculiari" ; my $index = 4 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tuculiari
##  	5  ==  tuculiari {} --> scuotere {} --> stir {}
##  
{ my $search = "tuculiari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tuculiari
##  	6  ==  tuculiari {} --> dimenare {} --> wag {}
##  
{ my $search = "tuculiari" ; my $index = 6 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tuculiari
##  	7  ==  tuculiari {} --> muovere {} --> wag {}
##  
{ my $search = "tuculiari" ; my $index = 7 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tuculiari
##  	8  ==  tuculiari {} --> scuotere {} --> wag {}
##  
{ my $search = "tuculiari" ; my $index = 8 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc turnari
##  	0  ==  turnari {} --> ritornare {} --> begin again {}
##  
{ my $search = "turnari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc tèniri
##  	0  ==  tèniri {} --> tenere {} --> keep {}
##  
{ my $search = "tèniri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ubbidiri
##  	0  ==  ubbidiri {} --> obbedire {} --> consent {}
##  
{ my $search = "ubbidiri" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc ubblicari
##  	2  ==  ubblicari {} --> obbligare {} --> require {}
##  
{ my $search = "ubblicari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc urvicari
##  	0  ==  urvicari {} --> <br> {} --> bury {}
##  
{ my $search = "urvicari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vagnari
##  	3  ==  vagnari {} --> bagnare {} --> wet {}
##  
{ my $search = "vagnari" ; my $index = 3 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vangari
##  	0  ==  vangari {} --> vangare {} --> dig {}
##  
{ my $search = "vangari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vastari
##  	1  ==  vastari {} --> sciupare {} --> spoil {}
##  
{ my $search = "vastari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc virgugnari
##  	0  ==  virgugnari {} --> <br> {} --> be_ashamed {}
##  
{ my $search = "virgugnari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
  ${dieli_sc{$search}[$index]}{"en_word"} = "be ashamed";
}

##  $ ./query-dieli.pl sc virificari
##  	0  ==  virificari {} --> verificare {} --> audit {}
##  
{ my $search = "virificari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc virnizzari
##  	0  ==  virnizzari {vi} --> fare inverno {vi} --> be winter {vi}
##  
{ my $search = "virnizzari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vulari
##  	0  ==  vulari {} --> volare {} --> fly {}
##  
{ my $search = "vulari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vulari
##  	2  ==  vulari {} --> volare {} --> go by very quickly {}
##  
{ my $search = "vulari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vurricari
##  	0  ==  vurricari {} --> seppellire {} --> bury {}
##  
{ my $search = "vurricari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vuscari
##  	1  ==  vuscari {} --> guadagnare {} --> gain {}
##  
{ my $search = "vuscari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vuscari
##  	2  ==  vuscari {} --> guadagnare {} --> make (money) {}
##  
{ my $search = "vuscari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vutari
##  	1  ==  vutari {} --> volgere {} --> turn {}
##  
{ my $search = "vutari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vutari
##  	2  ==  vutari {} --> voltare {} --> turn {}
##  
{ my $search = "vutari" ; my $index = 2 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vutari
##  	5  ==  vutari {} --> volgere {} --> vote {}
##  
{ my $search = "vutari" ; my $index = 5 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc vutari
##  	6  ==  vutari {} --> voltare {} --> vote {}
##  
{ my $search = "vutari" ; my $index = 6 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc zappari
##  	0  ==  zappari {} --> <br> {} --> hoe {}
##  
{ my $search = "zappari" ; my $index = 0 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  $ ./query-dieli.pl sc zappari
##  	1  ==  zappari {} --> zappare {} --> hoe {v}
##  
{ my $search = "zappari" ; my $index = 1 ; 
  $dieli_sc{$search}[$index] = replace_part( $dieli_sc{$search}[$index] , "v" ) ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  make ENglish and ITalian dictionaries
my %dieli_en = make_en_dict( \%dieli_sc ) ;
my %dieli_it = make_it_dict( \%dieli_sc ) ;

##  store it all
nstore( \%dieli_sc , $dieli_sc_dict );
nstore( \%dieli_en , $dieli_en_dict );
nstore( \%dieli_it , $dieli_it_dict );

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

sub replace_part {
    my $hashref = $_[0] ; 
    my $part    = $_[1] ; 
    
    ##  if the "word" field is empty (Dieli uses "<br>"), the part of speech should be empty too
    ##  issue occurs mostly with Italian, 
    ##  issue MUST NOT occur with Sicilian
    ${$hashref}{"sc_part"} = "{" . $part . "}" ; 
    ${$hashref}{"it_part"} = (${$hashref}{"it_word"} eq "<br>") ? "{}" : "{" . $part . "}" ; 
    ${$hashref}{"en_part"} = (${$hashref}{"en_word"} eq "<br>") ? "{}" : "{" . $part . "}" ; 

    return $hashref ;
}

sub make_en_dict {

    my %dieli_sc = %{ $_[0] } ;
    my %dieli_en ; 
    foreach my $sc_word ( sort keys %dieli_sc ) {	
	for my $i (0..$#{ $dieli_sc{$sc_word} }) {
	    my %sc_hash = %{ ${ $dieli_sc{$sc_word}}[$i] } ; 
	    if ($sc_hash{"en_word"} ne '<br>') {
		push( @{ $dieli_en{$sc_hash{"en_word"}} } , \%sc_hash ) ; 
	    }
	}
    }
    return %dieli_en ;
}

sub make_it_dict {
    
    my %dieli_sc = %{ $_[0] } ;
    my %dieli_it ; 
    foreach my $sc_word ( sort keys %dieli_sc ) {	
	for my $i (0..$#{ $dieli_sc{$sc_word} }) {
	    my %sc_hash = %{ ${ $dieli_sc{$sc_word}}[$i] } ; 
	    if ($sc_hash{"it_word"} ne '<br>') {
		push( @{ $dieli_it{$sc_hash{"it_word"}} } , \%sc_hash ) ; 
	    }
	}
    }
    return %dieli_it ;
}

