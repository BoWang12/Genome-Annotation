#!/usr/bin/perl -w
###usage: perl longest.pl ;
#
#open C,"temp.aa"||die $!;
open C,"$ARGV[0]"||die $!;
open F,">$ARGV[0].longest_ORF"||die $!;
while(<C>){
    chomp;
    @big=split(/\t/,$_);
    print F "$big[0]\t";
    shift(@big);
    $first=$big[0];
    foreach $num(@big){
      if($num>$first){
         $first=$num;}
       }
    print F "$first\n";
}
close C;
close F;
