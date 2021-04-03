#!/usr/bin/perl -w

open A,"mRNA.gff"||die $!;
while(<A>){
   chomp;
   @aa=split(/\t/,$_);
   @bb=split(/\;/,$aa[8]);
   @cc=split(/\=/,$bb[3]);
   @dd=split(/\=/,$bb[5]);
   @ee=split(/\|/,$dd[1]);
    # if($ee[1]>0){
   #$out=join ("\t",@aa);
  #print "$out\n";}    
   if($cc[1]<=0.5){
      if(($ee[1]>0)||($ee[1]==-1)){
   # print "$bb[0]\n";}
   print "$bb[2]\n";
 }
}
}

close A;


