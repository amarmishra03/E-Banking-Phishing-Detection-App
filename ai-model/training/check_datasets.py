import pandas as pd

url_df = pd.read_csv("../dataset/final_url_dataset.csv")
sms_df = pd.read_csv("../dataset/final_sms_dataset.csv")

print("URL dataset size:", len(url_df))
print(url_df["label"].value_counts())

print("\nSMS dataset size:", len(sms_df))
print(sms_df["label"].value_counts())