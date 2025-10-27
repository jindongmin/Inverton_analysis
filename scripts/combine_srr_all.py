#!/usr/bin/env python3
import pandas as pd
import glob
import os
import re
import sys

# Check if the user provided a folder path
if len(sys.argv) < 2:
    print("Usage: python combine_srr.py /path/to/filtered_files")
    sys.exit(1)

input_folder = sys.argv[1]

# Make sure the folder exists
if not os.path.isdir(input_folder):
    print(f"Error: folder '{input_folder}' does not exist.")
    sys.exit(1)

# Find all filtered files for the given MAG
all_files = glob.glob(os.path.join(input_folder, "out_*_filtered.txt"))

if not all_files:
    print("No files found matching pattern 'out_*_filtered.txt'")
    sys.exit(1)

df_list = []

for file in all_files:
    # Read the file
    df = pd.read_csv(file, sep="\t")
    filename=os.path.basename(file)
    # Extract SRR_ID from filename using regex
    match = re.search(r'SRR[0-9]+', filename)
    if match:
        df['SRR_ID'] = match.group(0)
    else:
        df['SRR_ID'] = "UNKNOWN"
    # Extract MAG_ID from filename (between out_ and _SRR)
    mag_match = re.search(r'out_(.*?)_SRR', filename)
    df['MAG_ID'] = mag_match.group(1) if mag_match else "UNKNOWN"    
    df_list.append(df)

# Concatenate all dataframes
combined_df = pd.concat(df_list, ignore_index=True)

# Sort by 'ID' column
combined_df = combined_df.sort_values(by="ID").reset_index(drop=True)

# Save to CSV
output_file = os.path.join(input_folder, "combined_with_SRR_all.csv")
combined_df.to_csv(output_file, index=False)
print(f"Combined CSV saved to {output_file}")
