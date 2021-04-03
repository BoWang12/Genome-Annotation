#!/usr/bin/perl -w
##perl print_each_orf.pl translated.isoforms.protein.fa >eachorf;
#
#open A,"translated.isoforms.protein.fa"||die $!;
open A,"$ARGV[0]"||die $!;
open O,">$ARGV[0].eachorf"||die $!;
#%aa=<A>;
      while(<A>){
       if($_=~/^>/){
        chomp;
        @tm=split(/\s+/,$_);
      #  @sec=split(/\_/,$tm[0]);
        $orf=$tm[1].$tm[2].$tm[3];
      print O "$tm[0]\t$orf\t";}
       else {
         chomp;
         $len=length($_);
         print O "$len\n";}
     }

close A;
close O;


