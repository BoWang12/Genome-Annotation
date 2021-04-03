#!/usr/bin/perl -w
#perl get.correct.id.pl genbank_fl_cdnas_ATCG_only.2line.fasta;
#
open A,"$ARGV[0]"||die $!;
open O,">formatted.genbank.fa"||die $!;

%genbank=<A>;
foreach $id(keys%genbank){
      $seq=$genbank{$id};
      chomp($id);
      @aa=split(/\s/,$id);
      print O "$aa[0]\n$seq";}

close A;
close O;
 
