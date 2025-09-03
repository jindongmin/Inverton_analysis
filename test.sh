#!/bin/bash
#SBATCH --job-name=phasefinder        
#SBATCH --output=phasefinder_%j.log   
#SBATCH --ntasks=1                    
#SBATCH --cpus-per-task=16            
#SBATCH --mem=64G                     
#SBATCH --time=0             
#SBATCH --partition=regular  
        
## Identify regions flanked by inverted repeats 
#python PhaseFinder.py locate -f ./data/test.fa -t ./data/test.einverted.tab -g 15 85 -p 
#
## Mimic inversion
#python PhaseFinder.py create -f ./data/test.fa -t ./data/test.einverted.tab -s 1000 -i ./data/test.ID.fasta
#
## Identify regions where sequencing reads support both orientations 
#python PhaseFinder.py ratio -i ./data/test.ID.fasta -1 ./data/p1.fq -2 ./data/p2.fq -p 16 -o ./data/out


# Identify regions flanked by inverted repeats
python PhaseFinder.py locate -f /workdir/dj3371/UHGG/downloaded_fna_files/MGYG000000001.fna -t ./data/MGYG000000001.tab -g 15 85 -p

# Mimic inversion
python PhaseFinder.py create -f /workdir/dj3371/UHGG/downloaded_fna_files/MGYG000000001.fna -t ./data/MGYG000000001.tab -s 1000 -i ./data/MGYG000000001.ID.fasta

# Identify regions where sequencing reads support both orientations
python PhaseFinder.py ratio -i ./data/MGYG000000001.ID.fasta -1 /workdir/dj3371/Nielsen2015/test_10_pairs/fq/SRR5935812_1.fastq -2 /workdir/dj3371/Nielsen2015/test_10_pairs/fq/SRR5935812_2.fastq -p 16 -o ./data/out_MGYG000000001
