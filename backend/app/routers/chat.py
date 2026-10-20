import uuid
from datetime import datetime
from typing import Optional, List, Dict, Any
from fastapi import APIRouter, HTTPException, Depends, Header
from pydantic import BaseModel
from firebase_admin import firestore
from app.routers.items import get_current_user_id

router = APIRouter(tags=["Chat & Messaging"])

class SendMessageRequest(BaseModel):
    recipientId: str
    recipientName: Optional[str] = "Dealer"
    message: str
    productId: Optional[str] = None
    productTitle: Optional[str] = None

@router.get("/chats")
def get_user_chats(user_id: str = Depends(get_current_user_id)):
    """Fetches list of active chat threads for the current user."""
    db = firestore.client()
    docs = db.collection("chats").where("participants", "array_contains", user_id).stream()
    
    chats = []
    for doc in docs:
        chats.append({"id": doc.id, **doc.to_dict()})
        
    return {"chats": chats, "count": len(chats)}

@router.get("/chats/{chat_id}/messages")
def get_chat_messages(chat_id: str, user_id: str = Depends(get_current_user_id)):
    """Fetches ordered message history for a specific chat."""
    db = firestore.client()
    docs = db.collection("chats").document(chat_id).collection("messages").order_by("timestamp").stream()
    
    messages = [{"id": doc.id, **doc.to_dict()} for doc in docs]
    return {"chatId": chat_id, "messages": messages, "count": len(messages)}

@router.post("/chats/{chat_id}/messages")
def send_message(chat_id: str, req: SendMessageRequest, user_id: str = Depends(get_current_user_id)):
    """Sends a message in an existing or new chat thread."""
    db = firestore.client()
    chat_ref = db.collection("chats").document(chat_id)
    
    msg_id = f"msg_{uuid.uuid4().hex[:8]}"
    now_iso = datetime.now().isoformat()
    
    msg_data = {
        "id": msg_id,
        "senderId": user_id,
        "recipientId": req.recipientId,
        "message": req.message,
        "timestamp": now_iso,
        "productId": req.productId,
        "productTitle": req.productTitle,
    }
    
    # Save message in subcollection
    chat_ref.collection("messages").document(msg_id).set(msg_data)
    
    # Update parent chat document
    chat_ref.set({
        "id": chat_id,
        "participants": [user_id, req.recipientId],
        "lastMessage": req.message,
        "lastMessageTime": now_iso,
        "lastSenderId": user_id,
        "recipientName": req.recipientName,
        "productId": req.productId,
        "productTitle": req.productTitle,
    }, merge=True)
    
    return {"status": "sent", "message": msg_data}
