import pandas as pd
import glob
import os

# Create output folder
output_folder = "filtered_output"
os.makedirs(output_folder, exist_ok=True)

# Loop through all .ratio.txt files
for file in glob.glob("*.ratio.txt"):
    # Read the file (assuming tab-delimited)
    df = pd.read_csv(file, sep="\t")
    
    # Apply filtering conditions
    filtered = df[
        (df["Pe_ratio"] >= 0.01) &
        (df["Pe_R"] > 5) &
        (df["Span_R"] > 3)
    ]
    
    # Save only if there are matching rows
    if not filtered.empty:
        out_file = os.path.join(output_folder, os.path.basename(file).replace(".ratio.txt", "_filtered.txt"))
        filtered.to_csv(out_file, sep="\t", index=False)
        print(f"Filtered rows saved to {out_file}")
    else:
        print(f"No matching rows in {file}")
