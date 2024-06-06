#!/bin/bash
#SBATCH --job-name=filter_vcfs
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=50G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

##################################
# filter variant sets
##################################

module load bcftools/1.9
module load htslib/1.9
module load vcftools/0.1.16
module load vcflib/1.0.0-rc1


###############################
# set input, output directories
###############################

OUTDIR=../results/filtered_vcfs
mkdir -p $OUTDIR

REFMAP=../results/stacks/refmap

#############################
# filter SITES by missingness
#############################

# also remove multiallelic sites and indels

# stacks refmap-----------------------------------------------------------------------
vcftools --gzvcf $REFMAP/populations.snps.dict.vcf.gz \
	--max-missing-count 116 --mac 3 --remove-indels --max-alleles 2 --min-alleles 2 \
	--recode \
	--stdout | \
	bgzip >$OUTDIR/stacks_refmap.vcf.gz

	# output missing individual report
	vcftools --gzvcf $OUTDIR/stacks_refmap.vcf.gz --out $OUTDIR/stacks_refmap --missing-indv


###################################
# filter INDIVIDUALS by missingness
###################################

# # create a list of samples with high rates of missing genotypes to exclude
# DROPSAMPLES=$(tail -n +2 $OUTDIR/stacks_refmap.imiss | awk '$5 > .1' | cut -f 1 | tr "\n" "," | sed 's/,$//')

# # drop samples with high rates of missing data, also exclude low variant quality variants from freebayes

# # stacks refmap
# bcftools view -s ^$DROPSAMPLES $OUTDIR/stacks_refmap.vcf.gz | bgzip -c > $OUTDIR/refmap_final.vcf.gz

##############
# make indexes
##############

for file in $OUTDIR/*vcf.gz
do tabix -f -p vcf $file
done