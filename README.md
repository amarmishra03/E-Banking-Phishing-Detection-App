# E-Banking Phishing Detection App

An **AI-based Android application** that detects **phishing URLs and banking-related phishing SMS messages in real time** using on-device machine learning models. The system analyzes suspicious URLs and SMS content to warn users about potential e-banking fraud attempts.

This project was developed as part of the **B.Tech Computer Science & Engineering Capstone Project**.

---

# Project Overview

Phishing attacks targeting **online banking users** are increasing rapidly. Many users are unable to distinguish between legitimate banking messages and fraudulent phishing attempts.

This application provides a **mobile security solution** that:

* Detects phishing URLs
* Detects phishing SMS messages (smishing)
* Runs **AI models locally on the device**
* Alerts users in real time
* Stores detection logs for analysis

The application ensures **privacy, fast response time, and offline detection** by performing **on-device AI inference**.

---

# Key Features

### 1. URL Phishing Detection

Users can manually scan URLs to determine whether they are safe or phishing attempts.

### 2. SMS Phishing Detection

The application analyzes SMS messages and detects phishing or fraudulent content.

### 3. Real-Time SMS Monitoring

Incoming SMS messages are automatically scanned in real time using a background Android service.

### 4. On-Device AI Detection

All AI models run locally on the device without sending user data to external servers.

### 5. Phishing Alerts

The system immediately notifies the user when a phishing message or link is detected.

### 6. Detection History

All scanned messages and URLs are stored in a **local SQLite database** for later review.

---

# System Architecture

```
Incoming SMS / User URL Input
            │
            ▼
      Flutter Android App
            │
            ▼
     On-Device AI Model
            │
            ▼
     Phishing Prediction
            │
      ┌─────┴─────┐
      ▼           ▼
 Notification   SQLite Logs
```

---

# Technology Stack

### Mobile Application

* Flutter (Android UI)

### Android System Layer

* Kotlin
* Android Broadcast Receiver
* Android Services

### Artificial Intelligence

* Python
* Scikit-Learn
* TF-IDF Feature Extraction
* Logistic Regression Model

### Database

* SQLite (local storage)

### Development Tools

* Android Studio
* Flutter SDK
* Python
* Git

Optional testing tools:

* FastAPI (local API testing)

---

# Project Structure

```
E-Banking-Phishing-Detection-App
│
├── ai-model
│   ├── dataset
│   ├── models
│   ├── training
│   └── export scripts
│
├── mobile-app
│   ├── android
│   ├── lib
│   │   ├── screens
│   │   ├── services
│   │   ├── utils
│   │   └── widgets
│   │
│   ├── assets
│   │   └── models
│   │
│   └── pubspec.yaml
│
└── README.md
```

---

# AI Model Pipeline

The phishing detection model is built using the following pipeline:

```
Dataset
   │
   ▼
Text Preprocessing
   │
   ▼
TF-IDF Vectorization
   │
   ▼
Logistic Regression Model
   │
   ▼
Model Export
   │
   ▼
On-Device Inference in Flutter
```

Two models are trained:

1. **URL Phishing Detection Model**
2. **SMS Phishing Detection Model**

---

# Dataset Sources

### URL Dataset

Large dataset of phishing and legitimate URLs used to train the phishing URL detection model.

### SMS Dataset

Smishing dataset containing legitimate and phishing SMS messages used for SMS classification.

Datasets were cleaned, labeled, and preprocessed before model training.

---

# Installation & Setup

## 1. Clone the Repository

```
git clone https://github.com/yourusername/phishing-detection-app.git
```

---

## 2. Train the AI Models

Navigate to the AI model folder:

```
cd ai-model
```

Activate the Python environment and run training scripts.

---

## 3. Export Models for Mobile

After training, export model parameters for on-device inference.

The exported models are stored in:

```
mobile-app/assets/models
```

---

## 4. Run the Mobile Application

Navigate to the Flutter project:

```
cd mobile-app
```

Install dependencies:

```
flutter pub get
```

Run the application:

```
flutter run
```

---

# Hardware Requirements

* Android smartphone (Android 8.0 or above recommended)
* PC/Laptop with minimum **8 GB RAM**
* Processor **2.0 GHz or higher**
* Internet connection (for dataset download and updates)

---

# Future Improvements

Possible enhancements include:

* phishing risk scoring
* phishing dashboard and analytics
* QR code phishing detection
* browser link monitoring
* threat intelligence integration

---

# Authors

**Amar Mishra**
B.Tech Computer Science & Engineering

**Team Members**

* Amar Mishra
* Anal Sinha
* Atul Bhoy

Bhilai Institute of Technology, Durg

---

# License

This project is developed for **educational and research purposes**.
