#!/bin/bash

##  "make_cchiu.sh" -- a quick little script to assemble the pieces
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

##  make Dieli dictionary and edit it
./mk_dieli-dicts.pl
./mk_dieli-edits.pl

##  make part of speech tools
./mk_pos-tools.pl

##  make verb notes, adjective notes and noun notes
./mk_verb-notes.pl
./mk_adj-notes.pl
./mk_noun-notes.pl

##  make notes on other parts of speech
##  English and Italian dictionaries generated here, so must do this last
./mk_other-notes.pl

##  make tools for web interface
./mk_cchiu-tools.pl
