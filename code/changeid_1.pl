#!/usr/bin/perl -w
##usage:perl changeid_1.pl ear.collapsed.rep.fa;
#
open A,"$ARGV[0]"||die $!;
open O,">ear.fa"||die $!;
while(<A>){
   chomp;
   if($_=~/^>/){
      @st=split(/\|/,$_);
      print O "$st[0]\n";}
    else {print O "$_\n";}
 }
close A;
close O;

