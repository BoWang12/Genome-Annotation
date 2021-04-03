#! /bin/bash

/sonas-hs/ware/hpc/home/bwang/software/gmap-2015-09-29/bin/gmap -D /sonas-hs/ware/hpc_norepl/data/bwang/maizeflcdna/B73V4_2016 -d maizev4 -f gff3_gene -t 10 -n 1 /sonas-hs/ware/hpc_norepl/data/bwang/maizeflcdna/genbank_fl_cdnas_ATCG_only.2line.fasta  > /sonas-hs/ware/hpc_norepl/data/bwang/maizeflcdna/flCDNA.mapping.gff3 2> /sonas-hs/ware/hpc_norepl/data/bwang/maizeflcdna/flCDNA.mapping.log
