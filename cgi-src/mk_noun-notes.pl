#!/usr/bin/env perl

##  "mk_noun-notes.pl" -- makes hash of nouns and adds "linkto"s to the Dieli dictionary
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
my $vnotesfile = '../cgi-lib/vocab-notes' ; 
my $dieli_sc_dict = '../cgi-lib/dieli-sc-dict' ; 
my $dieli_en_dict = '../cgi-lib/dieli-en-dict' ; 
my $dieli_it_dict = '../cgi-lib/dieli-it-dict' ; 

##  retrieve verb hash
my $vnhash = retrieve( $vnotesfile );
my %vnotes = %{ $vnhash } ;

##  retrieve SiCilian
my %dieli_sc = %{ retrieve( $dieli_sc_dict ) } ;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  ADD NOUNS to VOCABULARY HASH
##  === ===== == ========== ====

%{ $vnotes{"agneddu_noun"} } = (
    display_as => "agneddu",
    dieli => ["agneddu",],
    dieli_en => ["lamb",],
    dieli_it => [],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"amica_noun"} } = (
    display_as => "amica",
    dieli => ["amica",],
    dieli_en => ["friend",],
    dieli_it => ["amica",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"amicu_noun"} } = (
    display_as => "amicu",
    dieli => ["amicu",],
    dieli_en => ["friend",],
    dieli_it => ["amico",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "amici",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"amuri_noun"} } = (
    display_as => "amuri",
    dieli => ["amuri",],
    dieli_en => ["blackberry","love ",],
    dieli_it => ["mora","amore ",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"aneddu_noun"} } = (
    display_as => "aneddu",
    dieli => ["aneddu",],
    dieli_en => ["ring",],
    dieli_it => ["anello",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"artista_noun"} } = (
    display_as => "artista",
    dieli => ["artista",],
    dieli_en => ["artist",],
    dieli_it => ["artista",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "both",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"bancu_noun"} } = (
    display_as => "bancu",
    dieli => ["bancu",],
    dieli_en => ["bank (sand)","bench","counter","stand",],
    dieli_it => ["banco",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"beccu_noun"} } = (
    display_as => "beccu",
    dieli => ["beccu",],
    dieli_en => ["beak","cuckold","nozzle","spout",],
    dieli_it => ["becco","corna",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"buttuni_noun"} } = (
    display_as => "buttuni",
    dieli => ["buttuni",],
    dieli_en => ["button",],
    dieli_it => ["bottone",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cagna_noun"} } = (
    display_as => "cagna",
    dieli => ["cagna",],
    dieli_en => ["bitch",],
    dieli_it => ["cagna",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"campiuni_noun"} } = (
    display_as => "campiuni",
    dieli => ["campiuni",],
    dieli_en => ["champion","sample",],
    dieli_it => ["campione",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cannolu_noun"} } = (
    display_as => "cannolu",
    dieli => ["cannolu",],
    dieli_en => ["tube",],
    dieli_it => ["tubo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	## plural => "cannola",  ##  CANNOLI  !!!
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"capu_noun"} } = (
    display_as => "capu",
    dieli => ["capu",],
    dieli_en => ["boss","cape (geog)","chief","chieftain","head",],
    dieli_it => ["capo ","capo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"casteddu_noun"} } = (
    display_as => "casteddu",
    dieli => ["casteddu",],
    dieli_en => ["castle",],
    dieli_it => ["castello",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"celu_noun"} } = (
    display_as => "celu",
    dieli => ["celu",],
    dieli_en => ["heaven","paradise","sky",],
    dieli_it => ["cielo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "cela",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"chiovu_noun"} } = (
    display_as => "chiovu",
    dieli => ["chiovu",],
    dieli_en => ["nail",],
    dieli_it => ["chiodo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "chiova",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cìnima_noun"} } = (
    display_as => "cìnima",
    dieli => ["cinima",],
    dieli_en => ["cinema","pictures",],
    dieli_it => ["cinema",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "cìnima",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"ciriveddu_noun"} } = (
    display_as => "ciriveddu",
    dieli => ["ciriveddu",],
    dieli_en => ["brain",],
    dieli_it => ["cervello",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cocciu_noun"} } = (
    display_as => "cocciu",
    dieli => ["cocciu",],
    dieli_en => ["berry","drop","fruit (berry)","grain of wheat","kernel","seed",],
    dieli_it => ["bacca","goccia","chicco",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "coccia",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cornu_noun"} } = (
    display_as => "cornu",
    dieli => ["cornu",],
    dieli_en => ["disgrace a spouse","horn",],
    dieli_it => ["disonore dei consorti","corno",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "corna",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"corpu_body"} } = (
    display_as => "corpu",
    dieli => ["corpu",],
    dieli_en => ["body","corpus",],
    dieli_it => ["corpo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "corpura",
    },);

%{ $vnotes{"corpu_blow"} } = (
    display_as => "corpu",
    dieli => ["corpu",],
    dieli_en => ["blow","bump","hit","shot","stroke",],
    dieli_it => ["colpo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "corpa",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cumpusituri_noun"} } = (
    display_as => "cumpusituri",
    dieli => ["composituri",],
    dieli_en => ["composer",],
    dieli_it => ["compositore",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "cumpusitura",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"cumunista_noun"} } = (
    display_as => "cumunista",
    dieli => ["cumunista",],
    dieli_en => ["communist",],
    dieli_it => ["comunista",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "both",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"disiu_noun"} } = (
    display_as => "disiu",
    dieli => ["disiu",],
    dieli_en => ["wish",],
    dieli_it => ["desiderio",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"dizziunariu_noun"} } = (
    display_as => "dizziunariu",
    dieli => ["dizziunariu"],
    dieli_en => ["dictionary",],
    dieli_it => ["dizionario",],
    ## notex => ["",],
    part_speech => "noun", 
    noun => { 
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"donu_noun"} } = (
    display_as => "donu",
    dieli => ["donu",],
    dieli_en => ["donation","gift",],
    dieli_it => ["donazione","dono",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"duca_noun"} } = (
    display_as => "duca",
    dieli => ["duca",],
    dieli_en => ["duke",],
    dieli_it => ["duca",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	## plural => "duca",
    },);

%{ $vnotes{"duchissa_noun"} } = (
    display_as => "duchissa",
    dieli => ["duchissa",],
    dieli_en => ["duchess",],
    dieli_it => ["duchessa",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"dutturi_noun"} } = (
    display_as => "dutturi",
    dieli => ["dutturi",],
    dieli_en => ["doctor",],
    dieli_it => ["dottore",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "duttura",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"estati_noun"} } = (
    display_as => "estati",
    dieli => ["estati","stati","sta",],
    dieli_en => ["summer",],
    dieli_it => ["estate",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"facci_noun"} } = (
    display_as => "facci",
    dieli => ["facci",],
    dieli_en => ["images","do",],
    dieli_it => ["immagine","fagli",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"farmacia_noun"} } = (
    display_as => "farmacia",
    dieli => ["farmacia",],
    dieli_en => ["chemist","drugstore",],
    dieli_it => ["farmacia",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"fattu_noun"} } = (
    display_as => "fattu",
    dieli => ["fattu",],
    dieli_en => ["deed","fact","occurrence","ripe",],
    dieli_it => ["fatto",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"ficu_noun"} } = (
    display_as => "ficu",
    dieli => ["ficu",],
    dieli_en => ["fig","fig tree",],
    dieli_it => ["fico",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
	## plural => "ficu",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"figghia_noun"} } = (
    display_as => "figghia",
    dieli => ["figghia",],
    dieli_en => ["daughter",],
    dieli_it => ["figlia",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"figghiu_noun"} } = (
    display_as => "figghiu",
    dieli => ["figghiu",],
    dieli_en => ["boy","son",],
    dieli_it => ["figlio",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"filu_noun"} } = (
    display_as => "filu",
    dieli => ["filu",],
    dieli_en => ["string","thread","wire","yarn",],
    dieli_it => ["spago","filo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "fila",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"firraru_noun"} } = (
    display_as => "firraru",
    dieli => ["firraru",],
    dieli_en => ["blacksmith","smith",],
    dieli_it => ["ferrajo","fabbro",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"fisicu_noun"} } = (
    display_as => "fisicu",
    dieli => ["fisicu",],
    dieli_en => ["physical","physicist",],
    dieli_it => ["fisico",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "fisici",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"focu_noun"} } = (
    display_as => "focu",
    dieli => ["focu",],
    dieli_en => ["fire","focus",],
    dieli_it => ["fuoco",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "foca",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"fotu_noun"} } = (
    display_as => "fotu",
    dieli => ["fotu",],
    dieli_en => ["photo",],
    dieli_it => ["foto",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"fruttu_noun"} } = (
    display_as => "fruttu",
    dieli => ["fruttu",],
    dieli_en => ["fruit",],
    dieli_it => ["frutto",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "frutta",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"fucularu_noun"} } = (
    display_as => "fucularu",
    dieli => ["fucularu",],
    dieli_en => ["fireplace","hearth",],
    dieli_it => ["caminetto","focolare",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"gatta_noun"} } = (
    display_as => "gatta",
    dieli => ["gatta",],
    dieli_en => ["cat",],
    dieli_it => ["gatta",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"gattu_noun"} } = (
    display_as => "gattu",
    dieli => ["gattu",],
    dieli_en => ["cat",],
    dieli_it => ["gatto",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"grazzia_noun"} } = (
    display_as => "grazzia",
    dieli => ["grazzia",],
    dieli_en => ["charm","grace","graciousness","pardon",],
    dieli_it => ["grazia",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"ìditu_noun"} } = (
    display_as => "ìditu",
    dieli => ["iditu",],
    dieli_en => ["digit","finger",],
    dieli_it => ["dito",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "ìdita",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"jardinu_noun"} } = (
    display_as => "jardinu",
    dieli => ["jardinu","iardinu","giardinu",],
    dieli_en => ["vegetable garden",],
    dieli_it => ["orto",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "jardina",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"jocu_noun"} } = (
    display_as => "jocu",
    dieli => ["iocu","jocu",],
    dieli_en => ["game","play",],
    dieli_it => ["gioco",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "jocura",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"jornu_noun"} } = (
    display_as => "jornu",
    dieli => ["iornu",],
    dieli_en => ["day",],
    dieli_it => ["giorno",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "jorna",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"libbru_noun"} } = (
    display_as => "libbru",
    dieli => ["libbru",],
    dieli_en => ["book",],
    dieli_it => ["libro",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "libbra",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"lignu_noun"} } = (
    display_as => "lignu",
    dieli => ["lignu",],
    dieli_en => ["wood",],
    dieli_it => ["legno",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "ligna",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"linzolu_noun"} } = (
    display_as => "linzolu",
    dieli => ["linzolu",],
    dieli_en => ["sheet",],
    dieli_it => [],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "linzola",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"liunissa_noun"} } = (
    display_as => "liunissa",
    dieli => ["liunissa",],
    dieli_en => ["lioness",],
    dieli_it => [],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"luna_noun"} } = (
    display_as => "luna",
    dieli => ["luna",],
    dieli_en => ["moon",],
    dieli_it => ["luna",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"manu_noun"} } = (
    display_as => "manu",
    dieli => ["manu",],
    dieli_en => ["hand",],
    dieli_it => ["mano",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"marteddu_noun"} } = (
    display_as => "marteddu",
    dieli => ["marteddu",],
    dieli_en => ["hammer",],
    dieli_it => ["martello",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"matri_noun"} } = (
    display_as => "matri",
    dieli => ["matri",],
    dieli_en => ["mother",],
    dieli_it => ["madre",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"mèdicu_noun"} } = (
    display_as => "mèdicu",
    dieli => ["medicu",],
    dieli_en => ["doctor","medical","physician",],
    dieli_it => ["medico",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "mèdici",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"migghiu_noun"} } = (
    display_as => "migghiu",
    dieli => ["migghiu",],
    dieli_en => ["mile",],
    dieli_it => ["miglio",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "migghia",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"mònaca_noun"} } = (
    display_as => "mònaca",
    dieli => ["monaca",],
    dieli_en => ["nun","sister",],
    dieli_it => ["monaca",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"mònacu_noun"} } = (
    display_as => "mònacu",
    dieli => ["monacu",],
    dieli_en => ["monk",],
    dieli_it => ["monaco",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "mònaci",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"muru_noun"} } = (
    display_as => "muru",
    dieli => ["muru",],
    dieli_en => ["wall",],
    dieli_it => ["muro",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "mura",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"nimicu_noun"} } = (
    display_as => "nimicu",
    dieli => ["nimicu",],
    dieli_en => ["enemy","hostile","unfriendly",],
    dieli_it => ["nemico",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "nimici",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"ogghiu_noun"} } = (
    display_as => "ogghiu",
    dieli => ["ogghiu",],
    dieli_en => ["oil",],
    dieli_it => ["olio",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "ogghia",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"oliva_noun"} } = (
    display_as => "oliva",
    dieli => ["oliva",],
    dieli_en => ["olive",],
    dieli_it => ["oliva",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"omu_noun"} } = (
    display_as => "omu",
    dieli => ["omu",],
    dieli_en => ["man","guy",],
    dieli_it => ["uomo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "omini",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"oricchia_noun"} } = (
    display_as => "oricchia",
    dieli => ["oricchia",],
    dieli_en => ["ear",],
    dieli_it => ["orecchio",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"ossu_noun"} } = (
    display_as => "ossu",
    dieli => ["ossu",],
    dieli_en => ["bone",],
    dieli_it => ["osso",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "ossa",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"ovu_noun"} } = (
    display_as => "ovu",
    dieli => ["ovu",],
    dieli_en => ["egg",],
    dieli_it => ["uovo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "ova",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pagghiaru_noun"} } = (
    display_as => "pagghiaru",
    dieli => ["pagghiaru",],
    dieli_en => ["field shelter","hay barn","hayrick","haystack",],
    dieli_it => [],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"panareddu_noun"} } = (
    display_as => "panareddu",
    dieli => ["panareddu",],
    dieli_en => ["little basket",],
    dieli_it => ["panierino",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"panaru_noun"} } = (
    display_as => "panaru",
    dieli => ["panaru",],
    dieli_en => ["hamper",],
    dieli_it => ["paniere",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pani_noun"} } = (
    display_as => "pani",
    dieli => ["pani",],
    dieli_en => ["bread",],
    dieli_it => ["pane",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"parcu_noun"} } = (
    display_as => "parcu",
    dieli => ["parcu",],
    dieli_en => ["park","sober",],
    dieli_it => ["parco",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"paru_noun"} } = (
    display_as => "paru",
    dieli => ["paru",],
    dieli_en => ["equal","pair","peer","same",],
    dieli_it => ["paio","pari",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"patri_noun"} } = (
    display_as => "patri",
    dieli => ["patri",],
    dieli_en => ["father",],
    dieli_it => ["padre",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"patruni_noun"} } = (
    display_as => "patruni",
    dieli => ["patruni",],
    dieli_en => ["boss","employer","landlord","master","owner",],
    dieli_it => ["padrone","datore di lavoro",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pedi_noun"} } = (
    display_as => "pedi",
    dieli => ["pedi",],
    dieli_en => ["feet","foot",],
    dieli_it => ["piedi","piede",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"piattu_noun"} } = (
    display_as => "piattu",
    dieli => ["piattu",],
    dieli_en => ["dish","flat","plate",],
    dieli_it => ["piatto",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "piatta",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pilu_noun"} } = (
    display_as => "pilu",
    dieli => ["pilu",],
    dieli_en => ["hair",],
    dieli_it => ["pelo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "pila",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pinna_noun"} } = (
    display_as => "pinna",
    dieli => ["pinna",],
    dieli_en => ["feather","pen",],
    dieli_it => ["penna","piuma",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"piru_noun"} } = (
    display_as => "piru",
    dieli => ["piru",],
    dieli_en => ["pear",],
    dieli_it => ["pera",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
	plural => "pira",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pizzu_noun"} } = (
    display_as => "pizzu",
    dieli => ["pizzu",],
    dieli_en => ["beak","bribe","peak",],
    dieli_it => ["becco","bustarella","vetta",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "pizza",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"porcu_noun"} } = (
    display_as => "porcu",
    dieli => ["porcu",],
    dieli_en => ["pig",],
    dieli_it => ["porco",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "porci",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"porta_noun"} } = (
    display_as => "porta",
    dieli => ["porta",],
    dieli_en => ["bears","brings","door","gate",],
    dieli_it => ["porta",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"prufissuri_noun"} } = (
    display_as => "prufissuri",
    dieli => ["prufissuri"],
    dieli_en => ["professor","teacher",],
    dieli_it => ["professore",],
    ## notex => ["",],
    part_speech => "noun", 
    noun => { 
	gender => "mas",
	plural => "prufissura",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"prufissurissa_noun"} } = (
    display_as => "prufissurissa",
    dieli => ["prufissurissa",],
    dieli_en => ["teacher",],
    dieli_it => [],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"prunu_noun"} } = (
    display_as => "prunu",
    dieli => ["prunu",],
    dieli_en => ["plum","prune",],
    dieli_it => ["prugna","susina",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "pruna",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pueta_noun"} } = (
    display_as => "pueta",
    dieli => ["pueta",],
    dieli_en => ["poet",],
    dieli_it => ["poeta",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pugnu_noun"} } = (
    display_as => "pugnu",
    dieli => ["pugnu",],
    dieli_en => ["fist","handful","punch",],
    dieli_it => ["pugno",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "pugna",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"pumu_noun"} } = (
    display_as => "pumu",
    dieli => ["pumu",],
    dieli_en => ["apple","apple tree",],
    dieli_it => ["mela","melo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "puma",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"re_noun"} } = (
    display_as => "re",
    dieli => ["re",],
    dieli_en => ["king",],
    dieli_it => ["re",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"scagghiuni_noun"} } = (
    display_as => "scagghiuni",
    dieli => ["scagghiuni",],
    dieli_en => ["canines (teeth)",],
    dieli_it => ["dente canino",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"scaluni_noun"} } = (
    display_as => "scaluni",
    dieli => ["scaluni",],
    dieli_en => ["step",],
    dieli_it => ["gradino","scalino",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"scarparu_noun"} } = (
    display_as => "scarparu",
    dieli => ["scarparu",],
    dieli_en => ["shoemaker",],
    dieli_it => [],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"sceccu_noun"} } = (
    display_as => "sceccu",
    dieli => ["sceccu",],
    dieli_en => ["donkey",],
    dieli_it => ["asino",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"socialista_noun"} } = (
    display_as => "socialista",
    dieli => ["socialista"],
    dieli_en => ["socialist",],
    dieli_it => ["socialista",],
    ## notex => ["",],
    part_speech => "noun", 
    noun => { 
	gender => "both",
    },);

##  ##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"solu_noun"} } = (
    display_as => "solu",
    dieli => ["solu",],
    dieli_en => ["earth","ground","soil",],
    dieli_it => ["suolo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "sola",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"soru_noun"} } = (
    display_as => "soru",
    dieli => ["soru",],
    dieli_en => ["sister",],
    dieli_it => ["sorella",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"spicchiu_noun"} } = (
    display_as => "spicchiu",
    dieli => ["spicchiu",],
    dieli_en => ["stone (of a fruit)",],
    dieli_it => ["nocciolo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "spicchia",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"studenti_noun"} } = (
    display_as => "studenti",
    dieli => ["studenti",],
    dieli_en => ["scholar","schoolboy","student",],
    dieli_it => ["allievo","scolaro","studente",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"studiu_noun"} } = (
    display_as => "studiu",
    dieli => ["studiu",],
    dieli_en => ["office","study",],
    dieli_it => ["ufficio","studio",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"sularu_noun"} } = (
    display_as => "sularu",
    dieli => ["sularu",],
    dieli_en => ["attic","loft",],
    dieli_it => ["soffitta",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"suli_noun"} } = (
    display_as => "suli",
    dieli => ["suli",],
    dieli_en => ["sun",],
    dieli_it => ["sole",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"tabbaccaru_noun"} } = (
    display_as => "tabbaccaru",
    dieli => ["tabbaccaru",],
    dieli_en => ["cigar shop",],
    dieli_it => ["tabaccheria",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"tempu_noun"} } = (
    display_as => "tempu",
    dieli => ["tempu",],
    dieli_en => ["time","weather",],
    dieli_it => ["tempo",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "tempura",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"unna_noun"} } = (
    display_as => "unna",
    dieli => ["unna",],
    dieli_en => ["wave",],
    dieli_it => ["onda",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "fem",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"vastuni_noun"} } = (
    display_as => "vastuni",
    dieli => ["vastuni",],
    dieli_en => ["baton","cane","club","cudgel","staff","stick","walking stick",],
    dieli_it => ["bastone","randello","bastone da passeggio",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"vasuni_noun"} } = (
    display_as => "vasuni",
    dieli => ["vasuni",],
    dieli_en => ["kiss","smack (kiss)",],
    dieli_it => ["bacio",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"voi_noun"} } = (
    display_as => "voi",
    dieli => ["voi",],
    dieli_en => ["ox",],
    dieli_it => ["bue",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"voscu_noun"} } = (
    display_as => "voscu",
    dieli => ["voscu","vòscura",],
    dieli_en => ["forest","park","wood","woods",],
    dieli_it => ["bosco","parco",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "vòscura",
    },);

##  ##  ##  ##  ##  ##  ##  ##

%{ $vnotes{"vrazzu_noun"} } = (
    display_as => "vrazzu",
    dieli => ["vrazzu",],
    dieli_en => ["arm",],
    dieli_it => ["braccio",],
    ## notex => ["","",],
    part_speech => "noun",
    noun => {
	gender => "mas",
	plural => "vrazza",
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
		##  only replace the linkto if its a noun
		##  because that's what we're working with here
		my $scpart = ${$dieli_sc{$dieli}[$index]}{"sc_part"} ;
		if ( ( $scpart eq '{m}' || $scpart eq '{f}' || 
		       $scpart eq '{m/f}' || 
		       $scpart eq '{mpl}' || $scpart eq '{fpl}' ) 
		     && $vnotes{$key}{part_speech} eq 'noun' ) {
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

