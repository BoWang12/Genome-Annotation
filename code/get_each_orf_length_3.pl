#!/usr/bin/perl -w
##perl get_each_orf_length.pl translated.isoforms.protein.fa ID;

#system "grep \'\>\' ear.fa \>ID" ;

open A,"$ARGV[0]"||die $!;
%orf=<A>;
close A;

open B,"$ARGV[1]"||die $!;
#open T,">temp.aa"||die $!;
while(<B>){
    chomp;
    print  "$_\t";
    $len1=length($_);
    foreach $id(keys%orf){
        $aa=$orf{$id};
        chomp($aa);
        $orf_length=length($aa);
        @tm=split(/\s+/,$id);
        @sp=split(/\_/,$tm[0]);
        #pop(@sp);
        #$new=join('_',@sp);
        $len2=length($sp[0]);
          if(($len1==$len2)&&($_=~/$sp[0]/)){
              print  "$orf_length\t";}
       }

     print  "\n";
}

close B;
#close T;

