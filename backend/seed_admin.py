import sys
import os
from pathlib import Path

# Automatically locate and register the backend/.venv site-packages
backend_dir = Path(__file__).resolve().parent
venv_site_packages = backend_dir / ".venv" / "lib" / f"python{sys.version_info.major}.{sys.version_info.minor}" / "site-packages"
if venv_site_packages.exists() and str(venv_site_packages) not in sys.path:
    sys.path.insert(0, str(venv_site_packages))

import firebase_admin
from firebase_admin import auth, firestore
import google.auth.credentials
from google.cloud import firestore as google_firestore

# Configure environment to target local Firebase Emulators
os.environ["FIRESTORE_EMULATOR_HOST"] = os.getenv("FIRESTORE_EMULATOR_HOST", "127.0.0.1:8080")
os.environ["FIREBASE_AUTH_EMULATOR_HOST"] = os.getenv("FIREBASE_AUTH_EMULATOR_HOST", "127.0.0.1:9099")

PROJECT_ID = "demo-vintage-vinne"

if not firebase_admin._apps:
    firebase_admin.initialize_app(options={"projectId": PROJECT_ID})

def seed_admin_credentials():
    email = "admin@vintagevinne.com"
    password = "AdminPassword123!"
    display_name = "System Admin"

    print("Checking / Creating default Admin user in Firebase Auth Emulator...")
    try:
        user = auth.get_user_by_email(email)
        print(f"✔ Admin user exists in Auth Emulator (UID: {user.uid})")
    except auth.UserNotFoundError:
        user = auth.create_user(
            email=email,
            password=password,
            display_name=display_name,
            email_verified=True
        )
        print(f"✔ Created default Admin user in Auth Emulator (UID: {user.uid})")

    # Connect to Firestore Emulator without requiring GCP credentials
    db = google_firestore.Client(
        project=PROJECT_ID,
        credentials=google.auth.credentials.AnonymousCredentials()
    )

    admin_ref = db.collection("admins").document(user.uid)
    admin_ref.set({
        "uid": user.uid,
        "email": email,
        "name": display_name,
        "role": "admin",
        "status": "active",
        "createdAt": google_firestore.SERVER_TIMESTAMP
    }, merge=True)
    print(f"✔ Created Admin profile document in Firestore Emulator under 'admins/{user.uid}'")
    print("\n" + "="*50)
    print("🔑 ADMIN LOGIN CREDENTIALS:")
    print(f"   Email:    {email}")
    print(f"   Password: {password}")
    print("="*50)

if __name__ == "__main__":
    seed_admin_credentials()
