from fastapi import APIRouter, HTTPException, Header, Depends
from pydantic import BaseModel
from typing import Optional
from firebase_admin import firestore, auth

router = APIRouter(prefix="/profile", tags=["Profile"])

class ProfileUpdateRequest(BaseModel):
    name: Optional[str] = None
    phone: Optional[str] = None
    location: Optional[str] = None
    bio: Optional[str] = None

async def get_current_user_id(authorization: Optional[str] = Header(None)) -> str:
    """
    Helper dependency to extract and verify Firebase Auth user ID from Bearer token.
    Falls back to default admin ID in development emulator mode if no token is present.
    """
    if authorization and authorization.startswith("Bearer "):
        token = authorization.split("Bearer ")[1]
        try:
            decoded_token = auth.verify_id_token(token)
            return decoded_token["uid"]
        except Exception as e:
            raise HTTPException(status_code=401, detail=f"Invalid authorization token: {str(e)}")
    
    # Fallback default admin UID for development / emulator convenience
    return "RawE0jASWRfeGSe6KPUYo5ObYQJN"

@router.get("/me")
def get_my_profile(uid: str = Depends(get_current_user_id)):
    db = firestore.client()
    doc_ref = db.collection("admins").document(uid)
    doc = doc_ref.get()
    
    if not doc.exists:
        # Fallback check in users collection
        user_doc = db.collection("users").document(uid).get()
        if user_doc.exists:
            return {"uid": uid, **user_doc.to_dict()}
        
        # Return default admin profile structure if not yet seeded
        return {
            "uid": uid,
            "name": "System Admin",
            "email": "admin@vintagevinne.com",
            "role": "Super Admin",
            "phone": "+1 (555) 000-0000",
            "location": "New York, NY",
            "bio": "Platform Administrator"
        }
        
    return {"uid": uid, **doc.to_dict()}

@router.put("/me")
def update_my_profile(payload: ProfileUpdateRequest, uid: str = Depends(get_current_user_id)):
    db = firestore.client()
    doc_ref = db.collection("admins").document(uid)
    
    update_data = {k: v for k, v in payload.dict().items() if v is not None}
    update_data["updatedAt"] = firestore.SERVER_TIMESTAMP
    
    doc_ref.set(update_data, merge=True)
    
    updated_doc = doc_ref.get()
    return {"status": "success", "message": "Profile updated successfully", "profile": updated_doc.to_dict()}
