#!/usr/bin/perl -w
##perl get_longestORFid.pl eachorf longest_ORF >longestORF.id;
#
open A,"$ARGV[0]"||die $!;
$all=join'',<A>;
@each=split(/\n/,$all);
close A;

open B,"$ARGV[1]"||die $!;
open O,">$ARGV[1].id"||die $!;
while(<B>){
     chomp;
     @tm=split(/\t/,$_);
     $len1=length($tm[0]);
     foreach $id(@each){
       chomp($id);
       @st=split(/\t/,$id);
       @sp=split(/\_/,$st[0]);
       $len2=length($sp[0]);
      if(($len1==$len2)&&($tm[0]=~/$sp[0]/)&&($tm[1]==$st[2])){
            print O "$id\n";}
    }
}

close B;
close O;
   
