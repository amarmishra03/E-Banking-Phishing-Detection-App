from fastapi import FastAPI
import joblib

app = FastAPI(title="Phishing Detection API")

# Load models
url_model = joblib.load("../models/url_model.pkl")
url_vectorizer = joblib.load("../models/url_vectorizer.pkl")

sms_model = joblib.load("../models/sms_model.pkl")
sms_vectorizer = joblib.load("../models/sms_vectorizer.pkl")


@app.get("/")
def home():
    return {"message": "Phishing Detection API Running"}


@app.post("/detect-url")
def detect_url(data: dict):

    url = data["url"]

    features = url_vectorizer.transform([url])

    prediction = url_model.predict(features)[0]

    if prediction == 1:
        result = "phishing"
    else:
        result = "safe"

    return {
        "input": url,
        "prediction": result
    }


@app.post("/detect-sms")
def detect_sms(data: dict):

    sms = data["message"]

    features = sms_vectorizer.transform([sms])

    prediction = sms_model.predict(features)[0]

    if prediction == 1:
        result = "phishing"
    else:
        result = "safe"

    return {
        "input": sms,
        "prediction": result
    }