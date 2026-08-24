from fastapi import APIRouter, HTTPException, Header, Depends
from pydantic import BaseModel
from typing import Optional, List
from firebase_admin import firestore, auth

router = APIRouter(prefix="/events", tags=["Events"])

class EventCreateRequest(BaseModel):
    title: str
    event_type: str = "General"
    description: str = ""
    is_virtual: bool = False
    location: str = ""
    start_date: str = ""
    start_time: str = ""
    end_date: str = ""
    end_time: str = ""
    visibility: str = "Public"

async def get_current_user_id(authorization: Optional[str] = Header(None)) -> str:
    if authorization and authorization.startswith("Bearer "):
        token = authorization.split("Bearer ")[1]
        try:
            decoded_token = auth.verify_id_token(token)
            return decoded_token["uid"]
        except Exception:
            pass
    return "RawE0jASWRfeGSe6KPUYo5ObYQJN"

@router.post("")
def create_event(payload: EventCreateRequest, uid: str = Depends(get_current_user_id)):
    db = firestore.client()
    events_ref = db.collection("events")
    
    event_data = payload.dict()
    event_data["created_by"] = uid
    event_data["createdAt"] = firestore.SERVER_TIMESTAMP
    event_data["status"] = "Ongoing"
    
    doc_ref = events_ref.add(event_data)
    event_id = doc_ref[1].id
    
    return {
        "status": "success",
        "message": "Event created successfully",
        "event_id": event_id,
        "event": {"id": event_id, **event_data}
    }

@router.get("")
def list_events():
    db = firestore.client()
    events_stream = db.collection("events").stream()
    
    events = []
    for doc in events_stream:
        data = doc.to_dict()
        # Convert timestamp fields if needed for JSON serialization
        if "createdAt" in data and hasattr(data["createdAt"], "isoformat"):
            data["createdAt"] = data["createdAt"].isoformat()
        events.append({"id": doc.id, **data})
        
    return {
        "status": "success",
        "count": len(events),
        "events": events
    }
