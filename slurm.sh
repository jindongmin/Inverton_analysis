#!/bin/bash
#SBATCH --job-name=PhaseFinder
#SBATCH --output=slurm-PhaseFinder-%j.out
#SBATCH --error=slurm-PhaseFinder-%j.err
#SBATCH --partition=regular      
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dj3371@princeton.edu

# Run Snakemake with per-rule resources
#snakemake \
#    --jobs 100 \
#    --latency-wait 60 \
#    --rerun-incomplete \
#    --keep-going \
#    --cluster "sbatch \
#        --job-name={rule} \
#        --cpus-per-task={threads} \
#        --mem={resources.mem}G \
#        --time={resources.time} \
#        --output=logs/slurm-%x-%j.out"


snakemake --rerun-incomplete --cores 120 
