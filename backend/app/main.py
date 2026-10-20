import os
from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
import firebase_admin
from firebase_admin import credentials, firestore, auth, storage
from app.config import settings
from app.routers import profile, events, items, orders, offers, chat, wallet, reviews, notifications

# Configure Firebase Emulators if running in local/dev mode
if settings.USE_FIREBASE_EMULATOR:
    os.environ["FIRESTORE_EMULATOR_HOST"] = settings.FIRESTORE_EMULATOR_HOST
    os.environ["FIREBASE_AUTH_EMULATOR_HOST"] = settings.FIREBASE_AUTH_EMULATOR_HOST
    os.environ["STORAGE_EMULATOR_HOST"] = f"http://{settings.FIREBASE_STORAGE_EMULATOR_HOST}"
    os.environ["GCLOUD_PROJECT"] = settings.FIREBASE_PROJECT_ID

class EmulatorCredential(credentials.Base):
    """Custom credential class to allow Firebase Admin SDK to communicate with local emulators without live GCP credentials."""
    def __init__(self, project_id: str):
        self.project_id = project_id
    def get_credential(self):
        import google.auth.credentials
        return google.auth.credentials.AnonymousCredentials()
    def get_project_id(self):
        return self.project_id

# Initialize Firebase Admin App
if not firebase_admin._apps:
    if settings.USE_FIREBASE_EMULATOR:
        cred = EmulatorCredential(settings.FIREBASE_PROJECT_ID)
        firebase_admin.initialize_app(cred, options={
            "projectId": settings.FIREBASE_PROJECT_ID,
            "storageBucket": f"{settings.FIREBASE_PROJECT_ID}.appspot.com"
        })
    else:
        firebase_admin.initialize_app(options={
            "projectId": settings.FIREBASE_PROJECT_ID,
            "storageBucket": f"{settings.FIREBASE_PROJECT_ID}.appspot.com"
        })

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="Backend API for Vintage Vinne (Admin, Customer, Dealer)",
    version="1.0.0"
)

# Enable CORS for Flutter Web / Mobile apps
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API Routers under /api/v1
app.include_router(profile.router, prefix="/api/v1")
app.include_router(events.router, prefix="/api/v1")
app.include_router(items.router, prefix="/api/v1")
app.include_router(orders.router, prefix="/api/v1")
app.include_router(offers.router, prefix="/api/v1")
app.include_router(chat.router, prefix="/api/v1")
app.include_router(wallet.router, prefix="/api/v1")
app.include_router(reviews.router, prefix="/api/v1")
app.include_router(notifications.router, prefix="/api/v1")

@app.get("/")
def read_root():
    return {
        "status": "online",
        "app": settings.PROJECT_NAME,
        "environment": settings.ENVIRONMENT,
        "emulator_mode": settings.USE_FIREBASE_EMULATOR,
        "project_id": settings.FIREBASE_PROJECT_ID
    }

@app.get("/health")
def health_check():
    # Verify connection to Firestore Emulator
    db = firestore.client()
    doc_ref = db.collection("health_checks").document("ping")
    doc_ref.set({"timestamp": firestore.SERVER_TIMESTAMP, "status": "ok"})
    return {"status": "healthy", "firestore_emulator": "connected"}

@app.get("/api/v1/items")
def list_items():
    db = firestore.client()
    items_ref = db.collection("items").stream()
    items = [{"id": item.id, **item.to_dict()} for item in items_ref]
    return {"items": items}
