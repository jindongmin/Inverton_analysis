import pandas as pd
import glob

# file path
files = glob.glob("data/out_*.ratio.txt")

for f in files:
    df = pd.read_csv(f, sep="\t")
    # check for rows with no NA in the numeric columns
    numeric_cols = ["Pe_F", "Pe_R", "Pe_ratio", "Span_F", "Span_R", "Span_ratio"]
    valid_rows = df[numeric_cols].notna().all(axis=1)
    
    if valid_rows.any():
        print(f"{f}: at least one row has no NA values")
    else:
        print(f"{f}: all rows have some NA values")
