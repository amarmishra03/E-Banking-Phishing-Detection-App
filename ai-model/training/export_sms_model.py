import joblib
import json

model = joblib.load("../models/sms_model.pkl")
vectorizer = joblib.load("../models/sms_vectorizer.pkl")

weights = model.coef_[0].tolist()
bias = model.intercept_[0]

vocab = vectorizer.vocabulary_

export_data = {
    "weights": weights,
    "bias": bias,
    "vocabulary": vocab
}

with open("../models/sms_model.json", "w") as f:
    json.dump(export_data, f)

print("SMS model exported")