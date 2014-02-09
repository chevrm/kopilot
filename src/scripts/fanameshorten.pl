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

## usage: fanameshorten.pl in.fa prefix

my ($infa, $prefix) = (shift, shift);
my $root = $infa;
$root =~ s/.fasta//;
$root =~ s/.faa//;
$root =~ s/.fna//;
$root =~ s/.fa//;
my $map = $root . '.map';
my $oufa = $root . '.renamed.fa';
open my $ifh, '<', $infa or die $!;
open my $ofh, '>', $oufa or die $!;
my $count = 0;
open my $mfh, '>', $map or die $!;
chomp(my @line=<$ifh>);
close $ifh;
my %codeof = ();
foreach (@line){
	if ($_ =~ m/^>/){
		$_ =~ s/>//;
		my $orig = $_;
		$_ = $prefix . $count;
		$codeof{$orig}=$_;
	}
	print $ofh "$_\n";
	$count++;
}
foreach (sort {($codeof{$a} cmp $codeof{$b})} keys %codeof){
	print $mfh "$_\t$codeof{$_}\n";
}
close $mfh;
