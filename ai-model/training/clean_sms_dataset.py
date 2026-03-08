import pandas as pd

# Load dataset
df = pd.read_csv("../dataset/smishing_dataset.csv")

# Rename columns
df = df.rename(columns={
    "TEXT": "text",
    "LABEL": "label"
})

# Convert labels
df["label"] = df["label"].map({
    "ham": 0,
    "spam": 1,
    "Smishing": 1
})

# Keep required columns
df = df[["text", "label"]]

# Remove missing values
df = df.dropna()

# Shuffle dataset
df = df.sample(frac=1).reset_index(drop=True)

# Save cleaned dataset
df.to_csv("../dataset/final_sms_dataset.csv", index=False)

print("SMS dataset prepared successfully")
print(df.head())