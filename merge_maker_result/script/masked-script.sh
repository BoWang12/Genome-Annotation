#$ -S /bin/bash
#$ -cwd
#$ -N luj-masked
#$ -o /grid/ware/data_norepl/bwang/RP125/merge_maker_result/output/masked-out.txt
#$ -e /grid/ware/data_norepl/bwang/RP125//merge_maker_result/error/masked-err.txt
#$ -terse
###$ -l virtual_free=3.8G
#$ -l m_mem_free=3.8G
###$ –l h_vmem=3.8G



echo '=================================================='
# print local SGE vars
echo JOB_ID=$JOB_ID
echo QUEUE=$QUEUE
echo SGE_TASK_ID=$SGE_TASK_ID
echo TMPDIR=$TMPDIR
echo PWD=$PWD
echo SUBMIT_TIME=`date`
echo '=================================================='

#$ -v PATH,CLASSPATH,JARPATH,PERL5LIB,LD_LIBRARY_PATH,DATA_HOME,DATAFC_HOME




# staging


# start of template

export PATH=/mnt/grid/ware/hpc_norepl/data/data/programs/maker/bin:$PATH
mkdir -p -m 777 maker_final_annotations

gff3_merge -g -n -o maker_final_annotations/RP125.maker.gene_only.gff *.maker.output/*_datastore/*/*/*/*.gff || { echo JOB_STATUS=ERROR 1>&2; exit; }
gff3_merge -n -o maker_final_annotations/RP125.maker.all.gff *.maker.output/*_datastore/*/*/*/*.gff || { echo JOB_STATUS=ERROR 1>&2; exit; }



cat *.maker.output/*_datastore/*/*/*/*.maker.proteins.fasta > maker_final_annotations/RP125.maker.proteins.fasta || { echo JOB_STATUS=ERROR 1>&2; exit; }
cat *.maker.output/*_datastore/*/*/*/*.maker.transcripts.fasta > maker_final_annotations/RP125.maker.transcripts.fasta || { echo JOB_STATUS=ERROR 1>&2; exit; }
cat *.maker.output/*_datastore/*/*/*/*.maker.model_gff%3AMikado_loci.proteins.fasta > maker_final_annotations/RP125.maker.model_gff%3AMikado_loci.proteins.fasta || { echo JOB_STATUS=ERROR 1>&2; exit; }
cat *.maker.output/*_datastore/*/*/*/*.maker.model_gff%3AMikado_loci.transcripts.fasta > maker_final_annotations/RP125.maker.model_gff%3AMikado_loci.transcripts.fasta || { echo JOB_STATUS=ERROR 1>&2; exit; }
cat *.maker.output/*_datastore/*/*/*/*.maker.model_gff%3AAUGUSTUS.proteins.fasta > maker_final_annotations/RP125.maker.model_gff%3AAUGUSTUS.proteins.fasta || { echo JOB_STATUS=ERROR 1>&2; exit; }
cat *.maker.output/*_datastore/*/*/*/*.maker.model_gff%3AAUGUSTUS.transcripts.fasta > maker_final_annotations/RP125.maker.model_gff%3AAUGUSTUS.transcripts.fasta || { echo JOB_STATUS=ERROR 1>&2; exit; }
cat *.maker.output/*_datastore/*/*/*/*.maker.model_gff%3A%2E.proteins.fasta > maker_final_annotations/RP125.maker.model_gff%3A%2E.proteins.fasta || { echo JOB_STATUS=ERROR 1>&2; exit; }
cat *.maker.output/*_datastore/*/*/*/*.maker.model_gff%3A%2E.transcripts.fasta > maker_final_annotations/RP125.maker.model_gff%3A%2E.transcripts.fasta || { echo JOB_STATUS=ERROR 1>&2; exit; }
#cat *.maker.output/*_datastore/*/*/*/*.maker.model_gff%3AFgenesh.proteins.fasta > maker_final_annotations/Ti11.maker.model_gff%3AFgenesh.proteins.fasta || { echo JOB_STATUS=ERROR 1>&2; exit; }
#cat *.maker.output/*_datastore/*/*/*/*.maker.model_gff%3AFgenesh.transcripts.fasta > maker_final_annotations/Ti11.maker.model_gff%3AFgenesh.transcripts.fasta || { echo JOB_STATUS=ERROR 1>&2; exit; }

echo "MERGE IS COMPLETE"




# end of template
echo '=================================================='
echo END_TIME=`date`
echo '=================================================='

#################################################



















