#!/usr/bin/perl -w

## This script is used to calculate the number of isoforms in each gene from Iso-seq data; including 1 isoform;  a little tricky writing, but works very well;

## usage: perl get_pacbio_isoforms_number_per_gene.pl all.collapsed.gff

open A,"$ARGV[0]" || die $!;
open B, ">pacbio_iso" || die $!;
while (<A>){
    chomp;
    @arr=split(/\t/,$_);
    if ($arr[2]=~/transcript/){
      @sec=split(/\;/,$arr[8]);
      @thd=split(/\s+/,$sec[0]);
      $thd[1]=~s/\"//g;
      @fou=split(/\s+/,$sec[1]);
      $fou[2]=~s/\"//g;
      print B "$thd[1]\t$fou[2]\n";
  }
}
close A;
close B;

system "cat ear.collapsed.gff \| cut \-d \'\"\' \-f 2 \| sort \| uniq \>pac_gene_id";

open C, "pacbio_iso" || die $!;
open D, "pac_gene_id" || die $!;
open O, ">pac_gene_iso" || die $!;
$all=join'',<C>;
@al=split(/\n/,$all);
while (<D>){
    chomp;
    $len1=length($_);
    print O "$_";
    foreach $id(@al){
    @sp=split(/\t/,$id);
    $len2=length($sp[0]);
    if (($sp[0]=~/$_/) && ($len1==$len2)){
    print O "\t$sp[1]";}
}
  print O "\n";}
close C;
close D;
close O;

open E, "pac_gene_iso" || die $!;
open F, ">statistics_pacbio_iso" || die $!;
while (<E>){
   chomp;
   @new=split(/\t/,$_);
   $number_of_iso_per_gene=scalar(@new)-1;
   print F "$new[0]\t$number_of_iso_per_gene\n";}
close E;
close F;
