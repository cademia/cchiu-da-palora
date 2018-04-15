#!/usr/bin/env perl

##  "mk_verb-notes.pl" -- makes hash of verbs and adds "linkto"s to the Dieli dictionary
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

##  input and output files
my $vnotesfile = '../cgi-lib/verb-notes' ; 
my $dieli_sc_dict = '../cgi-lib/dieli-sc-dict' ; 
my $dieli_en_dict = '../cgi-lib/dieli-en-dict' ; 
my $dieli_it_dict = '../cgi-lib/dieli-it-dict' ; 

##  retrieve SiCilian
my %dieli_sc = %{ retrieve( $dieli_sc_dict ) } ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  HASH of VERBS
##  ==== == =====

my %vnotes ;

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"allungari"} } = (
    dieli => ["allungari"],
    dieli_en => ["defer","dilute","lengthen","prolong","stretch",],
    dieli_it => ["allongare","farsene","allungare","tendere",],
    part_speech => "verb",
    verb => {
	conj => "xgari", 
	stem => "allung" ,
	boot => "allòng",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"àpriri"} } = (
    dieli => ["apriri",],
    dieli_en => ["unfurl","unlock",],
    dieli_it => ["aprire",],
    part_speech => "verb",
    verb => {
	conj => "xxiri",
	stem => "apr",
	boot => "àpr",
    },);
%{ $vnotes{"gràpiri"} } = (
    dieli => ["gràpiri","ràpiri","apiri"],
    dieli_en => ["open",],
    dieli_it => ["aprire",],
    part_speech => "verb",
    verb => {
	conj => "xxiri",
	stem => "grap",
	boot => "gràp",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"aspittari"} } = (
    dieli => ["aspittari"],
    dieli_en => ["await","expect","hold on","wait",],
    dieli_it => ["aspettare","reggersi",],
    part_speech => "verb",
    verb => {
	conj => "xxari", 
	stem => "aspitt" ,
	boot => "aspètt",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"aviri"} } = (
    dieli => ["aviri"],
    dieli_en => ["have","possess",],  ## "own (property)",
    dieli_it => ["avere",],
    part_speech => "verb",
    verb => {
	conj => "xxiri", 
	stem => "av",
	boot => "hàv",
	irrg => {
	    inf => "aviri",
	    pri => { us => "haiu", ds => "hai", tp => "hannu"},
	    pim => { ds => "hai"}, 
	    pai => { quad => "àpp"},
	    fti => { stem => "avir" },
	    coi => { stem => "avir" },
	},
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"campari"} } = (
    dieli => ["campari",],
    dieli_en => ["be alive","live",],
    dieli_it => [],
    part_speech => "verb",
    verb => {
	conj => "xxari",
	stem => "camp",
	boot => "càmp",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"canciari"} } = (
    dieli => ["canciari",],
    dieli_en => ["alter","change","exchange","modify","switch","vary",],
    dieli_it => ["cambiare",],
    part_speech => "verb",
    verb => {
	conj => "ciari",
	stem => "canci",
	boot => "cànci",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"canciarisi"} } = (
    dieli => ["canciarisi"],
    dieli_en => ["change",],
    dieli_it => ["cambiarsi",],
    part_speech => "verb",
    reflex => "canciari",
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"canùsciri"} } = (
    dieli => ["canusciri",],
    dieli_en => ["know","see",],
    dieli_it => ["conoscere",],
    part_speech => "verb",
    verb => {
	conj => "xxiri",
	stem => "canusc",
	boot => "canùsc", 
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"capiri"} } = (
    dieli => ["capiri","capìri",],
    dieli_en => ["catch","grasp","see",],  
    dieli_it => ["entrarci","starci","capire",],
    part_speech => "verb",
    verb => {
	conj => "sciri", 
	stem => "cap",
	boot => "capìsc",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"circari"} } = (
    dieli => ["circari",],
    dieli_en => ["hunt for","look for","search","seek","try",],
    dieli_it => ["cercare",],
    part_speech => "verb",
    verb => {
	conj => "xcari",
	stem => "circ",
	boot => "cèrc",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"chiamari"} } = (
    dieli => ["chiamari",],
    dieli_en => ["call","call out","cry","name",],
    dieli_it => ["chiamare",],
    part_speech => "verb",
    verb => {
	conj => "xxari",
	stem => "chiam",
	boot => "chiàm",
    },);
