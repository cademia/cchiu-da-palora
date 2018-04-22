# cchiu-da-palora
"Cchiù dâ Palora" uses a set of Perl hashes to annotate a Sicilian dictionary with examples, usage notes, verb conjugations and noun and adjective declensions.  In the future, we also plan to present a comparison of words across Sicilian dialects.

A working version of the project is available at:  http://www.wdowiak.me/cgi-bin/cchiu-da-palora.pl

We also hope you will contribute to the project.  The specification is available at:  http://www.wdowiak.me/archive/sicilian/index.shtml

To make it easy for you to contribute, prototypes are available in the "cchiu-da-palora/cgi-src/fetch/" directory.  You can copy-paste those prototypes into the source files, edit them appropriately and then run the "make_cchiu.sh" to recreate the storables.

If you do, please provide the _MINIMUM_ amount of information necessary.  Please provide the minimum amount of information necessary to conjugate verb or to decline a noun or adjective.

In the case of verbs, we want the computer to automatically conjugate each verb.  To the greatest extent possible, we must avoid telling the computer what the conjugation is.  We want the computer to create the conjugations for us, so that then (one day in the future) we can ask the computer to provide a conjugation for each dialect of the Sicilian language.

The Perl scripts are able to conjugate a verb properly with a minimal amount of information because -- after accounting for "boot and stem" patterns -- there are very few irregular verbs in the Sicilian language and the irregularities that do exist are few.  A description of those boot and stem patterns is available at:  http://www.wdowiak.me/archive/sicilian/sicilian-verbs.shtml

We encourage you to read that work and contribute to our project, so that we can all share a great Sicilian learner's dictionary.

Grazzii pi l'aiutu! 
