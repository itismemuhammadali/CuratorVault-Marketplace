# Vintage Vinne - Backend & Firebase Emulator Guide

This document contains **every single command** and configuration step needed to run the **Firebase Emulator Suite** and the **Python FastAPI Backend** locally without requiring live client credentials or VPS hosting.

---

## 🚀 Quick Start (All-in-One Commands)

### 1. Start Firebase Emulator Suite
Runs local Firestore, Authentication, Storage, and interactive Web UI Dashboard (persisting local data to `./emulator-data`):
```bash
npm run emulators
```
> **Emulator UI Dashboard**: [http://127.0.0.1:4000](http://127.0.0.1:4000)

### 2. Start Python FastAPI Backend
Runs the Python backend connected to the local Firebase Emulators:
```bash
npm run backend:dev
```
> **Backend API Docs (Swagger)**: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)  
> **Health Check Endpoint**: [http://127.0.0.1:8000/health](http://127.0.0.1:8000/health)

---

## 🔑 Default Admin App Credentials

The following admin user has been created in the Firebase Auth & Firestore Emulators and saved to `./emulator-data`:

- **Email**: `admin@vintagevinne.com`
- **Password**: `AdminPassword123!`
- **Role**: `admin`

To re-seed or generate new admin credentials at any time, run:
```bash
npm run seed:admin
```

## 🛠️ Port Reference Table

| Service / Component | Host & Port | Description |
|---|---|---|
| **Firebase Emulator UI** | `http://127.0.0.1:4000` | Web interface to inspect Auth users, Firestore docs, and Storage files |
| **Firestore Emulator** | `127.0.0.1:8080` | Local NoSQL database server |
| **Authentication Emulator** | `127.0.0.1:9099` | Local auth server (supports Email/Password, Phone, Google logins) |
| **Storage Emulator** | `127.0.0.1:9199` | Local file/image bucket storage |
| **Functions Emulator** | `127.0.0.1:5001` | Local Cloud Functions trigger server |
| **Python FastAPI Backend** | `http://127.0.0.1:8000` | Local Python API backend server |

---

## 📋 Comprehensive Command Reference

### Firebase Emulator Commands

| Purpose | Command |
|---|---|
| **Start emulators (with auto import/export)** | `npm run emulators` |
| **Start emulators (fresh state)** | `npm run emulators:start` |
| **Export current emulator data manually** | `npm run emulators:export` |
| **CLI alternative command** | `npx firebase-tools emulators:start --import=./emulator-data --export-on-exit` |

### Python Backend Commands

| Purpose | Command |
|---|---|
| **Activate virtual environment** | `source backend/.venv/bin/activate` |
| **Run backend server (reload mode)** | `npm run backend:dev` |
| **Run backend server via uvicorn directly** | `backend/.venv/bin/uvicorn app.main:app --reload --port 8000` |
| **Install new python package** | `backend/.venv/bin/pip install <package_name>` |
| **Freeze dependencies** | `backend/.venv/bin/pip freeze > backend/requirements.txt` |
| **Re-install all dependencies** | `backend/.venv/bin/pip install -r backend/requirements.txt` |

---

## 💻 Flutter App Integration Guide

To connect any of the Flutter apps (`apps/admin`, `apps/customer`, `apps/dealer`) to the local Firebase emulators and Python backend, update the initialization in `lib/main.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Local Demo Project Configuration
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "demo-key",
      appId: "demo-app-id",
      messagingSenderId: "1234567890",
      projectId: "demo-vintage-vinne",
      storageBucket: "demo-vintage-vinne.appspot.com",
    ),
  );

  if (kDebugMode) {
    // Connect Flutter SDKs to local Emulators
    FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
    await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
    await FirebaseStorage.instance.useStorageEmulator('127.0.0.1', 9199);
  }

  runApp(const MyApp());
}
```

---

## 🐍 Python Backend Architecture

Located in [`/backend`](file:///Users/muhammadali3000/development/Vintage_Vinne/backend):

```
backend/
├── .venv/                 # Python 3.14 virtual environment
├── app/
│   ├── __init__.py
│   ├── config.py          # Settings and emulator host definitions
│   └── main.py            # FastAPI entrypoint & Firebase Admin SDK initialization
├── .env.example           # Environment template
└── requirements.txt       # Frozen dependencies (fastapi, firebase-admin, google-genai, etc.)
```

### How Python Connects to Emulators
In `app/main.py`, the following environment variables are set before initializing `firebase_admin`:
- `FIRESTORE_EMULATOR_HOST=127.0.0.1:8080`
- `FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099`
- `STORAGE_EMULATOR_HOST=http://127.0.0.1:9199`

This instructs the official Google `firebase-admin` SDK to redirect all database and auth operations to the local Firebase Emulator Suite without requiring GCP or service account keys.
