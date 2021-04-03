#!/usr/bin/env perl

#gff2gene_stats.pl file.gff > output
#Assumes no intron features so need to calculate those

use strict;
use File::Basename;

my ($file, $flag_file) = @ARGV;

my $flag_id = get_flags($flag_file);
#five_prime_UTR
my $file_name = fileparse($file);
print join("\t", 'file_name:', $file_name), "\n";
print join("\t", 'flag_file:', $flag_file), "\n";

my ($feat_cnt,       #sum total count of features, hashref 
    $feat_len,       #sum total length of features, hashref
    $feat_lengths,   #hash of array of all feature lengths
    $exons,          #hash of array of canonical exon coordinates keyed to mRNA id
    $five_UTR,
    $three_UTR,
    $gid_of_tid
    ) = analyze_gff($file);

my $tot_exon_cnt;
my $single_exon_cnt;
my %multi_exon_gene;

for my $tid (keys %$exons){
    my @model = sort {$a->[0]<=>$b->[0]} @{$exons->{$tid}};
    my $cnt = scalar @model;
    $tot_exon_cnt += $cnt;
    
    $single_exon_cnt++ && next if $cnt == 1;
    $multi_exon_gene{$gid_of_tid->{$tid}} = 1;
   
    my ($intron_cnt, $intron_len) = process_introns(\@model);
    #print join("\t", $parent, $intron_cnt, $intron_len), "\n";
    $feat_cnt->{'intron'} += $intron_cnt;
    $feat_len->{'intron'} += $intron_len;
   # push @{$feat_lengths->{'intron'}}, $intron_len;
}

for my $feat ( qw(gene exon intron CDS peptide five_prime_UTR three_prime_UTR) ){
    my $cnt = $feat_cnt->{$feat};
    warn "$feat has 0 counts\n" && next unless $feat_cnt->{$feat};
    my $len = $feat_len->{$feat};
    my $ave = sprintf("%.0f", $len/$cnt);
    my @feat_lengths = @{$feat_lengths->{$feat}};
    my $median = median(\@feat_lengths);
    print join("\t", $feat . ' count:', $cnt,), "\n";
    print join("\t", $feat . ' length(ave):', $ave,), "\n";
    print join("\t", $feat . ' length(median):', $median,), "\n";
}

my $txp_cnt = scalar keys %$exons;
warn "transcript count is 0\n" unless $txp_cnt;
my $ave_exon_cnt = sprintf("%.1f", $tot_exon_cnt/$txp_cnt);
my $single_exon_gene_cnt = $feat_cnt->{'gene'} - scalar keys %multi_exon_gene;
my $single_exon_gene_pct 
    = sprintf("%.1f", 100*$single_exon_gene_cnt/$feat_cnt->{'gene'});
print join("\t", 'exons per txp(ave):', $ave_exon_cnt,), "\n";
print join("\t", 'single-exon gene count (pct):', $single_exon_gene_cnt .
	   ' (' . $single_exon_gene_pct . ')', ), "\n";

print "*Note:longest_CDS_transcript_used_for_calculation_of_CDS_and_Protein_length_statistics\n";

sub median {
    my $values = shift;
    my @a = sort {$a <=> $b} @$values;
    my $length = scalar @a;
    return undef unless $length;
    ($length % 2)
        ? $a[$length/2]
        : ($a[$length/2] + $a[$length/2-1]) / 2.0;
}

sub process_introns {
    my $model = shift;
    my @exons = @$model;
    
    my ($intron_cnt, $intron_len);
    for my $i (0 .. $#exons - 1){
	my ($s, $e) = @{$exons[$i]};      
	my  $intron_s = $e + 1;
	my  ($intron_e) = @{$exons[$i+1]};
	$intron_e--;
	my $length = $intron_e - $intron_s + 1;
	$intron_len += $length;
	$intron_cnt++;
	push @{$feat_lengths->{'intron'}}, $length;
    }
    return ($intron_cnt, $intron_len);
}


