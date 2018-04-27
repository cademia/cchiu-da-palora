# Cchiù dâ Palora

[_Cchiù dâ Palora_](http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl) uses a set of Perl hashes to annotate a Sicilian dictionary with examples, usage notes, verb conjugations and noun and adjective declensions.  In the future, we also plan to present a comparison of words across Sicilian dialects.

We also hope you will contribute to the project.  The specification is available below.

To make it easy for you to contribute, prototypes are available in the `cchiu-da-palora/cgi-src/fetch/` directory.  You can copy-paste those prototypes into the source files, edit them appropriately and then run `make_cchiu.sh` to recreate the storables.

If you do, please provide the _minimum_ amount of information necessary.  Please provide the minimum amount of information necessary to conjugate verb or to decline a noun or adjective.

In the case of verbs, we want the computer to automatically conjugate each verb.  To the greatest extent possible, we must avoid telling the computer what the conjugation is.  We want the computer to create the conjugations for us, so that then (one day in the future) we can ask the computer to provide a conjugation for each dialect of the Sicilian language.

The Perl scripts are able to conjugate a verb properly with a minimal amount of information because -- after accounting for "[boot and stem](http://www.wdowiak.me/archive/sicilian/sicilian-verbs.shtml)" patterns -- there are very few irregular verbs in the Sicilian language and the irregularities that do exist are few.  

We encourage you to read that work and contribute to our project, so that we can all share a great Sicilian dictionary.

Grazzii pi l'aiutu! 

## Sicilian dictionary specification

