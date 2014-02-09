#!/usr/bin/perl

#    Copyright 2014 Marc Chevrette
#
#    This file is part of kopilot
#
#    kopilot is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

## usage:
## perl fastq2fasta.pl input.fastq > new.fasta

my $minLen=50;
while (my $idLine=<>){
    my $seqLine=<>;
    my $plusLine=<>;
    my $qualLine=<>;
    $idLine=~s/^\@/>/;
    print $idLine,$seqLine if (length($seqLine)-1>=$minLen);
}

