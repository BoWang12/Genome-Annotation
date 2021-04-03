#!/usr/bin/perl -w

##usage: perl get_longestprotein.pl translated.isoforms.protein.fa longestORF.id >pollen.longest.orf.aa ;
#
open A,"$ARGV[0]"||die $!;
%aa=<A>;
close A;

open B,"$ARGV[1]"||die $!;
open O,">$ARGV[1].longest.orf.aa"||die $!;
while(<B>){
    chomp;
    @qry=split(/\s+/,$_);
    $len1=length($qry[0]);
    #$len2=length($qry[1]);
    $qry[1]=~s/\[//g;
    $qry[1]=~s/\]//g;
    @qry_nd=split(/\-/,$qry[1]);
    foreach $id(keys%aa){
        $seq=$aa{$id};
        chomp($id);
        @tm=split(/\s+/,$id);
        #$tm[1]=~s/\s+//g;
        $new=join'',$tm[1],$tm[2],$tm[3];
        #print "$new\n";
        $len3=length($tm[0]);
        #$len4=length($new);
        $new=~s/\[//g;
        $new=~s/\]//g;
        @new_sp=split(/\-/,$new);
        if(($len1==$len3)&&($qry[0]=~/$tm[0]/)&&($qry_nd[0]==$new_sp[0])&&($qry_nd[1]==$new_sp[1])){
             print O "$id\n$seq";}
       }
}

close B;
close O;
        
