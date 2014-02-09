#!/bin/perl

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

#usage:  perl ~/bin/kobascombiner.pl in.1 in.2 in.3 > out.annotate

my @top; #blast brief
my @bottom; #pathway details
my $suc = 0;
my $fai = 0;


foreach my $ifile (@ARGV){
        open my $ifh, '<', $ifile or die $!;
        chomp(my @i_lines=<$ifh>);
        close $ifh or die $!;
        foreach my $l (@i_lines){
                unless ($l =~ m/^[\-\#]/ or $l eq ''){
                        if ($l =~ m/^[\/\s]/ or $l =~ m/^(Query:|KO:|Pathway:)/ ){
                                push @bottom, $l;
                        }else{
                                push @top, $l;
                        }
                }else{
                        if ($l =~ m/^\#\#Summary:\s+(\d+)\ssucceed,\s(\d+)/){
                                $suc=$suc+$1;
                                $fai=$fai+$2;
                        }
                }
        }
}

print "##ko    KEGG Orthology\n##Method: BLAST Options: evalue <= 1e-05; rank <= 5\n##Summary:      ";
print "$suc succeed, $fai fail\n\n#Query  KO ID|KO name|Hyperlink\n";
print join("\n", @top);
print "\n\n--------------------\n\n";
print join("\n", @bottom);
