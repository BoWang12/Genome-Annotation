#!/usr/bin/perl -w

open TE,"TE_interpro_doamins.txt"||die $!;


$te=join'',<TE>;
@all=split(/\n/,$te);
close TE;

open A,"mRNA.with.IPR.gff"||die $!;
while(<A>){
  chomp;
   foreach $line(@all){
     @aa=split(/\s+/,$line);
      if($_=~/$aa[0]/){
     print "$_\n";}
  }
}

close A;


