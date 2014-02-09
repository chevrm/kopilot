#!/bin/sh

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

## installer file for kopilot
## will invoke sudo and ensure the following are installed:
##	perl
##	bioperl

cd ./src
directoryx="$(dirname -- $(readlink -fn -- "$0"; echo x))"
directory="${directoryx%x}"
sudo apt-get install perl bioperl
cd $directory
ln -s $directory/scripts/kombiner.pl ../kombiner
ln -s $directory/scripts/fastq2fasta.pl ../fq2fa
ln -s $directory/scripts/fanameshorten.pl ../fanameshorten
ln -s $directory/scripts/keggcount.pl ../kocount
ln -s $directory/scripts/kopilot.pl	../kopilot
