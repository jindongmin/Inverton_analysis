# Snakefile for running PhaseFinder on multiple genomes and paired-end reads

import os
import glob

# input directories
GENOME_DIR = "/workdir/dj3371/UHGG/downloaded_fna_files"
FASTQ_DIR = "/workdir/dj3371/Nielsen2015/test_10_pairs/fq"
DATA_DIR = "data"

# functions
def get_genomes():
    return [os.path.basename(f) for f in glob.glob(os.path.join(GENOME_DIR, "*.fna"))]

def get_fastq_pairs():
    #fq files are named *_1.fastq and *_2.fastq
    r1_files = sorted(glob.glob(os.path.join(FASTQ_DIR, "*_1.fastq")))
    r2_files = [f.replace("_1.fastq","_2.fastq") for f in r1_files]
    return list(zip(r1_files, r2_files))

FASTQ_PAIRS = get_fastq_pairs()
GENOMES = [g.replace(".fna","") for g in get_genomes()]
SAMPLES = [os.path.basename(r1).replace("_1.fastq","") for r1,r2 in FASTQ_PAIRS]
# Rules
rule all:
    input:
        expand(os.path.join(DATA_DIR, "{genome}.ID.fasta"), genome=GENOMES),
        expand(os.path.join(DATA_DIR, "out_{genome}_{sample}.ratio.txt"), genome=GENOMES, sample=SAMPLES)
# Locate inverted repeats
rule locate:
    input:
        genome = os.path.join(GENOME_DIR, "{genome}.fna")
    output:
        tab = os.path.join(DATA_DIR, "{genome}.tab")
    threads: 1
    shell:
        """
        python PhaseFinder.py locate -f {input.genome} -t {output.tab} -g 15 85 -p
        """

# Mimic inversion
rule create:
    input:
        genome = os.path.join(GENOME_DIR, "{genome}.fna"),
        tab = os.path.join(DATA_DIR, "{genome}.tab")
    output:
        fasta = os.path.join(DATA_DIR, "{genome}.ID.fasta")
    threads: 1
    shell:
        """
        python PhaseFinder.py create -f {input.genome} -t {input.tab} -s 1000 -i {output.fasta}
        """

# Ratio (paired-end reads)
rule ratio:
    input:
        fasta = os.path.join(DATA_DIR, "{genome}.ID.fasta"),
        r1 = lambda wc: os.path.join(FASTQ_DIR, f"{wc.sample}_1.fastq"),
        r2 = lambda wc: os.path.join(FASTQ_DIR, f"{wc.sample}_2.fastq")
    output:
        #directory(os.path.join(DATA_DIR, "{genome}_{sample}"))
        ratio_file = os.path.join(DATA_DIR,"out_{genome}_{sample}.ratio.txt")
    threads: 16
    shell:
        """
        python PhaseFinder.py ratio -i {input.fasta} -1 {input.r1} -2 {input.r2} -p {threads} -o {DATA_DIR}/out_{wildcards.genome}_{wildcards.sample}
        """

