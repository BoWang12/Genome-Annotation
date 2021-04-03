#$ -S /bin/bash
#$ -cwd
#$ -N chr6.fasta
#$ -o /grid/ware/data_norepl/bwang/RP125/maker_run/output/chr6.fasta-out.txt
#$ -e /grid/ware/data_norepl/bwang/RP125/maker_run/error/chr6.fasta-err.txt
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

#$ -l m_mem_free=4G
#$ -l tmp_free=300G
#$ -pe mpi 32

unset PERL5LIB

module load EBModules
module load git/2.23.0-GCCcore-8.3.0-nodocs Perl/5.30.0-GCCcore-8.3.0 bzip2/1.0.8-GCCcore-8.3.0
module load AUGUSTUS/3.3.3-foss-2019b

export LD_PRELOAD=/grid/ware/data_norepl/programs/elzar/mpich/lib/libmpi.so
export PATH=/grid/ware/data_norepl/programs/elzar/mpich/bin:/grid/ware/data_norepl/programs/wublast.old:/grid/ware/data_norepl/programs/elzar/trf:/grid/ware/data_norepl/programs/elzar/RepeatMasker:/grid/ware/data_norepl/programs/elzar/maker/bin:$PATH
#export AUGUSTUS_CONFIG_PATH=/mnt/grid/ware/hpc/home/data/mcampbel/applications/augustus-3.1/config
export AUGUSTUS_CONFIG_PATH=/mnt/grid/ware/hpc/home/data/luj/augustus_config



mpiexec -n 32 maker -R -g /grid/ware/data_norepl/bwang/RP125/masked2.genome/chr6.fasta -t 10 -TMP $TMPDIR -fix_nucleotides || { echo JOB_STATUS=ERROR 1>&2; exit; }

echo "MAKER_RUN IS COMPLETE"




# end of template
echo '=================================================='
echo END_TIME=`date`
echo '=================================================='

#################################################



















