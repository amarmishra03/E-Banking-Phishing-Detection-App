import pandas as pd

# Load dataset
df = pd.read_csv("../dataset/phishing_urls.csv")

# Rename columns
df = df.rename(columns={
    "URL": "text",
    "Label": "label"
})

# Convert labels
df["label"] = df["label"].map({
    "bad": 1,
    "good": 0
})

# Remove missing values
df = df.dropna()

# Shuffle dataset
df = df.sample(frac=1).reset_index(drop=True)

# Optional: reduce dataset size for faster training
df = df.head(50000)

# Save cleaned dataset
df.to_csv("../dataset/final_dataset.csv", index=False)

print("Dataset prepared successfully")
print(df.head())
print("Dataset size:", len(df))