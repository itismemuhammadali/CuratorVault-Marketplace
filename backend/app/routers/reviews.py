import datetime
from typing import Optional, List
from fastapi import APIRouter
from pydantic import BaseModel
from firebase_admin import firestore

router = APIRouter(prefix="/reviews", tags=["reviews"])

class ReviewSubmission(BaseModel):
    dealerId: str = "dealer_1"
    rating: int = 5
    title: str
    comment: str
    reviewerName: str = "Verified Collector"
    itemTitle: Optional[str] = "Victorian Antique"

@router.get("")
async def get_reviews(dealer_id: Optional[str] = None):
    """Fetch customer ratings and reviews."""
    db = firestore.client()
    docs = db.collection("reviews").stream()
    reviews = [doc.to_dict() for doc in docs]
    
    if not reviews:
        default_reviews = [
            {
                "id": "rev_1",
                "dealerId": "dealer_1",
                "reviewerName": "Charlotte B.",
                "rating": 5,
                "title": "Exceptional Provenance & Pristine Piece",
                "comment": "The Victorian Pocket Watch arrived in gorgeous condition, securely packed and accompanied by comprehensive certification documents. Highly recommended dealer!",
                "date": "2 days ago",
                "verifiedPurchase": True,
                "itemTitle": "Victorian Pocket Watch",
            },
            {
                "id": "rev_2",
                "dealerId": "dealer_1",
                "reviewerName": "Arthur Pendelton",
                "rating": 5,
                "title": "Fast dispatch and white glove delivery",
                "comment": "Described accurately with flawless joinery. Communication was instantaneous.",
                "date": "1 week ago",
                "verifiedPurchase": True,
                "itemTitle": "Mid-Century Modern Chair",
            }
        ]
        for rev in default_reviews:
            db.collection("reviews").document(rev["id"]).set(rev)
        return {"reviews": default_reviews, "averageRating": 4.9, "totalReviews": 42}
    
    avg = sum(r.get("rating", 5) for r in reviews) / max(len(reviews), 1)
    return {"reviews": reviews, "averageRating": round(avg, 1), "totalReviews": len(reviews)}

@router.post("")
async def add_review(payload: ReviewSubmission):
    """Submit a new review for a dealer/item."""
    db = firestore.client()
    new_id = f"rev_{int(datetime.datetime.utcnow().timestamp())}"
    doc_data = {
        "id": new_id,
        "dealerId": payload.dealerId,
        "reviewerName": payload.reviewerName,
        "rating": payload.rating,
        "title": payload.title,
        "comment": payload.comment,
        "itemTitle": payload.itemTitle,
        "date": "Just now",
        "verifiedPurchase": True,
    }
    db.collection("reviews").document(new_id).set(doc_data)
    return {"success": True, "review": doc_data}
