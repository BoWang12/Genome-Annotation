#!/usr/bin/perl -w
#  open R,"emboss";
  open R,"$ARGV[0]"||die $!;
  open R1,">TL.fa"||die $!;
  while(<R>){
    if($_=~/^>/){
    print R1 "\n$_";}
    else{
    chomp($_);
    print R1 "$_";
  }
}

close R;
close R1;

open A,"TL.fa"||die $!;
open O,">$ARGV[0].protein.fa"||die $!;
$all=join'',<A>;
@sp=split(/\n/,$all);
shift(@sp);
$new=join("\n",@sp);
print O "$new";
print O "\n";

close A;
close O;

system "rm \-rf TL.fa";