* [dictionary specification](http://www.wdowiak.me/archive/sicilian/index.shtml)
* [boot and stem theory](http://www.wdowiak.me/archive/sicilian/sicilian-verbs.shtml)
* [_Dizziunariu di Dieli_](http://www.wdowiak.me/cgi-bin/sicilian.pl)
* [_Cchiù dâ Palora_](http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl)

One goal of this project is to develop a Sicilian dictionary. Along the way, I also hope to develop some software tools for processing [natural language](http://www.wdowiak.me/archive/natlang/index.shtml).

To seed the project, I used [Arthur Dieli](http://www.dieli.net/)'s vocabulary lists to create a [basic dictionary](http://www.wdowiak.me/cgi-bin/sicilian.pl).  Dr. Dieli's work was one of the first Sicilian vocabulary lists on the internet.  It contains over 12,000 Sicilian words and phrases, part of speech and translations into English and Italian.

To [build upon his work](http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl), I am creating a set of Perl hashes to store information about each word.  Information that we might include are: part of speech, related words, examples, usage notes and dialectical differences.

Differences between Sicilian dialects are particularly important.  Documenting those differences should enable us to (in future work) teach a computer how to recognize a speaker's origin by the words, conjugations and grammar that they use.

And, of course, if we can teach a computer the Sicilian language, we can teach the computer any language, so this project should also be useful to people with a general interest in linguistics.

This project is in its early stages, but I have already created a tool -- [Cchiù dâ Palora](http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl) -- that automatically conjugates Sicilian verbs and creates the singular and plural forms of nouns and adjectives. The tool is based on the grammar rules listed in Kirk Bonner's _Introduction_.

Below is a description of the information that I am collecting on each word and how I am storing that information. Following the description is a slightly more formal specification of the information collected.


### Perl hashes

Some people learn a language by creating an index card for each word that they learn. The Perl hashes that we're creating here are similar to that index card. For the preposition [_dintra_](http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl?palora=dintra_prep>), I created this "index card:"

```perl
%{ $vnotes{"dintra_prep"} } = (
    display_as => "dintra",
    dieli => ["dintra"],
    dieli_en => ["inside","into","within",],
    dieli_it => ["dentro","dentro a","in",],
    proverb => ["Dintra nu biccheri d'acqua t'anniasti.",],
    part_speech => "prep",
    );
```

For invariant words (like _dintra_), a simple index card like this -- with part of speech, translations and a Sicilian proverb -- may be sufficient for most learners.

But other parts of speech are more complex. Verbs, in particular, can be quite complex, so I am also including information that enables the computer to automatically conjugate each verb.

For that task, we want to give the computer the _least_ amount of information necessary to do the job properly.

Specifically, we do not want to tell the computer what the conjugation is. We want the computer to create the conjugations for us, so that (one day in the future) we can ask the computer to provide a conjugation for each dialect of the Sicilian language.

Fortunately, there are very few irregular verbs in the Sicilian language and the irregularities that do exist are few.  For example, after accounting for [boot and stem](http://www.wdowiak.me/archive/sicilian/sicilian-verbs.shtml) patterns, the verb [_jiri_](http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl?palora=jiri) only has four irregular forms -- the infinitive and three in the present tense (the first-person singular, third-person singular and third-person plural), so we might create the following hash:

```perl
%{ $vnotes{"jiri"} } = (
    dieli => ["iri"],
    dieli_en => ["go",],
    dieli_it => ["andare",],
    notex => ["Vaju a accattu li scarpi.",
              "Jemu a accattari li scarpi.",],
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
```

Similarly, the verb [_mèttiri_](http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl?palora=m%C3%A8ttiri) only has a few irregular forms -- the past participle and four in the past tense:

```perl
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
```

But many verbs are built by adding a prefix to the verb _mèttiri_, so we can conjugate the reflexive verb [_intromèttirisi_](http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl?palora=introm%C3%A8ttirisi) by creating a hidden hash of _intromèttiri_:

```perl
%{ $vnotes{"intromèttiri"} } = (
    hide => 1,
    part_speech => "verb",
    prepend => { prep => "intro", verb => "mèttiri", },
    );
```

and then identifying the verb _intromèttirisi_ as a reflexive form of _intromèttiri_:

```perl
%{ $vnotes{"intromèttirisi"} } = (
    dieli => ["intromettirisi"],
    dieli_en => ["interfere in",],
    dieli_it => ["intromettersi in",],
    part_speech => "verb",
    reflex => "intromèttiri",
    );
```

### specification

The tables below list the information that I am collecting in the hashes. The first lists information that may be included for all parts of speech. The tables below it list additional information required for verbs, nouns and adjectives.

#### all hashes

```
dieli  -- array  -- list of forms found in Dr. Dieli's dictionary
dieli_en  -- array  -- Dr. Dieli's translations into English
dieli_it  -- array  -- Dr. Dieli's translations into Italian
display_as  -- scalar  -- text to display when not using hash key 
hide  -- scalar  -- indicator to not display the word in the main list
poetry  -- array  -- examples from Sicilian poetry
proverb  -- array  -- examples from Sicilian proverbs
usage  -- array  -- usage notes for learners
notex  -- array  -- examples for learners
part_speech  -- scalar  -- part of speech
noun  -- hash  -- information to decline the noun, see below
adj  -- hash  -- information to decline the adjective, see below
verb  -- hash  -- information to conjugate the verb, see below
prepend  -- hash  -- information to conjugate by adding a prefix to another verb
reflex  -- scalar  -- hash key of the non-reflexive verb
```

parts of speech:  `verb`, `noun`, `adj`, `adv`, `prep`, `pron`, `conj`

The verbs  [vìviri](http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl?palora=viviri_drink) and [vìviri](http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl?palora=viviri_live) need different hash keys.  But they both `display_as` "vìviri".

The additional information to include for verbs, nouns and adjectives is described in the tables below.

#### verb hashes

```
conj  -- scalar  -- which conjugation to use
stem  -- scalar  -- "stem" of the verb
boot  -- scalar  -- "boot" of the verb
irrg  -- hash  -- information on the irregular forms
inf  -- scalar  -- irregular infinitive
pri  -- hash  -- irregular present indicative forms
pim  -- hash  -- irregular imperative forms
pai  -- hash  -- irregular preterite forms  (use "quad")
imi  -- hash  -- irregular imperfect indicative forms
ims  -- hash  -- irregular imperfect subjunctive forms
fti  -- hash  -- irregular future forms  (use "stem")
coi  -- hash  -- irregular conditional forms  (use "stem")
ger  -- scalar  -- irregular gerund
pap  -- scalar  -- irregular past participle
adj  -- scalar  -- irregular adjective
inf  -- scalar  -- irregular infinitive
```

conjugations:  `xxiri`, `sciri`, `xxari`, `xcari`, `xgari`, `xiari`, `ciari`, `giari`

Sicilian has two verb conjugations ("-ari" and "-iri"), which I have split into eight subconjugations, so that the verb stems pair properly with the verb endings.

For example:

```perl
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
```

#### noun hashes

```
gender  -- scalar  -- gender of the noun
plend  -- scalar  -- noun pattern
plural  -- scalar  -- irregular plural form
```

gender of the noun:  `mas`, `fem`, `both`, `mpl`, `fpl`

Most Sicilian nouns are either masculine or feminine, but some nouns (e.g. "atleta" and "dentista") are both masculine and feminine.  Some nouns have no plural (e.g. "l'Italia"), others are only plural (e.g. "li Stati Uniti").  Use the noun patterns below.

#### noun patterns

```
xi  -- plural in "-i"
xixa  -- plural in either "-i" or "-a"
xa  -- plural in "-a"
xura  -- plural in either "-ura" or "-i"
xx  -- no change (foreign word)
eddu  -- "-eddu" to "-edda"
aru  -- "-aru" to "-ara"
uni  -- "-uni" to "-una"
uri  -- "-uri" to "-ura"
nopl -- no plural form, only singular
ispl -- is plural, no singular form
```

For example:

```perl
%{ $vnotes{"prufissuri_noun"} } = (
    display_as => "prufissuri",
    dieli => ["prufissuri"],
    dieli_en => ["professor", "teacher",],
    dieli_it => ["professore",],
    part_speech => "noun",
    noun => {
        gender => "mas",
        plend => "uri",
    },);
```

```perl
%{ $vnotes{"genituri_noun"} } = (
    display_as => "genituri",
    dieli => ["genituri",],
    dieli_en => ["parents",],
    dieli_it => ["genitori",],
    part_speech => "noun",
    noun => {
	gender => "mpl",
	plend => "ispl",
    },);
```

#### adjective hashes 

```
invariant  -- scalar  -- indicator that the adjective is invariant
femsi  -- scalar  -- feminine singular form
may_precede  -- scalar  -- indicator that the adjective may precede the noun
massi_precede  -- scalar  -- masculine singular form when preceding the noun
```

Most Sicilian adjectives must agree in gender and number with the noun that they are modifying, but some are invariant (e.g. "megghiu"). Others only change in the feminine singular form (e.g. "giùvini").  Most Sicilian adjectives follow the noun that they are modifying, but some may precede the noun.

For example:

```perl
%{ $vnotes{"bonu"} } = (
    dieli => ["bonu"],
    dieli_en => ["fair","good","nice",],
    dieli_it => ["buono",],
    notex => ["lu bon senzu","la bona cosa",],
    part_speech => "adj", 
    adj => {
	may_precede => 1,
	massi_precede => "bon",
    },);
```

```perl
%{ $vnotes{"megghiu_adj"} } = (
    display_as => "megghiu",
    dieli => ["megghiu","u megghiu",],
    dieli_en => ["better","superior",],
    dieli_it => ["migliore","meglio","maggiore",],
    notex => ["La megghiu cosa è di lassari tuttu com'è.",],
    part_speech => "adj",
    adj => {
        invariant => 1,
        may_precede => 1,
    },);
```

```perl
%{ $vnotes{"giùvini_adj"} } = (
    display_as => "giùvini",
    dieli => ["giuvini","giuvina",],
    dieli_en => ["young boy","young girl",],
    dieli_it => ["giovanotto","giovanotta",],
    part_speech => "adj",
    adj => {
        femsi => "giùvina",
        may_precede => 1,
    },);
```
