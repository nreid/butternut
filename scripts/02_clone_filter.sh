#!/bin/bash
#SBATCH --job-name=clone_filter
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=100G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

echo "host name : " `hostname`

module load stacks/2.64

#input/output directories, supplementary files
INDIR=../rawdata/
OUTDIR=../results/clone_filtered_fastq/
mkdir -p ${OUTDIR}

FASTQ=${INDIR}/19IL016_HF2TMBBXY_s_6.fastq

# run clone_filter
	# expected oligo sequence: NNNN followed by variable length barcode, followed by HindIII recognition sequence. 

clone_filter \
-i fastq \
-o ${OUTDIR} \
-f ${FASTQ} \
--inline-null \
--oligo_len_1 4