%{ $vnotes{"chiamarisi"} } = (
    dieli => ["chiamarisi"],
    dieli_en => ["called (be)","named",],
    dieli_it => [],
    part_speech => "verb",
    reflex => "chiamari",
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"chiùdiri"} } = (
    dieli => ["chiùdiri","chiudiri"],
    dieli_en => ["fasten","shut","close",],
    dieli_it => ["chiudere",],
    part_speech => "verb",  
    verb => {
	conj => "xxiri", 
	stem => "chiud",
	boot => "chiùd",
	irrg => {
	    adj => "chiusu",
	},
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"crìdiri"} } = (
    dieli => ["cridiri"],
    dieli_en => ["believe","guess","reckon","think",],
    dieli_it => ["credere",],
    part_speech => "verb",    
    verb => {
	conj => "xxiri", 
	stem => "crid",
	boot => "crìd",
	irrg => {
	    pai => { quad => "crìtt" },
	}, 
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cummattiri"} } = (
    dieli => ["cummattiri",],
    dieli_en => ["annoy","assault","battle","be busy","combat","compete","deal","fight","struggle",],
    dieli_it => ["combattere","avere a che fare","competere",],
    ## notex => ["","",],
    part_speech => "verb",
    verb => {
	conj => "xxiri",
	stem => "cummatt",
	boot => "cummàtt",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cumunicari"} } = (
    dieli => ["cumunicari",],
    dieli_en => ["communicate","inform","participate",],
    dieli_it => ["comunicare",],
    part_speech => "verb",
    verb => {
	conj => "xcari",
	stem => "cumunic",
	boot => "cumunìc", 
    },);
%{ $vnotes{"cumunicarisi"} } = (
    dieli => ["cumunicarisi","cuminicarisi",],
    dieli_en => ["receive communion",],
    dieli_it => ["comunicarsi",],
    part_speech => "verb",
    reflex => "cumunicari",
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cunzigghiari"} } = (
    dieli => ["cunzigghiari",],
    dieli_en => ["advise","counsel",],
    dieli_it => ["consigliare",],
    part_speech => "verb",
    verb => {
	conj => "xiari",
	stem => "cunzigghi",
	boot => "cunzigghì", 
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

##	0  ==  cusiri {v} --> <br> {v} --> stitch {v}
## 	0  ==  cùsiri {v} --> cucire {v} --> sew {v}

%{ $vnotes{"cusiri"} } = (
    dieli => ["cusiri","cùsiri",],
    dieli_en => ["stitch","sew",],
    dieli_it => ["cucire",],
    part_speech => "verb",
    verb => {
	conj => "xxiri",
	stem => "cus",
	boot => "cùs",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"dari"} } = (
    dieli => ["dari"],
    dieli_en => ["award","give","pass",],
    dieli_it => ["aggiudicare","dare",],
    part_speech => "verb",    
    verb => {
	conj => "xxari", 
	stem => "d",
	boot => "dùn",
	irrg => {
	    pri => { us => "dugnu", }, 
	    pai => { quad => "dètt" },
	    fti => { stem => "dar" },
	    coi => { stem => "dar" },
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"diri"} } = (
    dieli => ["diri"],
    dieli_en => ["say","tell","utter",],
    dieli_it => ["dire",],
    part_speech => "verb",    
    verb => {
	conj => "xxiri", 
	stem => "dic",
	boot => "dìc",
	irrg => {
	    inf => "diri",
	    pai => { quad => "dìss" },
	    pap => "dittu",
	    adj => "dittu",
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"èssiri"} } = (
    dieli => ["essiri"],
    dieli_en => ["be","being",],
    dieli_it => ["essere",],
    part_speech => "verb",    
    verb => {
	conj => "xxiri", 
	stem => "ess",
	boot => "èss",
	irrg => {
	    pri => { us => "sugnu", ds => "sì", ts => "è", up => "semu", dp => "siti", tp => "sunnu"},
	    pim => { ds => "sia", ts => "fussi", up => "semu", dp => "siti", tp => "fùssiru"},
	    pai => { us => "fui", ds => "fusti", ts => "fu", up => "fomu", dp => "fùstivu", tp => "foru"},
	    imi => { us => "era", ds => "eri", ts => "era", up => "eramu", dp => "eravu", tp => "eranu"},
	    ims => { us => "fussi", ds => "fussi", ts => "fussi", up => "fùssimu", dp => "fùssivu", tp => "fùssiru"},
	    fti => { stem => "sa" },
	    coi => { stem => "sa" },
	    pap => "statu",
	    adj => "statu",
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"fari"} } = (
    dieli => ["fari"],
    dieli_en => ["act","do","have","make",],
    dieli_it => ["fare",],
    part_speech => "verb",
    verb => {
	conj => "xxiri", 
	stem => "fac",
	boot => "fàc",
	irrg => {
	    inf => "fari",
	    pri => { us => "fazzu", ds => "fai", ts => "fa", tp => "fannu" },
	    pim => { ds => "fazza" },
	    pai => { quad => "fìc" },
	    fti => { stem => "far" }, 
	    coi => { stem => "far" }, 
	    pap => "fattu",
	    adj => "fattu",
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"finiri"} } = (
    dieli => ["finiri"],
    dieli_en => ["bring to completion","end","expire","finish",],
    dieli_it => ["finire","smettere (sogg animati)",],
    part_speech => "verb",    
    verb => {
	conj => "sciri", 
	stem => "fin",
	boot => "finìsc",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"jiri"} } = (
    dieli => ["iri"],
    dieli_en => ["go",],
    dieli_it => ["andare",],
    notex => ["Vaju a accattu li scarpi.","Jemu a accattari li scarpi.",],
    part_speech => "verb",    
    verb => {
	conj => "xxiri", 
	stem => "j",
	boot => "va",
	irrg => {
	    inf => "jiri",
	    pri => { us => "vaju", ts => "va", tp => "vannu" }, 
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"jucari"} } = (
    dieli => ["iucari",],
    dieli_en => ["gamble","play",],
    dieli_it => ["giocare",],
    part_speech => "verb",
    verb => {
	conj => "xcari",
	stem => "juc",
	boot => "jòc",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"manciari"} } = (
    dieli => ["manciari"],
    dieli_en => ["corrode","eat","itch","overwhelm","squander",],
    dieli_it => ["mangiare","avere il prurito","prudere",],
    part_speech => "verb",
    verb => {
	conj => "ciari", 
	stem => "manci" ,
	boot => "mànci",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

##	0  ==  mettiri {v} --> porre {v} --> place {v}
##	1  ==  mettiri {v} --> mettere {v} --> put {v}
##	2  ==  mettiri {v} --> <br> {v} --> start {v}
##
%{ $vnotes{"mèttiri"} } = (
    dieli => ["mettiri"],
    dieli_en => ["place","put","start",],
    dieli_it => ["porre","mettere",],
    part_speech => "verb",    
    verb => {
	conj => "xxiri", 
	stem => "mitt",
	boot => "mètt",
	irrg => {
	    pai => { quad => "mìs" },
	    pap => "misu",
	    adj => "misu",
	},		
    },);

##	0  ==  ammettiri {v} --> ammettere {v} --> confess {v}
##
%{ $vnotes{"ammettiri"} } = (
    dieli => ["ammettiri",],
    dieli_en => ["confess",],
    dieli_it => ["ammettere",],
    part_speech => "verb",
    prepend => { prep => "am", verb => "mèttiri", },
    );

##	0  ==  cummèttiri {v} --> commettere {v} --> assemble {v}
##	1  ==  cummèttiri {v} --> commettere {v} --> commit {v}
##	2  ==  cummèttiri {v} --> commettere {v} --> fit together {v}
##
##	0  ==  cummettiri {v} --> commettere {v} --> commit {v}
##
%{ $vnotes{"cummèttiri"} } = (
    dieli => ["cummèttiri","cummettiri",],
    dieli_en => ["assemble","commit","fit together",],
    dieli_it => ["commettere",],
    part_speech => "verb",
    prepend => { prep => "cum", verb => "mèttiri", },
    );

##	0  ==  cumprummettiri {v} --> compromettere {} --> compromise {v}
##
%{ $vnotes{"cumprummettiri"} } = (
    dieli => ["cumprummettiri",],
    dieli_en => ["compromise",],
    dieli_it => ["compromettere",],
    part_speech => "verb",
    prepend => { prep => "cumprum", verb => "mèttiri", },
    );

##	0  ==  emettiri {v} --> emettere {v} --> utter {v}
##
%{ $vnotes{"emettiri"} } = (
    dieli => ["emettiri",],
    dieli_en => ["utter",],
    dieli_it => ["emettere",],
    part_speech => "verb",
    prepend => { prep => "e", verb => "mèttiri", },
    );

##	0  ==  intromettirisi {v} --> intromettersi in {v} --> interfere in {v}
##
%{ $vnotes{"intromèttiri"} } = (
    hide => 1,
    part_speech => "verb",
    prepend => { prep => "intro", verb => "mèttiri", },
    );
%{ $vnotes{"intromèttirisi"} } = (
    dieli => ["intromettirisi"],
    dieli_en => ["interfere in",],
    dieli_it => ["intromettersi in",],
    part_speech => "verb",
    reflex => "intromèttiri",
    );

##	0  ==  omettiri {v} --> omettere {v} --> omit {v}
##	1  ==  omettiri {v} --> omettere {v} --> skip {v}
##
%{ $vnotes{"omèttiri"} } = (
    dieli => ["omettiri",],
    dieli_en => ["omit","skip",],
    dieli_it => ["omettere",],
    part_speech => "verb",
    prepend => { prep => "o", verb => "mèttiri", },
    );

##	0  ==  pirmèttiri {v} --> permettere {v} --> enable {v}
##	1  ==  pirmèttiri {v} --> permettere {v} --> permit {v}
##
##	0  ==  primettiri {v} --> permettere {v} --> permit {v}
##
%{ $vnotes{"pirmèttiri"} } = (
    dieli => ["pirmèttiri","primettiri",],
    dieli_en => ["enable","permit",],
    dieli_it => ["permettere",],
    part_speech => "verb",
    prepend => { prep => "pir", verb => "mèttiri", },
    );

##	0  ==  prumèttiri {v} --> promettere {v} --> promise {v}
##
%{ $vnotes{"prumèttiri"} } = (
    dieli => ["prumèttiri","prumìettiri",],
    dieli_en => ["promise",],
    dieli_it => ["promettere",],
    part_speech => "verb",
    prepend => { prep => "pru", verb => "mèttiri", },
    );

##	0  ==  rimettiri {v} --> scusare {v} --> forgive {v}
##	1  ==  rimettiri {v} --> rimettere {v} --> remit {v}
##
%{ $vnotes{"rimèttiri"} } = (
    dieli => ["rimettiri",],
    dieli_en => ["forgive","remit",],
    dieli_it => ["scusare","rimettere",],
    part_speech => "verb",
    prepend => { prep => "ri", verb => "mèttiri", },
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"scrìviri"} } = (
    dieli => ["scrìviri",],
    dieli_en => ["attribute (to)","record","write",],
    dieli_it => ["scrivere",],
    part_speech => "verb",
    verb => {
	conj => "xxiri",
	stem => "scriv",
	boot => "scrìv",
    },);

%{ $vnotes{"discrìviri"} } = (
    dieli => ["discrìviri",],
    dieli_en => ["describe","relate","trace",],
    dieli_it => ["descrivere",],
    part_speech => "verb",
    prepend => { prep => "dis", verb => "scrìviri", },
    );

%{ $vnotes{"iscriviri"} } = (
    hide => 1,
    part_speech => "verb",
    prepend => { prep => "i", verb => "scrìviri", },
    );
%{ $vnotes{"iscrivirisi"} } = (
    dieli => ["iscrivirisi"],
    dieli_en => ["enter",],
    dieli_it => ["iscrivere",],
    part_speech => "verb",
    reflex => "iscriviri",
    );

%{ $vnotes{"suttascriviri"} } = (
    dieli => ["suttascriviri",],
    dieli_en => ["book","sign",],
    dieli_it => ["iscrivere","sottoscrivere",],
    part_speech => "verb",
    prepend => { prep => "sutta", verb => "scrìviri", },
    );

##	0  ==  scummèttiri {v} --> scommettere {v} --> bet {v}
##	1  ==  scummèttiri {v} --> scommettere {v} --> wager {v}
##
%{ $vnotes{"scummèttiri"} } = (
    dieli => ["scummèttiri",],
    dieli_en => ["bet","wager",],
    dieli_it => ["scommettere",],
    part_speech => "verb",
    prepend => { prep => "scum", verb => "mèttiri", },
    );

##	0  ==  smettiri {v} --> provocare {v} --> arouse {v}
##	1  ==  smettiri {v} --> provocare {v} --> cause {v}
##	2  ==  smettiri {v} --> desistere {v} --> give up {v}
##	3  ==  smettiri {v} --> provocare {v} --> provoke {v}
##	4  ==  smettiri {v} --> smettere {v} --> stop {v}
##
%{ $vnotes{"smèttiri"} } = (
    dieli => ["smettiri",],
    dieli_en => ["arouse","cause","give up","provoke","stop",],
    dieli_it => ["provocare","desistere","smettere",],
    part_speech => "verb",
    prepend => { prep => "s", verb => "mèttiri", },
    );

##	0  ==  suttamèttiri {v} --> sottomettere {v} --> subdue {v}
##	1  ==  suttamèttiri {v} --> sottomettere {v} --> subject {v}
##	2  ==  suttamèttiri {v} --> sottomettere {v} --> subjugate {v}
##	3  ==  suttamèttiri {v} --> sottomettere {v} --> submit {v}
##
%{ $vnotes{"suttamèttiri"} } = (
    dieli => ["suttamèttiri",],
    dieli_en => ["subdue","subject","subjugate","submit",],
    dieli_it => ["sottomettere",],
    part_speech => "verb",
    prepend => { prep => "sutta", verb => "mèttiri", },
    );

##	0  ==  trasmettiri {v} --> trasmettere {v} --> broadcast {v}
##	1  ==  trasmettiri {v} --> telegrafare {v} --> cable {v}
##
##	0  ==  trasmìttiri {v} --> trasmettere {v} --> broadcast {v}
##	1  ==  trasmìttiri {v} --> trasmettere {v} --> forward {v}
##	2  ==  trasmìttiri {v} --> trasmettere {v} --> transmit {v}
##  
%{ $vnotes{"trasmèttiri"} } = (
    dieli => ["trasmettiri","trasmìttiri",],
    dieli_en => ["broadcast","transmit","forward","cable",],
    dieli_it => ["trasmettere","telegrafare",],
    part_speech => "verb",
    prepend => { prep => "tras", verb => "mèttiri", },
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"mòriri"} } = (
    dieli => ["moriri","muriri"],
    dieli_en => ["depart","die","die out","fade","perish",],  ## "come an end",
    dieli_it => ["morire","trapassare",],
    part_speech => "verb",
    verb => {
	conj => "xxiri", 
	stem => "mur" ,
	boot => "mòr",
	irrg => { 
	    pap => "mortu",
	    adj => "mortu",
	},
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"mparari"} } = (
    dieli => ["mparari"],
    dieli_en => ["learn",],
    dieli_it => ["imparare",],
    part_speech => "verb",
    verb => {
	conj => "xxari", 
	stem => "mpar" ,
	boot => "mpàr",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"ntènniri"} } = (
    dieli => ["ntenniri","intenniri",],
    dieli_en => ["hear","understand",],
    dieli_it => ["sentire",],
    part_speech => "verb",
    verb => {
	conj => "xxiri",
	stem => "ntinn", 
	boot => "ntènn",
	irrg => {
	    pai => { quad => "ntìs" },
	    pap => "ntisu",
	    adj => "ntisu",
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"nzignari"} } = (
    dieli => ["nzignari","inzignari",],
    dieli_en => ["teach",],
    dieli_it => ["insegnare",],
    part_speech => "verb",
    verb => {
	conj => "xxari",
	stem => "nzign",
	boot => "nzìgn", 
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

##  ORIGINAL
##  ========
##  $ ./query-dieli.pl sc pari
##  	0  ==  pari {} --> manifesta {} --> be revealed {}
##  	1  ==  pari {v} --> <br> {v} --> seem {v}
##  	2  ==  pari {} --> <br> {} --> show {}
##  $ ./query-dieli.pl sc pariri  
##  	1  ==  pariri {v} --> apparire {v} --> appear {v}
##  	4  ==  pariri {v} --> parere {v} --> seem {v}
##  	5  ==  pariri {v} --> <br> {v} --> think (seem) {v}
##  $ ./query-dieli.pl sc pàriri
##  	0  ==  pàriri {v} --> sembrare {} --> look like {}

%{ $vnotes{"pàriri"} } = (
    dieli => ["pàriri","pariri","pari"],
    dieli_en => ["appear","look like","seem","think (seem)",],
    dieli_it => ["apparire","parere","sembrare",],
    part_speech => "verb",
    verb => {
	conj => "xxiri", 
	stem => "par",
	boot => "pàr",
	irrg => {
	    pai => { quad => "pàrs" },
	    adj => "parsu",
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"parrari"} } = (
    dieli => ["parrari"],
    dieli_en => ["discuss","speak",],
    dieli_it => ["discutere","parlare",],
    notex => ["Parru cu tia, to è la curpa.",],
    part_speech => "verb", 
    verb => {
	conj => "xxari", 
	stem => "parr" ,
	boot => "pàrr",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pèrdiri"} } = (
    dieli => ["perdiri"],
    dieli_en => ["lose",],
    dieli_it => ["perdere",],
    part_speech => "verb", 
    verb => {
	conj => "xxiri",
	stem => "pird", 
	boot => "pèrd",
	irrg => {
	    pai => { quad => "pèrs" },
	    adj => "persu",
	},	
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

##	0  ==  pinzari {v} --> pensare {v} --> believe {v}
##	1  ==  pinzari {v} --> pensare {v} --> imagine {v}
##	2  ==  pinzari {v} --> pensare {v} --> think {v}
##	0  ==  ricumpinzari {v} --> ricompensare {v} --> reward {v}

##	0  ==  pinsari {v} --> pensare {v} --> think {v}
##	0  ==  cumpinsari {v} --> compensare {v} --> compensate {v}
##	1  ==  cumpinsari {v} --> <br> {v} --> remunerate {v}

%{ $vnotes{"pinzari"} } = (
    dieli => ["pinzari","pinsari",],
    dieli_en => ["believe","imagine","think",],
    dieli_it => ["pensare",],
    part_speech => "verb",
    verb => {
	conj => "xxari",
	stem => "pinz",
	boot => "pènz",
    },);

%{ $vnotes{"cumpinzari"} } = (
    dieli => ["cumpinsari",],
    dieli_en => ["compensate","remunerate",],
    dieli_it => ["compensare",],
    part_speech => "verb",
    prepend => { prep => "cum", verb => "pinzari"},
    );

%{ $vnotes{"ricumpinzari"} } = (
    dieli => ["ricumpinzari",],
    dieli_en => ["reward",],
    dieli_it => ["ricompensare",],
    part_speech => "verb",
    prepend => { prep => "ricum", verb => "pinzari"},
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

##	0  ==  poniri {v} --> posare {v} --> place {v}
##	1  ==  poniri {v} --> mettere {v} --> set {v}
##
%{ $vnotes{"pòniri"} } = (
    dieli => ["poniri"],
    dieli_en => ["place","set",],
    dieli_it => ["posare","mettere",],
    part_speech => "verb",
    verb => {
	conj => "xxiri", 
	stem => "pun",
	boot => "pòn",
	    irrg => {
		pri => { us => "pognu" },
		pim => { ds => "pogna" },
		pai => { quad => "pòs" },
		pap => "postu",
		adj => "postu",
	},		
    },);


##	0  ==  cumpòniri {v} --> comporre {v} --> arrange {v}
##	1  ==  cumpòniri {v} --> comporre {v} --> compose {v}
##	2  ==  cumpòniri {v} --> comporre {v} --> put together {v}
##
%{ $vnotes{"cumpòniri"} } = (
    dieli => ["cumpòniri",],
    dieli_en => ["arrange","compose","put together",],
    dieli_it => ["comporre",],
    part_speech => "verb",
    prepend => { prep => "cum", verb => "pòniri"},
    );

##	0  ==  deponiri {v} --> deporre {} --> deposit {v}
##
%{ $vnotes{"deponiri"} } = (
    dieli => ["deponiri",],
    dieli_en => ["deposit",],
    dieli_it => ["deporre",],
    part_speech => "verb",
    prepend => { prep => "de", verb => "pòniri"},
    );

##	0  ==  dispòniri {v} --> disporre di {v} --> dispose of {v}
##
%{ $vnotes{"dispòniri"} } = (
    dieli => ["dispòniri",],
    dieli_en => ["dispose of",],
    dieli_it => ["disporre di",],
    part_speech => "verb",
    prepend => { prep => "dis", verb => "pòniri"},
    );

##	0  ==  imponiri {v} --> <br> {v} --> compel {v}
##	0  ==  mpòniri {v} --> imporre  {v} --> impose  {v}
##
%{ $vnotes{"mpòniri"} } = (
    dieli => ["mpòniri","imponiri",],
    dieli_en => ["impose","compel",],
    dieli_it => ["imporre",],
    part_speech => "verb",
    prepend => { prep => "m", verb => "pòniri", },
    );

##	0  ==  interponirisi {v} --> <br> {v} --> mediate {v}
##
%{ $vnotes{"interpòniri"} } = (
    hide => 1,
    part_speech => "verb",
    prepend => { prep => "inter", verb => "pòniri", },
    );
%{ $vnotes{"interpònirisi"} } = (
    dieli => ["interponirisi"],
    dieli_en => ["mediate",],
    dieli_it => [],
    part_speech => "verb",
    reflex => "interpòniri",
    );

##	0  ==  opponirisi {v} --> opporsi {v} --> oppose {v}
##
%{ $vnotes{"oppòniri"} } = (
    hide => 1,
    part_speech => "verb",
    prepend => { prep => "op", verb => "pòniri", },
    );
%{ $vnotes{"oppònirisi"} } = (
    dieli => ["opponirisi"],
    dieli_en => ["oppose",],
    dieli_it => ["opporsi",],
    part_speech => "verb",
    reflex => "oppòniri",
    );

##	0  ==  posponiri {v} --> <br> {v} --> postpone {v}
##	1  ==  posponiri {v} --> rinviare {v} --> put off {v}
##
%{ $vnotes{"posponiri"} } = (
    dieli => ["posponiri",],
    dieli_en => ["postpone","put off",],
    dieli_it => ["rinviare",],
    part_speech => "verb",
    prepend => { prep => "pos", verb => "pòniri", },
    );

##	0  ==  proponiri {v} --> proporre {v} --> propose {v}
##	1  ==  proponiri {v} --> raccomandare {v} --> recommend {v}
##
##	0  ==  prupòniri {v} --> proporre  {v} --> propose  {v}
##
%{ $vnotes{"prupòniri"} } = (
    dieli => ["prupòniri","proponiri",],
    dieli_en => ["propose","recommend",],
    dieli_it => ["proporre","raccomandare",],
    part_speech => "verb",
    prepend => { prep => "pru", verb => "pòniri", },
   );

##	0  ==  suppòniri {v} --> presupporre {v} --> assume {v}
##	1  ==  suppòniri {v} --> presupporre {v} --> presuppose {v}
##	2  ==  suppòniri {v} --> presupporre {v} --> presuppose {v}
##	3  ==  suppòniri {v} --> presupporre {v} --> suppose {v}
##
##	0  ==  supponiri {v} --> supporre {v} --> suspect {v}
##
%{ $vnotes{"suppòniri"} } = (
    dieli => ["suppòniri","supponiri",],
    dieli_en => ["assume","presuppose","suppose","suspect",],
    dieli_it => ["presupporre","supporre",],
    part_speech => "verb",
    prepend => { prep => "sup", verb => "pòniri", },
    );

##	0  ==  suttaponiri {v} --> sottomettere {v} --> subject {v}
##
%{ $vnotes{"suttapòniri"} } = (
    dieli => ["suttaponiri",],
    dieli_en => ["subject",],
    dieli_it => ["sottomettere",],
    part_speech => "verb",
    prepend => { prep => "sutta", verb => "pòniri", },
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"purtari"} } = (
    dieli => ["purtari"],
    dieli_en => ["bear","bring","carry","fetch",],
    dieli_it => ["portare",],
    part_speech => "verb",
    verb => {
	conj => "xxari", 
	stem => "purt",
	boot => "pòrt",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"putiri"} } = (
    dieli => ["putiri"],
    dieli_en => ["able","be able to","can","may","might",],
    dieli_it => ["poter fare","potere",],
    part_speech => "verb", 
    verb => {
	conj => "xxiri", 
	stem => "put",
	boot => "pùt",
	irrg => {
	    inf => "putiri",
	    pri => { us => "pozzu", ds => "poi", ts => "pò", tp => "ponnu" },
	    pim => { ds => "pozza"},
	    pai => { quad => "pòtt" },
	},
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"ripètiri"} } = (
    dieli => ["ripetiri"],
    dieli_en => ["harp","repeat",],
    dieli_it => ["ripetere",],
    part_speech => "verb", 
    verb => {
	conj => "xxiri", 
	stem => "ripit",
	boot => "ripèt",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

##	0  ==  rispùnniri {v} --> respondere {v} --> reply {v}
##	1  ==  rispùnniri {v} --> respondere {v} --> respond {v}
##
##	0  ==  rispunniri {v} --> rispondere {v} --> answer {v}
##
##	0  ==  arruspùnniri {v} --> respondere {v} --> reply {v}
##	1  ==  arruspùnniri {v} --> respondere {v} --> respond {v}
##
%{ $vnotes{"rispùnniri"} } = (
    dieli => ["rispùnniri","rispunniri","arruspùnniri",],
    dieli_en => ["answer","reply","respond",],
    dieli_it => ["respondere",],
    part_speech => "verb",
    verb => {
	conj => "xxiri", 
	stem => "rispunn",
	boot => "rispùnn",
	irrg => {
	    adj => "rispostu",
	},
    },);

##	0  ==  currispùnniri {v} --> correspondere {v} --> coincide {v}
##	1  ==  currispùnniri {v} --> correspondere {v} --> correspond {v}
##
##	0  ==  corrispunniri {v} --> corrispondere {v} --> correspond {v}
##  
%{ $vnotes{"currispùnniri"} } = (
    dieli => ["currispùnniri","corrispunniri",],
    dieli_en => ["correspond","coincide",],
    dieli_it => ["corrispondere","correspondere",],
    part_speech => "verb",
    prepend => { prep => "cur", verb => "rispùnniri", },
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"sapiri"} } = (
    dieli => ["sapiri"],
    dieli_en => ["have knowledge","know","know how","know something","taste",],
    dieli_it => ["sapere","assaggiare",],
    part_speech => "verb", 
    verb => {
	conj => "xxiri", 
	stem => "sap",
	boot => "sàp",
	irrg => {
	    inf => "sapiri",
	    pri => { us => "sacciu", ds => "sai", tp => "sannu" },
	    pai => { quad => "sàpp" },
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"sèntiri"} } = (
    dieli => ["sèntiri","sentiri (ntisi)","sentu riri",],
    dieli_en => ["feel","hear","listen","sense","smell",],
    dieli_it => ["sentire",], 
    part_speech => "verb", 
    verb => {
	conj => "xxiri", 
	stem => "sint",
	boot => "sènt",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"stari"} } = (
    dieli => ["stari"],
    dieli_en => ["be","dwell","inhabit","live (in a place)","persevere","remain","reside","stay",],
    dieli_it => ["stare","abitare","restare",],
    part_speech => "verb",
    verb => {
	conj => "xxari", 
	stem => "st",
	boot => "st",
	irrg => {
	    pri => { us => "staiu", ds => "stai", tp => "stannu" },
	    pai => { quad => "stètt" },
	    fti => { stem => "sta" },
	    coi => { stem => "sta" },
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"studiari"} } = (
    dieli => ["studiari"],
    dieli_en => ["study",],
    dieli_it => ["studiare",],
    part_speech => "verb",    
    verb => {
	conj => "xiari", 
	stem => "studi" ,
	boot => "studì",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"taliari"} } = (
    dieli => ["taliari"],
    dieli_en => ["look","look at",],
    dieli_it => ["guardare",],
    notex => ["Taliu i picciriddi ca jòcanu.","Taliamu a partita ô stadiu.","Talia chi tràficu!",],
    part_speech => "verb", 
    verb => {
	conj => "xiari", 
	stem => "tali" ,
	boot => "talì",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"tèniri"} } = (
    dieli => ["teniri"],
    dieli_en => ["hold","possess",],
    dieli_it => ["tenere",], 
    part_speech => "verb", 
    verb => {
	conj => "xxiri", 
	stem => "tin",
	boot => "tèn",
	irrg => {
	    pri => { us => "tegnu" },
	    pim => { ds => "tegna" },
	    pai => { quad => "tìnn" },
	},
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"turnari"} } = (
    dieli => ["turnari",],
    dieli_en => ["begin again","return",],
    dieli_it => ["ritornare",],
    notex => ["Tornu a cercu a me anneddu pirdutu.","Turnamu a circari a so anneddu pirdutu."],
    part_speech => "verb",
    verb => {
	conj => "xxari",
	stem => "turn",
	boot => "tòrn",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"travagghiari"} } = (
    dieli => ["travagghiari",],
    dieli_en => ["work",],
    dieli_it => ["lavorare",],
    part_speech => "verb",
    verb => {
	conj => "xiari",
	stem => "travagghi",
	boot => "travagghì",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"vardari"} } = (
    dieli => ["vardari"],
    dieli_en => ["look at","look out for","notice",],
    dieli_it => ["guardare",],
    part_speech => "verb", 
    verb => {
	conj => "xxari", 
	stem => "vard" ,
	boot => "vàrd",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"vèniri"} } = (
    dieli => ["veniri"],
    dieli_en => ["arrive","come","reach",],
    dieli_it => ["venire",],
    notex => ["Û vegnu a pigghiu.","Û vinemu a pigghiari.","Iddu ti veni a vidi.",],
    part_speech => "verb", 
    verb => {
	conj => "xxiri", 
	stem => "vin",
	boot => "vèn",
	irrg => {
	    pri => { us => "vegnu" },
	    pim => { ds => "vegna" },
	    pai => { quad => "vìnn" },
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"vìdiri"} } = (
    dieli => ["vidiri"],
    dieli_en => ["notice","see",],
    dieli_it => ["vedere",],
    part_speech => "verb", 
    verb => {
	conj => "xxiri", 
	stem => "vid",
	boot => "vìd",
	irrg => {
	    pri => { us => "viu"  },
	    pai => { quad => "vìtt" },
	    adj => "vistu",
	},		
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

##  ORIGINAL
##  ========
##  $ ./query-dieli.pl sc vèstiti 
##  	0  ==  vèstiti {v} --> <br> {v} --> dress {v}
##  	1  ==  vèstiti {} --> <br> {} --> dress up {}
##  	2  ==  vèstiti {v} --> <br> {} --> put on clothing {v}
##  $ ./query-dieli.pl sc vistiri
##  	0  ==  vistiri {v} --> vestire {v} --> dress {v}
##  $ ./query-dieli.pl sc vistirisi
##  	0  ==  vistirisi {v} --> vestirsi {v} --> dress oneself {v}
##  	1  ==  vistirisi {v} --> <br> {v} --> get dressed {v}

%{ $vnotes{"vistiri"} } = (
    dieli => ["vistiri","vistirisi","vèstiti"],
    dieli_en => ["dress",],
    dieli_it => ["vestire",],
    part_speech => "verb", 
    verb => {
	conj => "xxiri", 
	stem => "vist",
	boot => "vèst",
	irrg => {
	    inf => "vistiri",
	},
    },);
%{ $vnotes{"vistirisi"} } = (
    dieli => ["vistirisi","vistiri","vèstiti",],
    dieli_en => ["dress oneself","get dressed",],
    dieli_it => ["vestirsi",],
    part_speech => "verb", 
    reflex => "vistiri",
    );

##  ##  ##  ##  ##  ##  ##  ##  ##

##  ORIGINAL
##  $ ./query-dieli.pl sc viviri
##  	0  ==  viviri {v} --> bere {v} --> drink {v}
##  	1  ==  viviri {v} --> vivere {v} --> live {v}
##  
##  EDITS:
##      ${$dieli_sc{"viviri"}[0]}{"linkto"} = "viviri_drink";
##      ${$dieli_sc{"viviri"}[1]}{"linkto"} = "viviri_live";

%{ $vnotes{"viviri_drink"} } = (
    dieli => ["viviri","biviri","vivi"],
    dieli_en => ["drink",],
    dieli_it => ["bere",],
    part_speech => "verb", 
    display_as => "vìviri",
    verb => {
	conj => "xxiri", 
	stem => "viv",
	boot => "vìv",
	irrg => {
	    pai => { quad => "vipp" },
	},		
    },);
%{ $vnotes{"viviri_live"} } = (
    dieli => ["viviri"],
    dieli_en => ["live",],
    dieli_it => ["vivere",],
    part_speech => "verb", 
    display_as => "vìviri",
    verb => {
	conj => "xxiri", 
	stem => "viv",
	boot => "vìv",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"vuliri"} } = (
    dieli => ["vuliri"],
    dieli_en => ["want","will",],
    dieli_it => ["volere",],
    part_speech => "verb", 
    verb => {
	conj => "xxiri", 
	stem => "vul",
	boot => "vòl",
	irrg => {
	    inf => "vuliri",
	    pri => { us => "vogghiu", ds => "voi", tp => "vonnu" },
	    pai => { quad => "vòs" },
	    fti => { stem => "vur"},
	    coi => { stem => "vur"},
	},		
    },);


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make the "link tos"
foreach my $key (keys %vnotes) {
    foreach my $dieli (@{ $vnotes{$key}{dieli} }){
	foreach my $index (0..$#{ $dieli_sc{$dieli}}) {
	    ##  only replace the linkto if not already defined "above"
	    ##  "above" should ONLY mean defined in the "mk_dieli-edits.pl" script
	    if ( ! defined ${$dieli_sc{$dieli}[$index]}{"linkto"} ) {
		##  only replace the linkto if its a verb
		##  because that's what we're working with here
		if ( ${$dieli_sc{$dieli}[$index]}{"sc_part"} eq '{v}') {
		    ${$dieli_sc{$dieli}[$index]}{"linkto"} = $key ;
		}
	    }
	}
    }
}

##  make ENglish and ITalian dictionaries
# my %dieli_en = make_en_dict( \%dieli_sc ) ;
# my %dieli_it = make_it_dict( \%dieli_sc ) ;

##  ##  ##  ##

##  store the verb notes
nstore( \%vnotes , $vnotesfile ) ; 

##  store the dictionaries
nstore( \%dieli_sc , $dieli_sc_dict );
# nstore( \%dieli_en , $dieli_en_dict );
# nstore( \%dieli_it , $dieli_it_dict );


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

sub replace_part {
    my $hashref = $_[0] ; 
    my $part    = $_[1] ; 
    
    foreach my $lang_part ("sc_part","it_part","en_part") {
	${$hashref}{$lang_part} = "{" . $part . "}" ; 
    }
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

