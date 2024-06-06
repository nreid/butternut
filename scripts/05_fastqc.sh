#!/bin/bash
#SBATCH --job-name=fastqc_raw
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --mem=4G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --array=[0-383]
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

##########################
# run fastqc 
##########################

# load software
module load fastqc/0.11.7

#input/output directories, supplementary files
INDIR=../results/demultiplexed_fastqs/

OUTDIR=../results/fastqc
mkdir -p $OUTDIR

# make bash array of R1 fastqs
FQ=($(find $INDIR -name "*.fq" | sort))

# get R1 and R2 file names for this array instance
FQ1=${FQ[$SLURM_ARRAY_TASK_ID]}

# run fastqc on read 1, read 2
fastqc -t 2 -o $OUTDIR $FQ1