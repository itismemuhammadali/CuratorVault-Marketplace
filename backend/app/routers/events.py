from fastapi import APIRouter, HTTPException, Header, Depends
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime, timezone
from firebase_admin import firestore, auth
from google.cloud.firestore import SERVER_TIMESTAMP

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
    status: Optional[str] = None
    reward_points: Optional[int] = 500

def determine_event_status(start_date_str: str, end_date_str: str, explicit_status: Optional[str] = None) -> str:
    if explicit_status and explicit_status.strip():
        norm = explicit_status.strip().capitalize()
        if norm in ["Upcoming", "Ongoing", "Past"]:
            return norm
    try:
        now = datetime.now()
        def parse_date(s):
            if not s:
                return None
            for fmt in ("%m/%d/%Y", "%Y-%m-%d", "%d/%m/%Y", "%m-%d-%Y"):
                try:
                    return datetime.strptime(s.strip(), fmt)
                except ValueError:
                    continue
            return None
        start = parse_date(start_date_str)
        end = parse_date(end_date_str)
        if start and end:
            if now.date() < start.date():
                return "Upcoming"
            elif now.date() > end.date():
                return "Past"
            else:
                return "Ongoing"
        elif start:
            if now.date() < start.date():
                return "Upcoming"
            elif now.date() == start.date():
                return "Ongoing"
            else:
                return "Past"
    except Exception:
        pass
    return "Upcoming"

class EventUpdateRequest(BaseModel):
    title: Optional[str] = None
    event_type: Optional[str] = None
    description: Optional[str] = None
    is_virtual: Optional[bool] = None
    location: Optional[str] = None
    start_date: Optional[str] = None
    start_time: Optional[str] = None
    end_date: Optional[str] = None
    end_time: Optional[str] = None
    visibility: Optional[str] = None
    status: Optional[str] = None
    reward_points: Optional[int] = None

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
    
    event_data = payload.model_dump()
    now_iso = datetime.now(timezone.utc).isoformat()
    status = determine_event_status(payload.start_date, payload.end_date, payload.status)
    event_data["status"] = status
    
    firestore_data = {
        **event_data,
        "created_by": uid,
        "createdAt": SERVER_TIMESTAMP,
        "participants_count": 0
    }
    
    doc_ref = events_ref.add(firestore_data)
    event_id = doc_ref[1].id
    
    return {
        "status": "success",
        "message": "Event created successfully",
        "event_id": event_id,
        "event": {
            "id": event_id,
            **event_data,
            "created_by": uid,
            "createdAt": now_iso,
            "status": "Ongoing"
        }
    }

@router.get("")
def list_events():
    db = firestore.client()
    events_stream = db.collection("events").stream()
    
    events = []
    for doc in events_stream:
        data = doc.to_dict() or {}
        if "createdAt" in data:
            if hasattr(data["createdAt"], "isoformat"):
                data["createdAt"] = data["createdAt"].isoformat()
            else:
                data["createdAt"] = str(data["createdAt"])
        if "updatedAt" in data:
            if hasattr(data["updatedAt"], "isoformat"):
                data["updatedAt"] = data["updatedAt"].isoformat()
            else:
                data["updatedAt"] = str(data["updatedAt"])
        events.append({"id": doc.id, **data})
        
    return {
        "status": "success",
        "count": len(events),
        "events": events
    }

@router.get("/{event_id}")
def get_event(event_id: str):
    db = firestore.client()
    doc = db.collection("events").document(event_id).get()
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Event not found")
    data = doc.to_dict() or {}
    if "createdAt" in data and hasattr(data["createdAt"], "isoformat"):
        data["createdAt"] = data["createdAt"].isoformat()
    if "updatedAt" in data and hasattr(data["updatedAt"], "isoformat"):
        data["updatedAt"] = data["updatedAt"].isoformat()
    return {"status": "success", "event": {"id": doc.id, **data}}

@router.put("/{event_id}")
def update_event(event_id: str, payload: EventUpdateRequest, uid: str = Depends(get_current_user_id)):
    db = firestore.client()
    doc_ref = db.collection("events").document(event_id)
    doc = doc_ref.get()
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Event not found")
        
    update_data = payload.model_dump(exclude_none=True)
    update_data["updatedAt"] = SERVER_TIMESTAMP
    doc_ref.set(update_data, merge=True)
    
    updated_doc = doc_ref.get().to_dict() or {}
    if "createdAt" in updated_doc and hasattr(updated_doc["createdAt"], "isoformat"):
        updated_doc["createdAt"] = updated_doc["createdAt"].isoformat()
    if "updatedAt" in updated_doc and hasattr(updated_doc["updatedAt"], "isoformat"):
        updated_doc["updatedAt"] = updated_doc["updatedAt"].isoformat()
        
    return {"status": "success", "message": "Event updated successfully", "event": {"id": event_id, **updated_doc}}

@router.delete("/{event_id}")
def delete_event(event_id: str, uid: str = Depends(get_current_user_id)):
    db = firestore.client()
    doc_ref = db.collection("events").document(event_id)
    if not doc_ref.get().exists:
        raise HTTPException(status_code=404, detail="Event not found")
    doc_ref.delete()
    return {"status": "success", "message": "Event deleted successfully"}
