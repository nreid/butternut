#!/bin/bash
#SBATCH --job-name=bwa
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[0-383]%100

hostname
date

##################################
# align sequences to the reference
##################################

# this script aligns sequences to the reference genome

# load software--------------------------------------------------------------------------------
module load bwa/0.7.17
module load samtools/1.16.1

# input, output files and directories----------------------------------------------------------
INDIR=../results/demultiplexed_fastqs/

JCINEREA_OUTDIR=../results/aligned_jcinerea
mkdir -p $JCINEREA_OUTDIR

JNIGRA_OUTDIR=../results/aligned_jnigra
mkdir -p $JNIGRA_OUTDIR

JAILANTIFOLIA_OUTDIR=../results/aligned_jailantifolia
mkdir -p $JAILANTIFOLIA_OUTDIR

# reference genome index
JNIGRA=../genome/jnigra_index
JCINEREA=../genome/jcinerea_index
JAILANTIFOLIA=../genome/jailantifolia_index

# make a bash array of fastq files
FASTQS=($(ls $INDIR/*fq))

# pull out a single fastq file pair
FQ1=$(echo ${FASTQS[$SLURM_ARRAY_TASK_ID]})

# get sample ID
SAM=$(basename $FQ1 .fq)

# create bam file name:
JNIGRA_BAM=${SAM}_jnigra.bam
JCINEREA_BAM=${SAM}_jcinerea.bam
JAILANTIFOLIA_BAM=${SAM}_ailantifolia.bam

# get the sample ID and use it to specify the read group. 
RG=$(echo \@RG\\tID:$SAM\\tSM:$SAM)


# align sequences--------------------------------------------------------------------------------
# run bwa mem to align, then pipe it to samtools to compress, then again to sort
# JNIGRA
bwa mem -t 4 -R $RG $JNIGRA $FQ1 | \
samtools view -S -h -u - | \
samtools sort -T /scratch/${SAM}_${USER} - >$JNIGRA_OUTDIR/$JNIGRA_BAM

# index the bam file
samtools index $JNIGRA_OUTDIR/$JNIGRA_BAM


# align sequences--------------------------------------------------------------------------------
# run bwa mem to align, then pipe it to samtools to compress, then again to sort
# JCINEREA
bwa mem -t 4 -R $RG $JCINEREA $FQ1 | \
samtools view -S -h -u - | \
samtools sort -T /scratch/${SAM}_${USER} - >$JCINEREA_OUTDIR/$JCINEREA_BAM

# index the bam file
samtools index $JCINEREA_OUTDIR/$JCINEREA_BAM
date

# align sequences--------------------------------------------------------------------------------
# run bwa mem to align, then pipe it to samtools to compress, then again to sort
# JAILANTIFOLIA
bwa mem -t 4 -R $RG $JAILANTIFOLIA $FQ1 | \
samtools view -S -h -u - | \
samtools sort -T /scratch/${SAM}_${USER} - >$JAILANTIFOLIA_OUTDIR/$JAILANTIFOLIA_BAM

# index the bam file
samtools index $JAILANTIFOLIA_OUTDIR/$JAILANTIFOLIA_BAM
date