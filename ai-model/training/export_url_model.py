import joblib
import json

print("Loading model...")

model = joblib.load("../models/url_model.pkl")
vectorizer = joblib.load("../models/url_vectorizer.pkl")

weights = model.coef_[0].tolist()
bias = model.intercept_[0]

vocab = vectorizer.vocabulary_

export_data = {
    "weights": weights,
    "bias": bias,
    "vocabulary": vocab
}

with open("../models/url_model.json", "w") as f:
    json.dump(export_data, f)

print("Model exported successfully")