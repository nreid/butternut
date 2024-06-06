#!/bin/bash
#SBATCH --job-name=process_radtags
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=20G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

echo "host name : " `hostname`

module load stacks/2.64

#input/output directories, supplementary files
INDIR=../results/clone_filtered_fastq/

BARCODES=../meta/barcodes.txt
tail -n +2 ../meta/metadata_for_19IL016.txt | cut -f 4,8 >${BARCODES}

# make demultiplexed directory if it doesn't exist
OUTDIR=../results/demultiplexed_fastqs/
mkdir -p ${OUTDIR}

FASTQ=${INDIR}/19IL016_HF2TMBBXY_s_6.fq

echo demultiplexing file pair $FASTQ1 using barcode set $BARCODES

process_radtags \
-f ${FASTQ} \
-b ${BARCODES} \
-o ${OUTDIR} \
-i fastq \
-e hindIII \
-c \
-q \
--barcode-dist-1 0
