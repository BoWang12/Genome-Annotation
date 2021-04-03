#!/usr/bin/perl -w
##perl find_supportedintronpos.pl earshortreads_validated_pacbiointron /sonas-hs/ware/hpc/data/bwang/maize/combined_1st2nd/all/collapse/intron_temp_position;
open A,"$ARGV[0]"|| die $!;
$ear=join'',<A>;
@ear_sr=split(/\n/,$ear);
close A;

open B,"$ARGV[1]"||die $!;
while(<B>){
    chomp;
    @tm=split(/\t/,$_);
    $len1=length($tm[0]);
    foreach $line(@ear_sr){
      @sp=split(/\t/,$line);
      $len2=length($tm[0]);
     if(($len1==$len2)&&($tm[1]==$sp[1])&&($tm[2]==$sp[2])){
         print "$tm[0]\t$tm[1]\t$tm[2]\t$tm[3]\t$sp[3]\n";}
  }
}

close B;

