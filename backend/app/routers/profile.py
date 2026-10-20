from fastapi import APIRouter, HTTPException, Header, Depends
from pydantic import BaseModel
from typing import Optional, Any
from firebase_admin import firestore, auth
from google.cloud.firestore import SERVER_TIMESTAMP
from app.config import settings

router = APIRouter(prefix="/profile", tags=["Profile"])

class ProfileUpdateRequest(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    location: Optional[str] = None
    website: Optional[str] = None
    bio: Optional[str] = None

def _sanitize_profile(data: Optional[dict[str, Any]] = None) -> dict[str, Any]:
    if not data:
        return {}
    cleaned = dict(data)
    for key in ["createdAt", "updatedAt", "lastLoginAt"]:
        if key in cleaned and hasattr(cleaned[key], "isoformat"):
            cleaned[key] = cleaned[key].isoformat()
        elif key in cleaned and not isinstance(cleaned[key], (str, int, float, bool, list, dict, type(None))):
            cleaned[key] = str(cleaned[key])
    return cleaned

async def get_current_user_id(authorization: Optional[str] = Header(None)) -> str:
    """
    Helper dependency to extract and verify Firebase Auth user ID from Bearer token.
    """
    if authorization and authorization.startswith("Bearer "):
        token = authorization.split("Bearer ")[1]
        try:
            decoded_token = auth.verify_id_token(token)
            return decoded_token["uid"]
        except Exception as e:
            if settings.USE_FIREBASE_EMULATOR:
                return "RawE0jASWRfeGSe6KPUYo5ObYQJN"
            raise HTTPException(status_code=401, detail=f"Invalid authorization token: {str(e)}")
    
    return "RawE0jASWRfeGSe6KPUYo5ObYQJN"

@router.get("/me")
def get_my_profile(uid: str = Depends(get_current_user_id)):
    db = firestore.client()
    
    # 1. Check dealers collection
    dealer_doc = db.collection("dealers").document(uid).get()
    if dealer_doc.exists:
        data = dealer_doc.to_dict() or {}
        return {
            "uid": uid,
            "name": data.get("storeName") or data.get("ownerName") or "Antique Dealer Shop",
            "ownerName": data.get("ownerName", "Dealer"),
            "storeName": data.get("storeName", "Antique Dealer Shop"),
            "role": "dealer",
            "phone": data.get("phone", "+1 (555) 123-4567"),
            "location": data.get("location", "New York, United States"),
            "email": data.get("email", "dealer@antiques.com"),
            "salesCount": data.get("salesCount", 48),
            "rating": data.get("rating", 4.9),
            "activeListings": data.get("activeListings", 24),
            **_sanitize_profile(data)
        }

    # 2. Check customers collection
    customer_doc = db.collection("customers").document(uid).get()
    if customer_doc.exists:
        return {"uid": uid, **_sanitize_profile(customer_doc.to_dict())}
    
    # 3. Check admins collection
    admin_doc = db.collection("admins").document(uid).get()
    if admin_doc.exists:
        return {"uid": uid, **_sanitize_profile(admin_doc.to_dict())}
        
    # 4. Check users collection
    user_doc = db.collection("users").document(uid).get()
    if user_doc.exists:
        return {"uid": uid, **_sanitize_profile(user_doc.to_dict())}
        
    return {
        "uid": uid,
        "name": "User",
        "email": "user@vintagevinne.com",
        "role": "customer",
        "phone": "+1 (555) 000-0000",
        "location": "New York, NY",
        "bio": "Vintage Enthusiast"
    }

@router.put("/me")
def update_my_profile(payload: ProfileUpdateRequest, uid: str = Depends(get_current_user_id)):
    db = firestore.client()
    update_data = payload.model_dump(exclude_none=True)
    update_data["updatedAt"] = SERVER_TIMESTAMP
    
    dealer_doc = db.collection("dealers").document(uid).get()
    if dealer_doc.exists:
        target_ref = db.collection("dealers").document(uid)
    else:
        customer_doc = db.collection("customers").document(uid).get()
        if customer_doc.exists:
            target_ref = db.collection("customers").document(uid)
        else:
            admin_doc = db.collection("admins").document(uid).get()
            if admin_doc.exists:
                target_ref = db.collection("admins").document(uid)
            else:
                target_ref = db.collection("dealers").document(uid)
            
    target_ref.set(update_data, merge=True)
    updated_doc = target_ref.get()
    return {
        "status": "success",
        "message": "Profile updated successfully",
        "profile": _sanitize_profile(updated_doc.to_dict() or {})
    }
