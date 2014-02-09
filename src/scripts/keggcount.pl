#!/bin/env perl

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

#usage:  perl keggcount.pl prefix 1.annotate 2.annotate > out.keggc

my $prefix = shift;
my %siteof;
my %countof;
my $totalcount=0;
my $fi = 0;
while (my $file = shift){
        my $mult = 1; #case = ext.annotate
        if ($file =~ m/^nc/){
                $mult = 0.5; #case = nc1.annotate
        }
        open my $ifh, '<', $file or die $!;
        chomp(my @line=<$ifh>);
        close $ifh or die $!;
        foreach my $l (@line){
                unless($l =~ m/^\#/){
                        my ($read, $kegg) = split(/\t+/, $l);
                        if(defined $read and $read =~ m/^$prefix/){
                                #print "KEGG found: $kegg\n";
                                unless($kegg =~ m/None/){
                                        #print "KEGG found: $kegg\n";
                                        my ($keggpath, $altname, $keggsite) = split(/\|/, $kegg);
                                        $siteof{$keggpath} = $keggsite;
                                        if (exists $countof{$keggpath} ){
                                                $countof{$keggpath}=$countof{$keggpath}+$mult;
                                                $totalcount=$totalcount+$mult;
                                        }else{
                                                $countof{$keggpath} = $mult;
                                                $totalcount=$totalcount+$mult;
                                        }
                                }
                        }
                }
        }
}

foreach (sort { ($countof{$b} <=> $countof{$a})  } keys %countof  ){
        print "$_\t$countof{$_}\t$siteof{$_}\n";
}

#print "\n\nTotal KEGG HITS: $totalcount\n";
