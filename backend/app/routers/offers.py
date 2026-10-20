import uuid
from datetime import datetime
from typing import Optional, List, Dict, Any
from fastapi import APIRouter, HTTPException, Depends, Header
from pydantic import BaseModel
from firebase_admin import firestore
from app.routers.items import get_current_user_id

router = APIRouter(tags=["Offers & Negotiation"])

class MakeOfferRequest(BaseModel):
    productId: str
    productTitle: str
    productPrice: float
    offeredPrice: float
    message: Optional[str] = None
    sellerId: Optional[str] = "dealer_london_antiques"
    sellerName: Optional[str] = "London Heritage Antiques"
    imageUrl: Optional[str] = "assets/images/home_product_one.png"

class RespondOfferRequest(BaseModel):
    status: str  # Accepted, Declined, Countered
    counterPrice: Optional[float] = None
    message: Optional[str] = None

@router.post("/offers")
def create_offer(req: MakeOfferRequest, user_id: str = Depends(get_current_user_id)):
    """Submits a buyer's offer on a product."""
    db = firestore.client()
    offer_id = f"off_{uuid.uuid4().hex[:8]}"
    
    offer_data = {
        "id": offer_id,
        "buyerId": user_id,
        "productId": req.productId,
        "productTitle": req.productTitle,
        "originalPrice": req.productPrice,
        "offeredPrice": req.offeredPrice,
        "message": req.message,
        "sellerId": req.sellerId,
        "sellerName": req.sellerName,
        "imageUrl": req.imageUrl,
        "status": "Pending",
        "createdAt": datetime.now().isoformat()
    }
    
    db.collection("offers").document(offer_id).set(offer_data)
    return {"status": "submitted", "offer": offer_data}

@router.get("/offers")
def list_offers(user_id: str = Depends(get_current_user_id)):
    """Lists incoming and outgoing offers for the user."""
    db = firestore.client()
    buyer_docs = db.collection("offers").where("buyerId", "==", user_id).stream()
    seller_docs = db.collection("offers").where("sellerId", "==", user_id).stream()
    
    offers = []
    seen = set()
    for doc in list(buyer_docs) + list(seller_docs):
        if doc.id not in seen:
            seen.add(doc.id)
            offers.append({"id": doc.id, **doc.to_dict()})
            
    return {"offers": offers, "count": len(offers)}

@router.post("/offers/{offer_id}/respond")
def respond_to_offer(offer_id: str, req: RespondOfferRequest, user_id: str = Depends(get_current_user_id)):
    """Accepts, declines, or counters an offer."""
    db = firestore.client()
    ref = db.collection("offers").document(offer_id)
    doc = ref.get()
    
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Offer not found")
        
    update_data = {
        "status": req.status,
        "respondedAt": datetime.now().isoformat()
    }
    if req.counterPrice:
        update_data["counterPrice"] = req.counterPrice
    if req.message:
        update_data["responseMessage"] = req.message
        
    ref.update(update_data)
    return {"status": "updated", "offerId": offer_id, **update_data}
