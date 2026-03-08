import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report
import joblib

print("Loading SMS dataset...")

df = pd.read_csv("../dataset/final_sms_dataset.csv")

X = df["text"]
y = df["label"]

print("Dataset size:", len(df))

# Convert SMS text to numerical features
vectorizer = TfidfVectorizer(
    stop_words="english",
    ngram_range=(1,2)
)

X_vectorized = vectorizer.fit_transform(X)

# Split dataset
X_train, X_test, y_train, y_test = train_test_split(
    X_vectorized,
    y,
    test_size=0.2,
    random_state=42
)

print("Training SMS phishing model...")

model = LogisticRegression(max_iter=1000)

model.fit(X_train, y_train)

# Evaluate
predictions = model.predict(X_test)

accuracy = accuracy_score(y_test, predictions)

print("SMS Model Accuracy:", accuracy)

print(classification_report(y_test, predictions))

# Save model
joblib.dump(model, "../models/sms_model.pkl")
joblib.dump(vectorizer, "../models/sms_vectorizer.pkl")

print("SMS model saved successfully")