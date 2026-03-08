import joblib

url_model = joblib.load("../models/url_model.pkl")
url_vectorizer = joblib.load("../models/url_vectorizer.pkl")

sms_model = joblib.load("../models/sms_model.pkl")
sms_vectorizer = joblib.load("../models/sms_vectorizer.pkl")

# Test URL
url = ["paypal-login-security-update.com"]

url_features = url_vectorizer.transform(url)

print("URL prediction:", url_model.predict(url_features))

# Test SMS
sms = ["Your bank account has been suspended verify immediately"]

sms_features = sms_vectorizer.transform(sms)

print("SMS prediction:", sms_model.predict(sms_features))