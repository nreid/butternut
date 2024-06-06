#!/bin/bash
#SBATCH --job-name=index_genome
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

hostname
date

# load modules
module load datasets/16.13.0
module load bwa/0.7.17

GENOMEDIR=../genome

# datasets download genome accession GCA_002916485.2 --include gtf,gff3,rna,cds,protein,genome,seq-report --filename ${GENOMEDIR}/jnigra.zip
# unzip -d ${GENOMEDIR}/jnigra ${GENOMEDIR}/jnigra.zip
# rm ${GENOMEDIR}/jnigra.zip

# index jcinerea
bwa index \
-p $GENOMEDIR/jcinerea_index \
$GENOMEDIR/jcinerea/chromosome_contigs.masked.fasta

# index jnigra
bwa index \
-p $GENOMEDIR/jnigra_index \
$GENOMEDIR/jnigra/ncbi_dataset/data/GCA_002916485.2/GCA_002916485.2_ASM291648v2_genomic.fna

# index jailantifolia
bwa index \
-p $GENOMEDIR/jailantifolia_index \
$GENOMEDIR/jailantifolia/j_ailantifolia.fasta
