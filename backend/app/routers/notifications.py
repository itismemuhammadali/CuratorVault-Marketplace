import uuid
from datetime import datetime
from typing import Optional, List, Dict, Any
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from firebase_admin import firestore
from app.routers.items import get_current_user_id

router = APIRouter(prefix="/notifications", tags=["Notifications"])

class CreateNotificationRequest(BaseModel):
    title: str
    body: str
    type: str = "system"  # "order", "offer", "message", "system", "event"
    actionUrl: Optional[str] = None
    targetUserId: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None

@router.get("")
def get_notifications(user_id: str = Depends(get_current_user_id)):
    """Fetch notifications for the active user, creating defaults if none exist."""
    db = firestore.client()
    docs = db.collection("notifications").where("userId", "==", user_id).stream()
    items = [{"id": doc.id, **doc.to_dict()} for doc in docs]
    
    if not items:
        # Pre-seed realistic notifications for seamless initial testing
        initial_notifications = [
            {
                "id": "notif_1",
                "userId": user_id,
                "title": "Order Shipped via DHL Express",
                "body": "Your order #ORD-1001 is on its way with tracking number DHL8492019482.",
                "type": "order",
                "isRead": False,
                "actionUrl": "/user/orders/track/ORD-1001",
                "createdAt": datetime.now().isoformat(),
                "timeAgo": "10m ago"
            },
            {
                "id": "notif_2",
                "userId": user_id,
                "title": "New Counter-Offer Received",
                "body": "London Heritage Antiques countered your offer with $1,350 for Victorian Pocket Watch.",
                "type": "offer",
                "isRead": False,
                "actionUrl": "/user/my-finds/offers",
                "createdAt": datetime.now().isoformat(),
                "timeAgo": "1h ago"
            },
            {
                "id": "notif_3",
                "userId": user_id,
                "title": "Funds Secured in Escrow",
                "body": "Payment of $1,611.00 is safely held in Escrow until you inspect and approve the delivery.",
                "type": "wallet",
                "isRead": True,
                "actionUrl": "/user/wallet/escrow",
                "createdAt": datetime.now().isoformat(),
                "timeAgo": "1d ago"
            }
        ]
        for notif in initial_notifications:
            db.collection("notifications").document(notif["id"]).set(notif)
        items = initial_notifications

    # Sort newest first
    items.sort(key=lambda x: x.get("createdAt", ""), reverse=True)
    unread_count = sum(1 for n in items if not n.get("isRead", False))
    
    return {
        "notifications": items,
        "unreadCount": unread_count,
        "total": len(items)
    }

@router.post("")
def create_notification(req: CreateNotificationRequest, user_id: str = Depends(get_current_user_id)):
    """Creates a notification for the specified user or current user."""
    db = firestore.client()
    target_user = req.targetUserId or user_id
    notif_id = f"notif_{uuid.uuid4().hex[:8]}"
    
    notif_data = {
        "id": notif_id,
        "userId": target_user,
        "title": req.title,
        "body": req.body,
        "type": req.type,
        "isRead": False,
        "actionUrl": req.actionUrl,
        "metadata": req.metadata or {},
        "createdAt": datetime.now().isoformat(),
        "timeAgo": "Just now"
    }
    
    db.collection("notifications").document(notif_id).set(notif_data)
    return {"status": "created", "notification": notif_data}

@router.put("/{notification_id}/read")
def mark_as_read(notification_id: str, user_id: str = Depends(get_current_user_id)):
    """Marks a single notification as read."""
    db = firestore.client()
    doc_ref = db.collection("notifications").document(notification_id)
    doc = doc_ref.get()
    
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Notification not found")
        
    doc_ref.update({"isRead": True})
    return {"status": "success", "id": notification_id, "isRead": True}

@router.put("/read-all")
def mark_all_as_read(user_id: str = Depends(get_current_user_id)):
    """Marks all notifications of the user as read."""
    db = firestore.client()
    docs = db.collection("notifications").where("userId", "==", user_id).stream()
    
    count = 0
    for doc in docs:
        doc.reference.update({"isRead": True})
        count += 1
        
    return {"status": "success", "markedReadCount": count}
