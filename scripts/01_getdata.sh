#!/bin/bash
#SBATCH --job-name=get_data
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


# reads
mkdir -p ../rawdata

ln -s /core/projects/EBP/conservation/butternut_QG/snp_calling/01_rawdata/19IL016_HF2TMBBXY_s_6.fastq ../rawdata/19IL016_HF2TMBBXY_s_6.fastq

# genome ?? which one ?? isn't there another ??

mkdir -p ../genome/jcinerea
cp /core/globus/cgi/jcinerea/annotation/01_genome/repeatmasker_out/chromosome_contigs.masked.fasta ../genome/jcinerea

# metadata

cp /core/projects/EBP/conservation/butternut_QG/snp_calling/01_rawdata/metadata_for_19IL016.txt ../meta/