sub analyze_gff {
    my $gff = shift;
    my (%feat_cnt, %feat_len, %cds_len, %exons, %feat_lengths, %five_prime_UTR, %three_prime_UTR);
    my %seen;
    my (%gid_of_tid, %tid_of_gid);

    open my $GFF, "<$gff" or die "Cannot open $gff: $!\n";
    while(<$GFF>){
	next if /\#/; #skip header
	chomp;
	my ($ref, $src, $feat, $s, $e, $sc, $str, $ph, $att, ) = split /\t/;
	my %attributes = parse_c9($att);
	my $id = $attributes{'ID'};
	my $parent = $attributes{'Parent'};
	my $name = $attributes{'Name'};
	next if $flag_id->{$id};
	next if $flag_id->{$parent};
	next if $flag_id->{$name};

	if ($feat eq 'gene'){
	    $feat_cnt{$feat}++;
	    $feat_len{$feat} += $e - $s + 1;
	    push @{$feat_lengths{$feat}}, $e - $s + 1;
	}
	elsif ($feat eq 'exon'){
	    my $parent_list = $attributes{'Parent'}; #MAKER GFF exons have multiple parents
	    my @parents = split(/,/, $parent_list);
            for my $tid (@parents){
                #This to be used for intron determination and exons/gene (after canonical filtering);
		push @{$exons{$tid}}, [$s, $e];
            }
	}
	
        elsif ($feat eq 'five_prime_UTR'){  
            my $parent_list = $attributes{'Parent'}; #MAKER GFF exons have multiple parents
            my @parents = split(/,/, $parent_list);
            for my $tid (@parents){
                push @{$five_prime_UTR{$tid}}, [$s, $e];
            }
        }
	
	elsif ($feat eq 'three_prime_UTR'){
            my $parent_list = $attributes{'Parent'}; #MAKER GFF exons have multiple parents
            my @parents = split(/,/, $parent_list);
            for my $tid (@parents){   
                push @{$three_prime_UTR{$tid}}, [$s, $e];
            }
        }
                
	elsif ($feat eq 'CDS'){ #Sum up CDS to get coding length
	    my %attributes = parse_c9($att);
	    my $tid = $attributes{'Parent'};
	    $cds_len{$tid} += $e - $s + 1;
	}
	elsif ($feat eq 'mRNA'){
	    my $gid = $attributes{'Parent'};
	    my $tid = $attributes{'ID'};
	    $gid_of_tid{$tid} = $gid;
	    $tid_of_gid{$gid}->{$tid} = 1;
	}
    } 
    
    $feat_cnt{'Transcript'} = scalar keys %gid_of_tid;
    $feat_cnt{'CDS'} = scalar(keys %cds_len);
    $feat_cnt{'peptide'} = $feat_cnt{'CDS'};
    
    my %canonical;
    for my $gid (keys %tid_of_gid){
	my @sorted = sort { $cds_len{$a}<=>$cds_len{$b} } keys %{$tid_of_gid{$gid}};
	$canonical{$sorted[-1]} = 'canonical';
    }
    
    for my $tid (keys %cds_len){
	next unless $canonical{$tid};
	next if $flag_id->{$tid};
	my $coding_len = $cds_len{$tid};
	$feat_len{'CDS'} += $coding_len;
	push @{$feat_lengths{'CDS'}}, $coding_len;
	
	my $peptid_len = $coding_len/3;
	$feat_len{'peptide'} += $peptid_len;
	push @{$feat_lengths{'peptide'}} , $peptid_len;
    }

    my %canonical_exons;
    for my $tid (keys %exons){
	next unless $canonical{$tid};
        next if $flag_id->{$tid};
	for my $exon (@{$exons{$tid}}){
	    my ($s, $e) = @$exon;
	    $feat_cnt{'exon'}++;
	    $feat_len{'exon'} += $e - $s + 1;
	    push @{$feat_lengths{'exon'}}, $e - $s + 1; 
	}
	$canonical_exons{$tid} = [@{$exons{$tid}}];
    }

    my %canonical_five_UTR;
    for my $tid (keys %five_prime_UTR){
        next unless $canonical{$tid};
        next if $flag_id->{$tid};
        for my $fUTR (@{$five_prime_UTR{$tid}}){
            my ($s, $e) = @$fUTR;
            $feat_cnt{'five_prime_UTR'}++;
            $feat_len{'five_prime_UTR'} += $e - $s + 1;
            push @{$feat_lengths{'five_prime_UTR'}}, $e - $s + 1;
        }
        $canonical_five_UTR{$tid} = [@{$five_prime_UTR{$tid}}];
    }
        
    my %canonical_three_UTR;
    for my $tid (keys %three_prime_UTR){
        next unless $canonical{$tid};
        next if $flag_id->{$tid};
        for my $tUTR (@{$three_prime_UTR{$tid}}){
            my ($s, $e) = @$tUTR;
            $feat_cnt{'three_prime_UTR'}++;
            $feat_len{'three_prime_UTR'} += $e - $s + 1;
            push @{$feat_lengths{'three_prime_UTR'}}, $e - $s + 1;
        }
        $canonical_three_UTR{$tid} = [@{$three_prime_UTR{$tid}}];
    }

    return (\%feat_cnt, \%feat_len, \%feat_lengths, \%canonical_exons, \%canonical_five_UTR, \%canonical_three_UTR, \%gid_of_tid);
}

sub parse_c9 {
    my $c9 = shift;
    my %c9;
    my @c9_fields = split(/;/, $c9); #each key/val pair is semicolin delimited
    for my $field (@c9_fields){
	my ($key, $val) = split(/=/, $field);
	$c9{$key} = $val;
    }
    return %c9;
}

sub get_flags {
    my $file = shift;
    my %flag_id;
    open my $IN, "<$file" or warn "need a flag file\n";
    while(<$IN>){
	chomp;
	my ($gid, $tid, $pid,) = split /\t/;
	$flag_id{$gid} = 1 if $gid;
	$flag_id{$tid} = 1 if $tid;
	$flag_id{$pid} = 1 if $pid;
    }
    return \%flag_id;
}
