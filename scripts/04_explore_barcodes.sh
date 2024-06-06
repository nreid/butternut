#!/bin/bash
#SBATCH --job-name=possible_barcodes
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

module load bioawk

# infile/outfile
INFILE=../results/clone_filtered_fastq/19IL016_HF2TMBBXY_s_6.fq
OUTDIR=../results/possible_barcodes/
mkdir -p ${OUTDIR}
OUTFILE=../results/possible_barcodes/possible_barcodes.tsv

# tally up possible barcode sequences
    # 5-10 bases then hindiii recognition site, which is not included as part of the match. 
    # this captures known barcodes that also happen to contain hindiii recognition site. 

bioawk -c fastx '{print $seq}' "${INFILE}" | \
grep -oP "^[ACGT]{5,10}(?=AGCTT)" | \
head -n 5000000 | \
sort | \
uniq -c | \
sort -rn | \
sed 's/^  *// ; s/ /\t/' | \
awk '$1 > 10' \
>$OUTFILE

# then in R:

# library(tidyverse)
# tab <- read.table("../results/possible_barcodes/possible_barcodes.tsv")
# meta <- read.table("../meta/metadata_for_19IL016.txt",sep="\t",comment.char="",quote="",header=TRUE)
# tab <- full_join(tab,meta,c(V2="barcode"))
# colnames(tab)[1:2] <- c("barcode_freq","barcode")
# tab <- arrange(tab, -barcode_freq)
# write.table(tab,file="../results/possible_barcodes/barcode_freq_table.tsv", sep="\t", row.names=FALSE)