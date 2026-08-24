import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME: str = "Vintage Vinne API"
    ENVIRONMENT: str = os.getenv("ENVIRONMENT", "development")
    FIREBASE_PROJECT_ID: str = os.getenv("FIREBASE_PROJECT_ID", "demo-vintage-vinne")
    
    # Emulator Settings
    USE_FIREBASE_EMULATOR: bool = os.getenv("USE_FIREBASE_EMULATOR", "true").lower() == "true"
    FIRESTORE_EMULATOR_HOST: str = os.getenv("FIRESTORE_EMULATOR_HOST", "127.0.0.1:8080")
    FIREBASE_AUTH_EMULATOR_HOST: str = os.getenv("FIREBASE_AUTH_EMULATOR_HOST", "127.0.0.1:9099")
    FIREBASE_STORAGE_EMULATOR_HOST: str = os.getenv("FIREBASE_STORAGE_EMULATOR_HOST", "127.0.0.1:9199")
    
    # AI / Gemini API
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")

settings = Settings()
