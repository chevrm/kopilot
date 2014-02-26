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

## usage:
## perl kopilot.pl contigprefix kobasfile > outfile.kp.tab

my @str = split(/\//, $0);
my $dir = '';
for(my $i=0;$i<scalar(@str)-1;$i++){
	$dir .= $str[$i];
}
my ($contigprefix, $kf) = (shift, shift); 
my %verboseof = ();
open my $mapfh, '<', "$dir/src/lists/kegg.map" or die "$!: DIR=$dir\n";
while (<$mapfh>){
	chomp;
	my ($desc, $file) = split("\t", $_);
	$verboseof{$file} = $desc;
}
close $mapfh;
my %kegghitof = ();
open my $kfh, '<', $kf or die $!;
while(<$kfh>){
	chomp;
	if($_ =~ m/^$contigprefix/){
		my ($contigname, $keggdesc) = split("\t+", $_);
		my ($kegg,$desc,$site) = split(/\|/, $keggdesc);
		unless ($kegg eq 'None'){
			$kegghitof{$contigname} = $kegg;
		}
	}
}
close $kfh;
my $listc = 0;
foreach my $f (sort keys %verboseof){
	my $fn = "$dir/src/lists/$f";
	$listc++;
	my %keggdescof = ();
	my %keggcountof = ();
	open my $ifh, '<', $fn or die "$!\nfile: $fn";
	my ($kn, $kd);
	while(defined($kn = <$ifh>) && defined($kd = <$ifh>)){
		chomp($kn);
		$kn =~ s/\s//g;
		chomp($kd);
		$keggdescof{$kn} = $kd;
		#print "$keggdescof{$kn}\n";
	}
	close $ifh;
	foreach my $c (sort keys %kegghitof){
		my $v = $kegghitof{$c}; 
		if (exists $keggdescof{$v}){
			if (exists $keggcountof{$v}){
				$keggcountof{$v}++;
			}else{
				$keggcountof{$v}=1;
			}
		}
	}
	foreach (sort { ($keggcountof{$b} <=> $keggcountof{$a})  } keys %keggcountof ){
		print "$verboseof{$f}\t$_\t$keggcountof{$_}\t$keggdescof{$_}\n";
	}
}

#print "Files accessed: $listc\n";
